#!/bin/bash
# DeepID API Quickstart for All Modalities with Adaptive Turbo Mode
# Author: Deep ID team
# Version: v1.4.12
# Last Release: Nov 19, 2024
# Support: support@deepmedia.ai
#
# This script processes a media file (image, audio, or video) using DeepID's API.
# It adapts processing mode based on file type and duration:
# - For images: Always uses Turbo Mode.
# - For audio and video: Uses Turbo Mode if the duration is below 50 seconds,
#   and regular (asynchronous) mode if the duration is 50 seconds or longer.
#
# Prerequisites:
# - curl installed on your system.
# - ffprobe (from FFmpeg) installed for audio/video duration detection.
#
# Usage:
#   ./golden_quickstart_API.sh <path_to_file>
#

# --- Configuration ---
export DEEPID_API_KEY="your_api_key"

# --- Input File ---
FILE="$1"
if [ -z "$FILE" ]; then
  echo "Usage: $0 <path_to_file>"
  exit 1
fi

# --- Determine File Modality ---
EXT="${FILE##*.}"
EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
if [[ "$EXT_LOWER" == "mp4" ]]; then
    MODALITY="video"
elif [[ "$EXT_LOWER" == "wav" || "$EXT_LOWER" == "mp3" ]]; then
    MODALITY="audio"
elif [[ "$EXT_LOWER" == "jpg" || "$EXT_LOWER" == "jpeg" || "$EXT_LOWER" == "png" ]]; then
    MODALITY="image"
else
    echo "Unsupported file extension: $EXT_LOWER"
    exit 1
fi

# --- Determine Processing Mode ---
# For images, always use turbo mode.
# For audio/video, check duration using ffprobe.
MODE="turbo"
if [[ "$MODALITY" == "video" || "$MODALITY" == "audio" ]]; then
    if ! command -v ffprobe >/dev/null 2>&1; then
        echo "Error: ffprobe is required for audio/video files. Please install ffprobe."
        exit 1
    fi
    DURATION=$(ffprobe -i "$FILE" -show_entries format=duration -v quiet -of csv="p=0")
    DURATION_INT=${DURATION%.*}
    echo "Detected duration: ${DURATION_INT} seconds"
    if [ "$DURATION_INT" -ge 50 ]; then
        MODE="regular"
    fi
fi

echo "Processing file: $FILE"
echo "Detected modality: $MODALITY"
echo "Selected processing mode: $MODE"

# --- Optional: Request Session Token & Fetch Models ---
echo "Requesting session token..."
curl -s -X GET "https://api.deepidentify.ai/user/token/session" \
     -H "Authorization: Bearer $DEEPID_API_KEY"
echo ""

echo "Fetching available models..."
curl -s -X GET "https://api.deepidentify.ai/models" \
     -H "Authorization: Bearer $DEEPID_API_KEY"
echo ""

# --- Upload File ---
echo "Uploading file: $FILE ..."
UPLOAD_RESPONSE=$(curl -s -X POST "https://api.deepidentify.ai/file/uploadS3" \
  -H "Authorization: Bearer $DEEPID_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@${FILE}")

echo "Upload Response: $UPLOAD_RESPONSE"
UPLOADED_FILENAME=$(echo "$UPLOAD_RESPONSE" | sed -n 's/.*"filename": *"\([^"]*\)".*/\1/p')
echo "Uploaded filename: $UPLOADED_FILENAME"
echo ""

# --- Process File Based on Mode ---
if [ "$MODE" == "turbo" ]; then
    echo "Submitting file for deepfake detection using TURBO MODE..."
    TURBO_RESPONSE=$(curl -s --location "https://api.deepidentify.ai/file/process/rt" \
         --header "Content-Type: application/json" \
         --header "Authorization: Bearer $DEEPID_API_KEY" \
         --data "{
                   \"s3Location\": \"${UPLOADED_FILENAME}\",
                   \"modality\": \"${MODALITY}\"
                 }")
    echo "Turbo Mode Response:"
    echo "$TURBO_RESPONSE"
else
    echo "Submitting file for deepfake detection using REGULAR MODE..."
    REGULAR_RESPONSE=$(curl -s -X POST "https://api.deepidentify.ai/v2/file/process" \
         -H "Authorization: Bearer $DEEPID_API_KEY" \
         -H "Content-Type: application/json" \
         -d "{
               \"modalities\": [\"${MODALITY}\"],
               \"mode\": \"async\",
               \"s3Location\": \"${UPLOADED_FILENAME}\"
             }")
    echo "Initial Process Response:"
    echo "$REGULAR_RESPONSE"
    FILE_ID=$(echo "$REGULAR_RESPONSE" | sed -n 's/.*"id": *\([0-9]*\).*/\1/p')
    echo "Processing initiated. File ID: $FILE_ID"
    
    echo "Checking processing status..."
    while true; do
      STATUS_URL="https://api.deepidentify.ai/file/status/${FILE_ID}"
      STATUS_RESPONSE=$(curl -s -X GET "$STATUS_URL" -H "Authorization: Bearer $DEEPID_API_KEY")
      echo "Status Response: $STATUS_RESPONSE"
      if echo "$STATUS_RESPONSE" | grep -q "\"results\":{\"${MODALITY}\":"; then
          break
      fi
      echo "File is still processing... waiting 30 seconds."
      sleep 30
    done
    echo "Final Results:"
    echo "$STATUS_RESPONSE"
fi

echo "Deepfake detection process complete."

