#!/bin/sh

set -e

echo "TAR_MODE=$TAR_MODE"
echo "TAR_FILE=$TAR_FILE"
echo "TAR_COMPRESSION=$TAR_COMPRESSION"

if [ -z "$TAR_COMPRESSION" ] || [ "auto" = $TAR_COMPRESSION ]; then
  TAR_FLAG=
  case "$TAR_FILE" in
    *.tar.gz|.tgz) TAR_FLAG=z; ;;
    *.tar.xz|.txz) TAR_FLAG=J; ;;
    *.tar.bz2|*.tb2|*.tbz|*.tbz2) TAR_FLAG=j; ;;
    *.tar.lzma|*.tlz) TAR_FLAG=a; ;;
  esac
elif [ "none" = "$TAR_COMPRESSION" ]; then
  TAR_FLAG=
else
  case "$TAR_COMPRESSION" in
    gzip) TAR_FLAG=z; ;;
    xz) TAR_FLAG=J; ;;
    bzip2) TAR_FLAG=j; ;;
    lzma) TAR_FLAG=a; ;;
    *) echo "[ERROR] Unsupported compression: $TAR_COMPRESSION" >&2
       echo "[ERROR] valid values: gzip, xz, bzip2, lzma" >&2
       exit 1
       ;;
  esac
fi

echo "TAR_FLAG=$TAR_FLAG"

if [ "$TAR_MODE" = "compress" ]; then
  tar -C task-input -c${TAR_FLAG}vf task-output/$TAR_FILE .
elif [ "$TAR_MODE" = "decompress" ]; then
  tar -x${TAR_FLAG}vf task-input/$TAR_FILE -C task-output
else
  echo "[ERROR] Unknown tar mode: $TAR_MODE" >&2
  echo "[ERROR] valid values: compress, decompress" >&2
  exit 2
fi
