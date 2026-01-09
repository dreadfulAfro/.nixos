#!/usr/bin/env bash
set -euo pipefail

# ---- Safety checks ----
if [[ -z "${RADARR_MOVIEFILE_PATH:-}" ]]; then
  echo "RADARR_MOVIEFILE_PATH not set, exiting"
  exit 0
fi

INPUT="${RADARR_MOVIEFILE_PATH}"
DIR="$(dirname "$INPUT")"
BASENAME="$(basename "$INPUT")"
NAME="${BASENAME%.*}"

OUTPUT_TMP="${DIR}/${NAME}.transcoding.mp4"
OUTPUT_FINAL="${DIR}/${NAME}.mp4"

echo "Radarr transcoding: $INPUT"

# ---- Skip already compatible files ----
if ffprobe -v error -select_streams v:0 \
  -show_entries stream=codec_name,profile \
  -of default=nw=1 "$INPUT" | grep -q "codec_name=h264"; then
  echo "Video already H.264, skipping"
  exit 0
fi

# ---- Transcode ----
ffmpeg -y -i "$INPUT" \
  -map 0:v:0 -map 0:a:0? \
  -vf "scale=-2:480,fps=24000/1001" \
  -c:v libx264 \
  -preset slow \
  -profile:v high \
  -level 3.1 \
  -pix_fmt yuv420p \
  -crf 22 \
  -maxrate 1300k \
  -bufsize 2600k \
  -x264-params "nal-hrd=vbr:force-cfr=1:keyint=240:min-keyint=24:scenecut=40:bframes=3:ref=4" \
  -c:a aac \
  -b:a 96k \
  -ac 2 \
  -ar 48000 \
  -movflags +faststart \
  "$OUTPUT_TMP"

# ---- Basic validation ----
if [[ ! -s "$OUTPUT_TMP" ]]; then
  echo "Transcode failed: output file empty"
  exit 1
fi

# ---- Replace original ----
mv "$OUTPUT_TMP" "$OUTPUT_FINAL"

# Optionally remove original
rm -f "$INPUT"

echo "Transcoding finished: $OUTPUT_FINAL"
exit 0