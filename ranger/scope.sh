#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

# Arguments from Ranger
FILE_PATH="${1}"         # Full path of highlighted file
PV_WIDTH="${2}"          # Width of preview pane in characters
PV_HEIGHT="${3}"         # Height of preview pane in characters
IMAGE_CACHE_PATH="${4}"  # Path to store image preview
PV_IMAGE_ENABLED="${5}"  # 'True' if image previews are enabled

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

HIGHLIGHT_SIZE_MAX=262143  # 256KiB
HIGHLIGHT_TABWIDTH=${HIGHLIGHT_TABWIDTH:-8}
HIGHLIGHT_STYLE=${HIGHLIGHT_STYLE:-pablo}
HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_OPTIONS:-}"
PYGMENTIZE_STYLE=${PYGMENTIZE_STYLE:-autumn}

# ----------------------
# Handle extensions
# ----------------------
handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
        pdf)
            pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - | fmt -w "${PV_WIDTH}" && exit 5
            mutool draw -F txt -i -- "${FILE_PATH}" 1-10 | fmt -w "${PV_WIDTH}" && exit 5
            exiftool "${FILE_PATH}" && exit 5
            exit 1;;

        odt|ods|odp|sxw)
            odt2txt "${FILE_PATH}" && exit 5
            pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
            exit 1;;

        xlsx)
            xlsx2csv -- "${FILE_PATH}" && exit 5
            exit 1;;

        html|htm|xhtml)
            w3m -dump "${FILE_PATH}" && exit 5
            lynx -dump -- "${FILE_PATH}" && exit 5
            elinks -dump "${FILE_PATH}" && exit 5
            pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
            ;;

        json)
            jq --color-output . "${FILE_PATH}" && exit 5
            python -m json.tool -- "${FILE_PATH}" && exit 5
            ;;
    esac
}

# ----------------------
# Handle images
# ----------------------
handle_image() {
    local mimetype="${1}"
    case "${mimetype}" in
        image/*)
            if [[ "${PV_IMAGE_ENABLED}" == 'True' ]] && [[ "$TERM" == *kitty* ]]; then
                kitty +kitten icat --silent "$FILE_PATH"
                exit 7
            fi
            exit 1
            ;;
    esac
}

# ----------------------
# Handle mime types
# ----------------------
handle_mime() {
    local mimetype="${1}"

    case "${mimetype}" in
        text/*|*/xml)
            if [[ "$( stat --printf='%s' -- "${FILE_PATH}" )" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
                exit 2
            fi

            if [[ "$( tput colors )" -ge 256 ]]; then
                local pygmentize_format='terminal256'
                local highlight_format='xterm256'
            else
                local pygmentize_format='terminal'
                local highlight_format='ansi'
            fi

            env HIGHLIGHT_OPTIONS="${HIGHLIGHT_OPTIONS}" highlight \
                --out-format="${highlight_format}" \
                --force -- "${FILE_PATH}" && exit 5

            env COLORTERM=8bit bat --color=always --style="plain" \
                -- "${FILE_PATH}" && exit 5

            pygmentize -f "${pygmentize_format}" -O "style=${PYGMENTIZE_STYLE}" \
                -- "${FILE_PATH}" && exit 5
            exit 2
            ;;

        image/*)
            handle_image "${mimetype}"
            ;;

        video/*|audio/*)
            mediainfo "${FILE_PATH}" && exit 5
            exiftool "${FILE_PATH}" && exit 5
            exit 1;;

        *)
            exit 1
            ;;
    esac
}

# ----------------------
# Fallback
# ----------------------
handle_fallback() {
    echo '----- File Type Classification -----'
    file --dereference --brief -- "${FILE_PATH}" && exit 5
    exit 1
}

# ----------------------
# Main
# ----------------------
MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"

if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
    handle_image "${MIMETYPE}"
fi

handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1

