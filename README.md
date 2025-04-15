# Deep Media API Quickstart

Welcome to the Deep Media API Quickstart repository! This repository provides a comprehensive set of examples and tools to help you integrate DeepID’s advanced deepfake detection capabilities into your projects. The repository is organized into separate folders by modality—**Image**, **Audio**, and **Video**—and includes both API and SDK examples, as well as evaluation visualization tools.

# New Features: What the heck is Turbo Mode?

Turbo mode API quickstarts are available under each modality—**Image**, **Audio**, and **Video**. They are designed for running small-length samples really, really quickly. Note that turbo mode is optimized for short media files(<10 seconds); larger samples will not work with it and may interfere with your ability to run short length videos.

---

## Repository Structure

- **API Quickstart Examples**  
  These examples demonstrate how to use the DeepID API directly with bash scripts for deepfake detection across different media types:
  - **image/deepfake-detection/quickstart_API_Image.sh**
  - **image/deepfake-detection/quickstart_API_Turbo_Image.sh**  
    Bash script for detecting deepfakes in images.
  - **audio/deepfake-detection/quickstart_API_Audio.sh**
  - **audio/deepfake-detection/quickstart_API_Turbo_Audio.sh**  
    Bash script for detecting deepfakes in audio files.
  - **video/deepfake-detection/quickstart_API_Video.sh**
  - **video/deepfake-detection/quickstart_API_Turbo_Video.sh**  
    Bash script for detecting deepfakes in video files.

- **SDK Quickstart Examples**  
  These Python scripts use the DeepID SDK to perform deepfake detection. They are organized by modality:
  - **quickstart_image.py**  
    Python script for detecting deepfakes in images using the DeepID SDK.
  - **quickstart_audio.py**  
    Python script for detecting deepfakes in audio files using the DeepID SDK.
  - **quickstart_video.py**  
    Python script for detecting deepfakes in video files using the DeepID SDK.

- **Visualization Tools**  
  Each modality also has dedicated Python scripts for generating evaluation visualizations. These scripts create plots such as ROC curves, precision-recall curves, and confusion matrices from JSON results:
  - **visualize_image.py**  
    Generates evaluation plots for images (including extra generator attribution visualizations).
  - **visualize_audio.py**  
    Generates evaluation plots for audio deepfake detection.
  - **visualize_video.py**  
    Generates evaluation plots for video deepfake detection.

---

## How to Use This Repository

### 1. Setup

- **API Access:**  
  Ensure you have signed up for a DeepID account and obtained your API key. For API examples, update the API key placeholder in the bash scripts.

- **SDK Installation:**  
  Install the DeepID SDK in your Python environment:
  ```bash
  pip install deepid
  ```
  Make sure you are using Python 3.6 or later.

- **Data Preparation:**  
  Prepare your media files (images, audio, video) and update the file paths in the relevant scripts.

- **JSON Results for Visualization:**  
  To generate evaluation graphs, provide the JSON result files (from DeepID evaluations) by updating the file paths in the visualization scripts.

### 2. Running the Examples

- **API Examples:**  
  Navigate to the respective folder (image, audio, or video) and run the `quickstart_API.sh` script.  
  For example:
  ```bash
  cd image/deepfake-detection
  chmod +x quickstart_API.sh
  ./quickstart_API.sh
  ```

- **SDK Examples:**  
  Run the Python quickstart scripts from the base directory:
  ```bash
  python quickstart_image.py
  python quickstart_audio.py
  python quickstart_video.py
  ```

- **Visualization Tools:**  
  To generate evaluation visualizations, run the corresponding Python script:
  ```bash
  python visualize_image.py
  python visualize_audio.py
  python visualize_video.py
  ```

### 3. Customization and Advanced Usage

- **Configuration:**  
  Each script includes inline documentation and comments explaining its functionality. Adjust parameters like file paths, API keys, and polling settings to suit your environment.

- **Modality-Specific Features:**  
  - **Image Detection:**  
    The image scripts include extra evaluation for generator attribution, providing insights into the source AI generator.
  - **Audio and Video Detection:**  
    Focus purely on detection accuracy, including ROC, precision-recall curves, and confusion matrices.

- **Extensibility:**  
  Use these examples as a foundation to integrate DeepID deepfake detection into your applications, whether it’s a real-time monitoring system, content moderation workflow, or an offline batch processing pipeline.

---

## Additional Resources

- **DeepID API Documentation:**  
  Visit [DeepID API Documentation](https://staging.api.deepidentify.ai/docs/) for detailed information on endpoints, authentication, and feature usage.

- **Support:**  
  If you encounter issues or need further assistance, please contact our support team at [support@deepmedia.ai](mailto:support@deepmedia.ai).

- **Feedback:**  
  We welcome your feedback and suggestions to help improve our tools and documentation.

---

This repository is designed to provide a robust starting point for integrating DeepID’s deepfake detection capabilities into your media workflows. Happy coding and stay secure!
