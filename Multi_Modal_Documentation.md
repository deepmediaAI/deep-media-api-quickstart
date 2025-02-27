# DeepID API and SDK Instructional Guide

**Author:** Deep ID team  
**Version:** v1.4.12  
**Last Release:** Nov 19, 2024  
**Support:** support@deepmedia.ai

---

## Introduction

Welcome to the DeepID API and SDK instructional guide! This document will walk you through the process of integrating DeepID's powerful Deepfake detection capabilities into your own applications and systems. By leveraging our API and SDK, you can seamlessly identify and mitigate the risks associated with Deepfake content.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
   - Setup and Installation
   - Workflow with SDK
   - Detailed Feature Usage
3. [What’s New in v1.4](#whats-new-in-v14)
   - New Features Overview
4. [API Utilization](#api-utilization)
   - Authentication
   - API Endpoints
     - Fetching Available Models
     - Uploading Files
     - Processing Videos
     - Tracking Processing Status
     - Getting File Data
     - Usage Statistics
   - API New Feature Guide
5. [SDK Utilization](#sdk-utilization)
   - Setup and Installation
   - Workflow with SDK
   - Detailed Feature Usage and New Features
6. [Best Practices and Tips](#best-practices-and-tips)
7. [Support and Resources](#support-and-resources)
8. [Conclusion](#conclusion)

---

## Getting Started

### Setup and Installation

1. **Register for an API Key:**  
   Sign up for a DeepID account at our [registration page](https://staging.api.deepidentify.ai/docs/) to obtain your unique API key. This key is essential for authenticating all requests through the DeepID API and SDK.

2. **Install the DeepID SDK:**  
   Ensure you have Python 3.6 or later installed on your system. Install the DeepID SDK by running the appropriate installation command. Configure the SDK in your environment as needed.

### Workflow with SDK

The typical workflow includes:

- **File Submission:**  
  Submitting media files for processing.
  
- **Polling for Results:**  
  Monitoring processing status until results are available.
  
- **Retrieving and Saving Results:**  
  Accessing detailed JSON reports to integrate into your applications.

### Detailed Feature Usage

This guide explains how to utilize DeepID’s various features, including comprehensive file data reporting, generator attribution (for images), visual manipulation detection, contextual image description, and analytical reasoning.

---

## What’s New in v1.4

In this latest release, we have significantly enhanced our DeepFake detection capabilities with several new features:

- **Comprehensive File Data Reporting (get_file_data):**  
  Aggregates all available analysis metrics into a detailed JSON report that includes predictions, generator attributions, annotated heatmaps, image descriptions, and reasoning analyses.

- **Generator Attribution (get_attribution):**  
  Identifies the AI generator or model responsible for creating the evaluated content, providing key insights into the origins of manipulated media.

- **Visual Manipulation Detection (get_heatmap):**  
  Generates visual heatmaps that pinpoint areas of potential manipulation within an image.

- **Contextual Image Description (get_description):**  
  Provides narrative overviews describing the prominent objects and activities in an image, aiding in content comprehension.

- **Analytical Reasoning (get_reasoning):**  
  Delivers logic-based explanations for why an image is flagged as manipulated, enhancing transparency and trust in the results.

These enhancements empower you with more detailed insights and robust analysis capabilities to safeguard media content.

---

## API Utilization

### Authentication

Every API request requires authentication via the HTTP Bearer scheme using your API token. For enhanced security, you can:

- Generate a short-lived session token (valid for 1 hour) using **GET /user/token/session**.
- Refresh your session token with **POST /user/token/refresh**.

### API Endpoints

- **Fetching Available Models:**  
  Retrieve the list of available detection models using the `/models` endpoint. The response includes model identifiers and supported modalities (audio, video, image, text).

- **Uploading Files:**  
  Upload your files for processing using the `POST /file/uploadS3` endpoint. The API returns the filename for subsequent processing.

- **Processing Videos:**  
  DeepID supports both individual and batch processing via:
  
  - **Individual Processing:** Use `POST /file/process` or `POST /v2/file/process` with required parameters:
    - `modalities`: An array specifying the modalities.
    - `mode`: Processing mode (async or sync).
    - `s3Location` or `webLocation`: The location of the uploaded file.
  
  - **Batch Processing:** Use `POST /file/process/batch` to process multiple files concurrently.

- **Tracking Processing Status:**  
  Monitor the status of processed files using `GET /file/status/{id}` (or `POST /file/status/batch` for multiple files). Success statuses include "RESULTS" and "PROCESSED".

- **Getting File Data:**  
  Retrieve detailed file data via:
  - `GET /file/`
  - `GET /file/{prefix}`
  - `GET /file/md5/{md5}`

- **Usage Statistics:**  
  Check usage with:
  - `GET /organisation/usage`
  - `GET /user/usage`

### API New Feature Guide

New API features include:

- **Comprehensive File Data Reporting:** Provides a complete JSON report of all analytics.
- **Generator Attribution:** (Image only) Identifies the AI generator behind the content.
- **Visual Manipulation Detection:** Generates heatmaps to highlight manipulated regions.
- **Contextual Image Description:** Automatically generates narrative descriptions of image content.
- **Analytical Reasoning:** Offers detailed explanations for detection outcomes.

---

## SDK Utilization

### Setup and Installation

Install the DeepID SDK in Python by running the provided installation command. For on-prem installations, adjust the `base_domain` parameter accordingly.

### Workflow with SDK

- **Initialization:**  
  Import the SDK and configure it with your API key.

- **Processing Files:**  
  Submit files (or web URLs) for processing using the SDK’s methods.

- **Tracking and Retrieval:**  
  Poll the processing status and retrieve detailed JSON reports once processing is complete.

- **Feature Usage:**  
  Utilize comprehensive data reporting, generator attribution (for images only), heatmap generation, contextual description, and analytical reasoning.

---

## Best Practices and Tips

- **Secure Your API Key:**  
  Always protect your API token using environment variables or secure configuration files.

- **Optimize File Quality:**  
  Use high-quality, uncompressed files for more accurate detection.

- **Efficient Polling:**  
  Adjust retry and delay settings based on network conditions and file size.

- **Utilize Advanced Features:**  
  Leverage detailed reporting and analytical reasoning for deeper insights.

- **Monitor Usage:**  
  Regularly review API usage statistics to stay within your limits.

---

## Support and Resources

- **API Documentation:**  
  Visit [DeepID API Documentation](https://staging.api.deepidentify.ai/docs/) for detailed endpoint and parameter information.

- **SDK Repositories:**  
  Access the DeepID SDK repositories for additional installation guides, code examples, and troubleshooting.

- **Support:**  
  Contact our support team at support@deepmedia.ai for assistance.

- **Feedback:**  
  We welcome your feedback and suggestions to help improve our tools and documentation.

---

## Conclusion

The DeepID API and SDK provide robust tools for integrating Deepfake detection into your applications. By following this guide and leveraging the provided endpoints and SDK features, you can enhance your content security and authenticity verification processes. We look forward to seeing how you use DeepID to combat Deepfakes and protect your media content.

Happy coding and stay secure!
