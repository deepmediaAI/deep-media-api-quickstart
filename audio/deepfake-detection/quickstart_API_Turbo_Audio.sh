#!/bin/bash
# =============================================================================
# DeepID API Quick Start Guide for Deepfake Detection (Audio Only) - Realtime Mode
#
# This script demonstrates how to use the DeepID API realtime turbo mode to detect
# deepfakes in audio files via direct API calls with curl commands.
#
# Prerequisites:
#   - A DeepID account and API key.
#   - curl installed on your system.
#   - An audio file to analyze (e.g., sample.wav).
# =============================================================================

# ---------------------------
# 1. Authentication
# ---------------------------
export DEEPID_API_KEY="your_api_key_here"
echo "API Key has been set."

echo "Requesting session token..."
curl -X GET "https://api.deepidentify.ai/user/token/session" \
     -H "Authorization: Bearer $DEEPID_API_KEY"
echo -e "\n"

# ---------------------------
# 2. Fetching Available Models
# ---------------------------
echo "Fetching available models..."
curl -X GET "https://api.deepidentify.ai/models" \
     -H "Authorization: Bearer $DEEPID_API_KEY"
echo -e "\n"

# ---------------------------
# 3. Uploading an Audio File
# ---------------------------
AUDIO_FILE="your_file_path_here"  # <- Change this path as needed
echo "Uploading audio file: $AUDIO_FILE..."
UPLOAD_RESPONSE=$(curl -s -X POST "https://api.deepidentify.ai/file/uploadS3" \
     -H "Authorization: Bearer $DEEPID_API_KEY" \
     -H "Content-Type: multipart/form-data" \
     -F "file=@${AUDIO_FILE}")

echo "Upload Response:"
echo "$UPLOAD_RESPONSE"

UPLOADED_FILENAME=$(echo "$UPLOAD_RESPONSE" | sed -n 's/.*"filename": *"\([^"]*\)".*/\1/p')
echo "Uploaded filename: $UPLOADED_FILENAME"
echo -e "\n"

# ---------------------------
# 4. Processing the Audio File in Turbo Mode
# ---------------------------
echo "Submitting audio for Turbo Mode deepfake detection..."
PROCESS_RESPONSE=$(curl -s --location "https://api.deepidentify.ai/file/process/rt" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $DEEPID_API_KEY" \
     --data "{
               \"s3Location\": \"${UPLOADED_FILENAME}\",
               \"modality\": \"audio\"
             }")

echo "Turbo Mode Process Response:"
echo "$PROCESS_RESPONSE"
echo -e "\n"

# ---------------------------
# 5. Interpreting the Results
# ---------------------------
# The returned JSON should include an 'audio' score:
#   - < 0.3: Likely real
#   - 0.3 - 0.7: Caution zone
#   - > 0.7: Likely deepfake

echo "Deepfake detection for the audio file is complete."

