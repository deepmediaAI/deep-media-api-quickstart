```markdown
# DeepID API and SDK Instructional Guide

**Author:** Deep ID team  
**Version:** v1.4.12  
**Last Release:** Nov 19, 2024  
**Support:** [support@deepmedia.ai](mailto:support@deepmedia.ai)

---

## Introduction

Welcome to the DeepID API and SDK instructional guide! This document will walk you through the process of integrating DeepID's powerful Deepfake detection capabilities into your own applications and systems. By leveraging our API and SDK, you can seamlessly identify and mitigate the risks associated with Deepfake content.

---

## Getting Started

### Setup and Installation

To get started with the DeepID API and SDK, you must first sign up for an API key. Visit our [DeepID Documentation](https://staging.api.deepidentify.ai/docs/) and follow the registration process to obtain your unique API key. This key will be used to authenticate your requests and grant access to the DeepID API endpoints.

### Workflow with SDK

The typical workflow includes:

- **File Submission:** Submit media files for processing using asynchronous or synchronous methods.
- **Polling for Results:** Monitor the processing status until results are available.
- **Retrieving and Saving Results:** Once processed, retrieve detailed analysis reports in JSON format and integrate them into your workflow.

### Detailed Feature Usage

The guide covers how to utilize every feature provided by DeepID, including file data reporting, generator attribution, heatmap generation, contextual descriptions, and analytical reasoning.

---

## What’s New in v1.4

In our latest release, we've significantly enhanced our DeepFake detection capabilities with several new features designed to provide deeper insights and more detailed analyses of content authenticity.

### New Features

- **Comprehensive File Data Reporting**
  - **get_file_data:** Aggregates all available analysis metrics into a single detailed JSON report. This report includes predictions, generator attributions, annotated heatmaps, image descriptions, and reasoning analyses.
  
- **Generator Attribution**
  - **get_attribution:** Identifies the underlying AI generator or model responsible for creating the evaluated content, providing a crucial piece of the puzzle for establishing content authenticity.
  
- **Visual Manipulation Detection**
  - **get_heatmap:** Generates detailed visual heatmaps that pinpoint areas of potential manipulation within an image. It uses bounding boxes to highlight parts of the image that show signs of AI intervention.
  
- **Contextual Image Description**
  - **get_description:** Provides a narrative overview of the prominent objects and activities within a processed image to enhance content comprehension.
  
- **Analytical Reasoning**
  - **get_reasoning:** Delivers a logic-based explanation of why an image is flagged as manipulated, increasing transparency and understanding of the detection process.

These enhancements expand your toolkit for handling potential DeepFake content and empower you to make informed decisions about media authenticity.

---

## API Utilization

### Authentication

Every API request requires authentication via the HTTP Bearer scheme using your API token. For security, you can manage your token by generating a short-lived session token or refreshing your token when needed.

- **GET /user/token/session:** Generates a short-lived session token (valid for 1 hour).
- **POST /user/token/refresh:** Refreshes your session token.

### API Endpoints

#### Fetching Available Models

Retrieve the list of available detection models by making a GET request to the `/models` endpoint. This will provide detailed information about each model, including its unique identifier and supported modalities (audio, video, image, text).

#### Uploading Files

Use the `POST /file/uploadS3` endpoint to upload your files. The file should be sent as a multipart/form-data request, and the API will return the filename for later use.

#### Processing Videos

DeepID supports two main approaches for processing videos:

- **Individual File Processing:**  
  Use the `POST /file/process` or `POST /v2/file/process` endpoints with required parameters:
  - `modalities`: An array specifying which modalities to process.
  - `mode`: The processing mode (async or sync).
  - `s3Location` or `webLocation`: The file location.
  
  This call returns a unique video ID for tracking the processing status.

- **Batch Processing:**  
  Use the `POST /file/process/batch` endpoint to process multiple video files concurrently.

#### Tracking Processing Status

To track the status of a processed file, use the `GET /file/status/{id}` endpoint (or `POST /file/status/batch` for multiple files). The API returns statuses such as "queued," "processing," or "completed" (with "RESULTS" or "PROCESSED" indicating success).

#### Getting File Data

DeepID provides several endpoints to retrieve data about your files:
- **GET /file/:** Overview of uploaded files with metadata and results.
- **GET /file/{prefix}:** Retrieve files matching a specific prefix.
- **GET /file/md5/{md5}:** Get file data by MD5 hash.

#### Usage Statistics

Monitor your usage with:
- **GET /organisation/usage:** For organization-wide statistics.
- **GET /user/usage:** For individual account statistics.

### API New Feature Guide

- **Comprehensive File Data Reporting (get_file_data):**  
  Retrieves a detailed JSON report of all analytic data.
- **Generator Attribution (get_attribution):**  
  Identifies the AI generator behind the content.
- **Visual Manipulation Detection (get_heatmap):**  
  Produces a visual heatmap of potential manipulations.
- **Contextual Image Description (get_description):**  
  Provides a narrative description of image elements.
- **Analytical Reasoning (get_reasoning):**  
  Explains the detection outcomes with logic-based analysis.

---

## SDK Utilization

### Setup and Installation

To install the DeepID SDK in Python, run:
```bash
pip install https://deepid-assets.s3.amazonaws.com/sdk/deepid-python.zip
```
For on-prem installations, configure the `base_domain` accordingly.

### Workflow with SDK

1. **Initialize the SDK:**  
   Import the SDK and set your API key.
2. **Process Files:**  
   Use the `process_file` (or `process_web_file` for web-based content) method to start analysis.
3. **Track Status:**  
   Poll the processing status with the `get_file_status` method.
4. **Retrieve Results:**  
   Once processing is complete, access the results from the status response.

### Detailed Feature Usage

- **Comprehensive File Data Reporting:** Retrieve all metrics in one report.
- **Generator Attribution:** (Image only) Understand the content’s AI origin.
- **Heatmap Visualization:** Generate heatmaps for visual manipulation detection.
- **Contextual Description and Analytical Reasoning:** Automatically generate narratives and reasoning for flagged content.

---

## Best Practices and Tips

- **Secure Your API Key:**  
  Use environment variables or secure configuration files.
- **Optimize File Quality:**  
  Use high-quality, uncompressed files for better accuracy.
- **Efficient Polling:**  
  Adjust retry settings to balance responsiveness and processing time.
- **Utilize Advanced Features:**  
  Leverage comprehensive reporting and analytical reasoning to deepen your insights.
- **Monitor Usage:**  
  Regularly check API usage to avoid exceeding your limits.

---

## Support and Resources

- **API Documentation:**  
  Visit [DeepID API Documentation](https://staging.api.deepidentify.ai/docs/) for detailed endpoint and parameter information.
- **SDK Repositories:**  
  Access the DeepID SDK repositories for installation guides, code examples, and troubleshooting.
- **Support Channel:**  
  Contact our support team at [support@deepmedia.ai](mailto:support@deepmedia.ai) or use our support ticketing system.

We value your feedback and continuously work to enhance the DeepID API and SDK. Please share any suggestions or feature requests with us.

---

## Conclusion

The DeepID API and SDK provide powerful tools to integrate Deepfake detection into your applications. By following this guide and leveraging the provided endpoints and SDK features, you can enhance your content security and authenticity verification processes. For further details, refer to our API documentation and SDK repositories. Our support team is always ready to help you succeed.

We're excited to see how you utilize the DeepID tools to combat Deepfakes and safeguard your media content. Happy coding
