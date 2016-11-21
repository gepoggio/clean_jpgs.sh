#!/bin/bash

# set "strict" mode
set -eu -o pipefail

# split word only on newlines, to properly handle spaces in file/dir names
IFS=$'\n'

SCRIPT=$(basename ${BASH_SOURCE[0]})
VERSION="0.1"
URL="https://github.com/gepoggio/clean_jpgs.sh"

RAW_EXT="dng" # default RAW extension
JPG_EXT="jpg" # default JPG extensions
VERBOSE=0
DRY_RUN=0

function usage {
  echo "Usage: ${SCRIPT} [-hvd] [-r RAW_EXT] [-j JPG_EXT] DIR"
  echo "Recursively removes JPG files from DIR when a RAW file with the same filename (different extension) exists."
  echo
  echo "  -v            verbose output"
  echo "  -d            dry run, won't remove any file(s)"
  echo "  -r RAW_EXT    set the RAW extension to RAW_EXT (defaults to dng)"
  echo "  -j JPG_EXT    set the JPG extension to JPG_EXT (defaults to jpg)"
  echo "  -h            display this help and exit"
  echo
  echo "clean_jpgs.sh ${VERSION} <${URL}>"
}

if [ $# -eq 0 ]; then
  errors="Error: No arguments passed"$'\n'
else
  errors=""

  while getopts :r:j:vdh FLAG; do
    case $FLAG in
      r)
        RAW_EXT="$OPTARG"
        ;;
      j)
        JPG_EXT="$OPTARG"
        ;;
      v)
        VERBOSE=1
        ;;
      d)
        DRY_RUN=1
        ;;
      h)
        usage
        exit 0
        ;;
      :)
        errors="${errors}Error: Argument for option '$OPTARG' not found"$'\n'
        ;;
      \?)
        errors="${errors}Error: Invalid option '$OPTARG'"$'\n'
        ;;
    esac
  done

  shift $((OPTIND-1))

  if [ $# -lt 1 ]; then
    errors="${errors}Error: No DIR specified"$'\n'
  elif [ $# -gt 1 ]; then
    errors="${errors}Error: Extra arguments found (only one DIR supported)"$'\n'
  elif [ ! -d "$1" ]; then
    errors="${errors}Error: "$1" is not a directory"$'\n'
  else
    DIR="$1"
  fi
fi

if [ ! -z "$errors" ]; then
  echo "$errors"
  usage
  exit 1
fi

[ $VERBOSE -eq 1 ] && echo "DIR: ${DIR} | RAW_EXT: ${RAW_EXT} | JPG_EXT: ${JPG_EXT} | DRY_RUN: ${DRY_RUN}"

for jpg_photo in $(find "$DIR" -type f -name "*.${JPG_EXT}"); do
  raw_filename="${jpg_photo/%${JPG_EXT}/${RAW_EXT}}"
  if [ -f "$raw_filename" ]; then
    echo -n "JPG file '${jpg_photo}' has matching RAW file '${raw_filename}: "
    [ $DRY_RUN -eq 0 ] && rm -v "$jpg_photo" || echo "dry run set, won't remove"
  else
    [ $VERBOSE -eq 1 ] && echo "JPG file '${jpg_photo}' does not have a matching RAW file, won't remove"
  fi
done

exit 0
