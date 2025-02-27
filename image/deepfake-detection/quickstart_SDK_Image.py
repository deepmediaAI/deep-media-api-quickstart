# Import required modules
import time
import json
import os
import traceback
from datetime import datetime
from deepid import API  # Import the DeepID SDK

# ---------------------------
# 1. Set Up Your Environment
# ---------------------------
# Set your API key for authentication. Replace with your actual API key.
API_KEY = "you_api_key_here"

# Configure additional settings:
# Increase MAX_RETRIES if you're processing large files or if your network is slow.
MAX_RETRIES = 10
# Set the environment: 'staging' for testing or 'production' for the most reliable models.
ENV = "production"
# Adjust RETRY_DELAY based on your expected processing time (in seconds)
RETRY_DELAY = 5
# Define a directory to save the result files (ensure it exists or has write permissions)
RESULTS_DIR = 'results'

# Initialize your DeepID session using the API key and environment
deepid = API(API_KEY, env=ENV)

# ---------------------------
# 2. Define Your Sample Image Files
# ---------------------------
# Provide the paths to the image files you wish to analyze.
sample_files = {
    "image": [
        "/Users/rofman/sdk/sample_image.jpg"  # Replace with your actual image file path(s)
    ]
}

# Tip:
# For optimal performance, use high-quality uncompressed image files when possible.
# Larger files may take longer to process but can yield more accurate results.

# ---------------------------
# 3. Define Helper Functions
# ---------------------------
def process_file(file_path, modality):
    """
    Submit a file for asynchronous processing by the DeepID API.
    
    This function uses the process_file_async method from the DeepID SDK,
    which takes the file path and a list of modalities (in this case, just "image").
    It returns the job ID if the submission is successful.
    """
    try:
        response = deepid.process_file_async(
            file_path,
            run_description=False,  # Set to True for a detailed analysis output
            modalities=[modality]   # Specify that we're processing an image file
        )
        return response['id']
    except Exception as e:
        print(f"Error submitting file {file_path}: {e}")
        return None

def get_results(file_id):
    """
    Poll for the results of a processed file.
    
    This function repeatedly checks the status of the job using its file ID.
    It waits for RETRY_DELAY seconds between checks and tries up to MAX_RETRIES times.
    When the status is 'PROCESSED' or 'RESULTS', the function returns the analysis results.
    If the results aren't ready after MAX_RETRIES, it returns None.
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
    Save the analysis results to a JSON file.
    
    This function creates a results directory if it doesn't exist and then writes
    the JSON results to a file. The filename includes the original file's name and a timestamp.
    """
    if not os.path.exists(RESULTS_DIR):
        os.makedirs(RESULTS_DIR)
    
    # Extract the base filename from the file path
    filename = os.path.basename(file_path)
    # Create a timestamp for unique naming
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    # Build the result filename
    result_filename = f"{filename}_{timestamp}_result.json"
    result_path = os.path.join(RESULTS_DIR, result_filename)
    
    # Write the JSON results to the file with indentation for readability
    with open(result_path, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"Results saved to: {result_path}")

def process_files(file_list, modality):
    """
    Process a list of files for the specified modality.
    
    For each file in the list:
      - Submit the file for processing.
      - Retrieve the file ID from the response.
      - Poll for results using the file ID.
      - Save the results if they are received.
    """
    print(f"\nProcessing {len(file_list)} {modality} file(s):")
    for file_path in file_list:
        try:
            print(f"Processing: {file_path}")
            # Submit the file for processing and get its job ID
            file_id = process_file(file_path, modality)
            if file_id:
                print(f"File ID: {file_id}")
                # Retrieve the analysis results by polling the API
                results = get_results(file_id)
                if results:
                    print(f"Results for {file_path}: {results}")
                    save_results(file_path, results)
                else:
                    print(f"No results received for {file_path}")
            else:
                print(f"Failed to process {file_path}")
        except Exception as e:
            traceback.print_exc()
            print(f"Error processing {file_path}: {e}")

# ---------------------------
# 4. Main Processing Routine
# ---------------------------
def main():
    """
    Main function to process image files for deepfake detection.
    
    This function iterates through the sample_files dictionary,
    processing files under the "image" modality.
    """
    for modality, file_list in sample_files.items():
        process_files(file_list, modality)

# Execute the main function if the script is run directly
if __name__ == "__main__":
    main()
