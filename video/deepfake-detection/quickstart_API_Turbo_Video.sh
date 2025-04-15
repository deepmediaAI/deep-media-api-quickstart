#!/bin/bash
# =============================================================================
# DeepID API Quick Start Guide for Deepfake Detection (Video Only) - turbo mode Mode
#
# This script demonstrates how to use the DeepID API turbo mode turbo mode to detect
# deepfakes in video files using direct API calls with curl commands.
#
# Prerequisites:
#   - A DeepID account and API key.
#   - curl installed on your system.
#   - A video file to analyze (e.g., sample.mp4).
# =============================================================================

# ---------------------------
# 1. Authentication
# ---------------------------
export DEEPID_API_KEY="your_api_key_here"
echo "API Key has been set."

# ---------------------------
# 2. Uploading a Video File
# ---------------------------
VIDEO_FILE="your_file_path_here"  # <-- Set your local video file path (e.g., /path/to/video.mp4)
echo "Uploading video file: $VIDEO_FILE..."
UPLOAD_RESPONSE=$(curl -s -X POST "https://api.deepidentify.ai/file/uploadS3" \
  -H "Authorization: Bearer $DEEPID_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F "file=@${VIDEO_FILE}")

echo "Upload Response:"
echo "$UPLOAD_RESPONSE"

UPLOADED_FILENAME=$(echo "$UPLOAD_RESPONSE" | sed -n 's/.*"filename": *"\([^"]*\)".*/\1/p')
echo "Uploaded filename: $UPLOADED_FILENAME"
echo -e "\n"

# ---------------------------
# 3. Processing the Video File in turbo mode
# ---------------------------
echo "Submitting video for turbo mode deepfake detection..."
PROCESS_RESPONSE=$(curl -s --location "https://api.deepidentify.ai/file/process/rt" \
  --header "Content-Type: application/json" \
  --header "Authorization: Bearer $DEEPID_API_KEY" \
  --data "{
            \"s3Location\": \"${UPLOADED_FILENAME}\",
            \"modality\": \"video\"
          }")

echo "turbo mode Process Response:"
echo "$PROCESS_RESPONSE"
echo -e "\n"

# ---------------------------
# 4. Interpreting the Results
# ---------------------------
# The returned JSON should include a 'video' score:
#   - < 0.3: Likely real
#   - 0.3 - 0.7: Caution zone
#   - > 0.7: Likely deepfake

echo "Deepfake detection for the video file is complete."

