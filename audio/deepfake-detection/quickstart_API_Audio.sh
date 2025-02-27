#!/bin/bash
# =============================================================================
# DeepID API Quick Start Guide for Deepfake Detection (Audio Only)
#
# This script demonstrates how to use the DeepID API to detect deepfakes
# in audio files using direct API calls with curl commands.
#
# Prerequisites:
#   - A DeepID account and API key.
#   - curl installed on your system (version 7.68.0 or later recommended).
#   - An audio file to analyze (e.g., sample.mp3).
#   - Basic familiarity with command-line interfaces and RESTful APIs.
#
# For any questions or support, contact our support team at support@deepmedia.ai.
# =============================================================================

# ---------------------------
# 1. Authentication
# ---------------------------
# Set your API key as an environment variable.
export DEEPID_API_KEY="your_api_key_here"
echo "API Key has been set. (Remember to replace \"your_api_key_here\" with your actual key.)"

# Optionally, generate a short-lived session token (valid for 1 hour):
echo "Requesting a session token..."
curl -X GET "https://api.deepidentify.ai/user/token/session" \
     -H "Authorization: Bearer $DEEPID_API_KEY"
echo -e "\n"

# To refresh your session token (if expired), run:
# curl -X POST "https://api.deepidentify.ai/user/token/refresh" \
#      -H "Authorization: Bearer $DEEPID_API_KEY"

# ---------------------------
# 2. Fetching Available Models
# ---------------------------
# Retrieve the list of available models and review their supported modalities.
echo "Fetching available models..."
curl -X GET "https://api.deepidentify.ai/models" \
     -H "Authorization: Bearer $DEEPID_API_KEY"
echo -e "\n"

# Note:
# Review the output and choose a model that supports the "audio" modality.
# The output includes details such as Model ID, Supported modalities,
# Description, and Version.

# ---------------------------
# 3. Uploading an Audio File
# ---------------------------
# Replace '/path/to/your/audio.mp3' with the path to your audio file.
AUDIO_FILE="/path/to/your/audio.mp3"
echo "Uploading audio file: $AUDIO_FILE..."
UPLOAD_RESPONSE=$(curl -s -X POST "https://api.deepidentify.ai/file/uploadS3" \
     -H "Authorization: Bearer $DEEPID_API_KEY" \
     -H "Content-Type: multipart/form-data" \
     -F "file=@${AUDIO_FILE}")

echo "Upload Response:"
echo "${UPLOAD_RESPONSE}"
# Extract the filename from the response (assuming the JSON key is "filename").
# For example purposes, we assume the returned filename is stored in variable UPLOADED_FILENAME.
# You may use a JSON parser like jq in a real script:
UPLOADED_FILENAME=$(echo "${UPLOAD_RESPONSE}" | grep -oP '(?<="filename": ")[^"]+')
echo "Uploaded filename: ${UPLOADED_FILENAME}"
echo -e "\n"

# ---------------------------
# 4. Processing the Audio File
# ---------------------------
# Submit the uploaded audio for asynchronous deepfake analysis.
# Note: The 'modalities' array now contains only "audio".
echo "Submitting audio for deepfake detection..."
PROCESS_RESPONSE=$(curl -s -X POST "https://api.deepidentify.ai/v2/file/process" \
     -H "Authorization: Bearer $DEEPID_API_KEY" \
     -H "Content-Type: application/json" \
     -d "{
           \"modalities\": [\"audio\"],
           \"mode\": \"async\",
           \"s3Location\": \"${UPLOADED_FILENAME}\"
         }")
echo "Process Response:"
echo "${PROCESS_RESPONSE}"
# Extract the file ID from the process response.
FILE_ID=$(echo "${PROCESS_RESPONSE}" | grep -oP '(?<="id": ")[^"]+')
echo "Processing initiated. File ID: ${FILE_ID}"
echo -e "\n"

# ---------------------------
# 5. Tracking Processing Status & Retrieving Results
# ---------------------------
# Function to check the status of the analysis.
check_status() {
    STATUS_RESPONSE=$(curl -s -X GET "https://api.deepidentify.ai/file/status/${FILE_ID}" \
         -H "Authorization: Bearer $DEEPID_API_KEY")
    echo "Status Response:"
    echo "${STATUS_RESPONSE}"
}

# Loop to periodically check if processing is complete.
echo "Checking processing status..."
while true; do
    RESPONSE=$(curl -s -X GET "https://api.deepidentify.ai/file/status/${FILE_ID}" \
         -H "Authorization: Bearer $DEEPID_API_KEY")
    
    # Extract status field (using grep for simplicity; consider using jq for robust parsing)
    STATUS=$(echo "${RESPONSE}" | grep -oP '(?<="status": ")[^"]+')
    echo "Current status: ${STATUS}"
    
    if [[ "${STATUS}" == "RESULTS" || "${STATUS}" == "PROCESSED" ]]; then
        echo "Deepfake detection completed."
        echo "Final Results:"
        echo "${RESPONSE}"
        break
    elif [[ "${STATUS}" == "ERROR" ]]; then
        echo "An error occurred during processing. Please review your input and try again."
        break
    else
        echo "Processing... waiting for 30 seconds before next check."
        sleep 30
    fi
done

# ---------------------------
# 6. Interpreting the Results
# ---------------------------
# The JSON response under "results" will include a key "audio" with a float value.
# This value represents the probability of the audio being a deepfake:
#   - Low probability (< 0.3): Likely authentic.
#   - Medium probability (0.3 - 0.7): Exercise caution.
#   - High probability (> 0.7): Likely a deepfake.
#
# You can now incorporate these results into your application or workflow.

echo "Deepfake detection for the audio file is complete."
