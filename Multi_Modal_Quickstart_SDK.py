#!/usr/bin/env python
"""
Unified Quickstart Script for DeepID SDK
Processes all media files (images, audio, video) in a given folder and outputs results to JSON files and a CSV summary.
Usage: python quickstart.py /path/to/media/folder
"""

import os
import time
import json
import csv
import traceback
import argparse
from datetime import datetime
from deepid import API  # Import the DeepID SDK

# ---------------------------
# 1. Set Up Your Environment
# ---------------------------
# Set your API key for authentication. Replace with your actual API key.
API_KEY = "your_api_key_here"

# Configure additional settings:
MAX_RETRIES = 10          # Increase if processing large files or on a slow network.
ENV = "production"        # Use 'staging' for testing or 'production' for reliable models.
RETRY_DELAY = 5           # Time (in seconds) between polling attempts.
RESULTS_DIR = 'results'   # Directory to save JSON and CSV results.

# Ensure the results directory exists.
if not os.path.exists(RESULTS_DIR):
    os.makedirs(RESULTS_DIR)

# Initialize the DeepID API session.
deepid = API(API_KEY, env=ENV)

# ---------------------------
# 2. Define Modality Detection
# ---------------------------
# Define file extension sets for different media modalities.
AUDIO_EXT = {".wav", ".mp3", ".aac", ".flac", ".ogg", ".m4a"}
VIDEO_EXT = {".mp4", ".avi", ".mov", ".mkv", ".wmv"}
IMAGE_EXT = {".jpg", ".jpeg", ".png", ".bmp", ".gif", ".tiff"}

def get_modality(file_path):
    """Determine modality based on file extension."""
    ext = os.path.splitext(file_path)[1].lower()
    if ext in AUDIO_EXT:
        return "audio"
    elif ext in VIDEO_EXT:
        return "video"
    elif ext in IMAGE_EXT:
        return "image"
    else:
        return None

# ---------------------------
# 3. Define Helper Functions
# ---------------------------
def process_file(file_path, modality):
    """
    Submit a file for asynchronous processing by the DeepID API.
    Returns the job ID if successful.
    """
    try:
        response = deepid.process_file_async(
            file_path,
            run_description=False,  # Set to True for a detailed analysis output.
            modalities=[modality]   # Specify the modality (audio, video, image).
        )
        return response['id']
    except Exception as e:
        print(f"Error submitting file {file_path}: {e}")
        return None

def get_results(file_id):
    """
    Poll for results using the file's job ID.
    Returns the analysis results when available or None after MAX_RETRIES.
    """
    for _ in range(MAX_RETRIES):
        status_response = deepid.get_file_status(file_id)
        status = status_response['status']
        if status in ['PROCESSED', 'RESULTS']:
            return status_response['results']
        time.sleep(RETRY_DELAY)
    return None

def save_results(file_path, results):
    """
    Save the JSON results to a file.
    Returns the path to the saved result file.
    """
    filename = os.path.basename(file_path)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    result_filename = f"{filename}_{timestamp}_result.json"
    result_path = os.path.join(RESULTS_DIR, result_filename)
    try:
        with open(result_path, 'w') as f:
            json.dump(results, f, indent=2)
        print(f"Results saved to: {result_path}")
    except Exception as e:
        print(f"Error saving results for {file_path}: {e}")
    return result_path

def process_folder(folder_path):
    """
    Iterate through all files in the folder, process each according to its modality,
    and compile a CSV summary of the results.
    """
    csv_rows = []
    # List only files (non-recursive) in the folder.
    for filename in os.listdir(folder_path):
        full_path = os.path.join(folder_path, filename)
        if os.path.isfile(full_path):
            modality = get_modality(full_path)
            if modality is None:
                print(f"Skipping file (unknown modality): {full_path}")
                continue
            try:
                start_time = time.time()
                print(f"\nProcessing file: {full_path} as {modality}")
                job_id = process_file(full_path, modality)
                if not job_id:
                    print(f"Failed to submit {full_path}")
                    csv_rows.append({
                        "file": full_path,
                        "modality": modality,
                        "job_id": "",
                        "processing_time": "",
                        "result_status": "Submission Failed",
                        "result_file": ""
                    })
                    continue

                print(f"Job ID: {job_id}")
                results = get_results(job_id)
                processing_time = time.time() - start_time
                if results:
                    result_file = save_results(full_path, results)
                    result_status = "Processed"
                else:
                    result_file = ""
                    result_status = "No Results"
                # Append details for CSV summary.
                csv_rows.append({
                    "file": full_path,
                    "modality": modality,
                    "job_id": job_id,
                    "processing_time": f"{processing_time:.2f}",
                    "result_status": result_status,
                    "result_file": result_file
                })
            except Exception as e:
                traceback.print_exc()
                print(f"Error processing {full_path}: {e}")
                csv_rows.append({
                    "file": full_path,
                    "modality": modality,
                    "job_id": "",
                    "processing_time": "",
                    "result_status": f"Error: {e}",
                    "result_file": ""
                })

    # Write the CSV summary file.
    csv_file_path = os.path.join(RESULTS_DIR, "results.csv")
    fieldnames = ["file", "modality", "job_id", "processing_time", "result_status", "result_file"]
    try:
        with open(csv_file_path, "w", newline='') as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            for row in csv_rows:
                writer.writerow(row)
        print(f"\nCSV results saved to: {csv_file_path}")
    except Exception as e:
        print(f"Error writing CSV file: {e}")

# ---------------------------
# 4. Main Routine
# ---------------------------
def main():
    # Use argparse to get the folder path from the command line.
    parser = argparse.ArgumentParser(description="Process a folder of media files with the DeepID SDK")
    parser.add_argument("folder", help="Path to folder containing media files")
    args = parser.parse_args()
    folder_path = args.folder
    if not os.path.isdir(folder_path):
        print(f"Error: {folder_path} is not a valid folder.")
        return
    process_folder(folder_path)

if __name__ == "__main__":
    main()
