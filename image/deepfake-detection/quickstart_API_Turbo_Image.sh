#!/bin/bash
# =============================================================================
# DeepID API Quick Start Guide for Deepfake Detection (Image Only) - turbo mode Mode
#
# This script demonstrates how to use the DeepID API turbo mode turbo mode to detect
# deepfakes in image files using direct API calls with curl commands.
#
# Prerequisites:
#   - A DeepID account and API key.
#   - curl installed on your system.
#   - An image file to analyze (e.g., sample.jpg or sample.png).
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
# 3. Uploading an Image File
# ---------------------------
IMAGE_FILE="your_file_path_here"  # <-- Set your local file here
echo "Uploading image file: $IMAGE_FILE..."
UPLOAD_RESPONSE=$(curl -s -X POST "https://api.deepidentify.ai/file/uploadS3" \
     -H "Authorization: Bearer $DEEPID_API_KEY" \
     -H "Content-Type: multipart/form-data" \
     -F "file=@${IMAGE_FILE}")

echo "Upload Response:"
echo "$UPLOAD_RESPONSE"

UPLOADED_FILENAME=$(echo "$UPLOAD_RESPONSE" | sed -n 's/.*"filename": *"\([^"]*\)".*/\1/p')
echo "Uploaded filename: $UPLOADED_FILENAME"
echo -e "\n"

# ---------------------------
# 4. Processing the Image File in turbo mode
# ---------------------------
echo "Submitting image for turbo mode deepfake detection..."
PROCESS_RESPONSE=$(curl -s --location "https://api.deepidentify.ai/file/process/rt" \
     --header "Content-Type: application/json" \
     --header "Authorization: Bearer $DEEPID_API_KEY" \
     --data "{
               \"s3Location\": \"${UPLOADED_FILENAME}\",
               \"modality\": \"image\"
             }")

echo "turbo mode Process Response:"
echo "$PROCESS_RESPONSE"
echo -e "\n"

# ---------------------------
# 5. Interpreting the Results
# ---------------------------
# The returned JSON should include an 'image' score:
#   - < 0.3: Likely real
#   - 0.3 - 0.7: Caution zone
#   - > 0.7: Likely deepfake

echo "Deepfake detection for the image file is complete."

