# DeepID API and SDK Instructional Guide

**Author:** Deep ID team  
**Version:** v1.4.12  
**Last Release:** Nov 19, 2024  
**Support:** support@deepmedia.ai

---

## Turbo Mode Overview

Turbo Mode is a high-speed processing option for Deepfake detection designed to deliver near real-time results. It is optimized for short-duration or small-size media files and is ideal for rapid testing, live demonstrations, and quick validations. By using Turbo Mode, you bypass the traditional asynchronous queuing and polling mechanisms, allowing you to obtain immediate feedback on your deepfake detection tasks.

> **Important:** Turbo Mode is perfect for small samples. For longer videos or larger files, please use the standard processing endpoints to ensure complete and accurate analysis.

---

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Setup and Installation](#setup-and-installation)
  - [Workflow Overview](#workflow-overview)
- [What's New in v1.4](#whats-new-in-v14)
  - [Turbo Mode](#turbo-mode)
- [API Utilization](#api-utilization)
  - [Authentication](#authentication)
  - [API Endpoints](#api-endpoints)
- [SDK Utilization](#sdk-utilization)
  - [Setup and Installation](#setup-and-installation-1)
  - [Workflow Overview](#workflow-overview-1)
- [Best Practices and Tips](#best-practices-and-tips)
- [Support and Resources](#support-and-resources)
- [Conclusion](#conclusion)

---

## Introduction

Welcome to the DeepID API and SDK Instructional Guide! This guide will walk you through the process of integrating DeepID’s deepfake detection capabilities into your applications and systems. With our streamlined tools, you can quickly detect deepfakes and protect your media content.

---

## Getting Started

### Setup and Installation

1. **Register for an API Key:**  
   Sign up for a DeepID account on our registration page to obtain your unique API key. This key is required to authenticate all API and SDK requests.

2. **Install the DeepID SDK:**  
   Ensure you have Python 3.6 or later installed. Then install the DeepID SDK using the appropriate package installation command. Configure the SDK in your environment as needed.

### Workflow Overview

- **File Submission:**  
  Submit your media files (images, audio, video) for deepfake detection.
- **Processing and Turbo Mode:**  
  Choose between standard processing and Turbo Mode for immediate results.
- **Result Retrieval:**  
  Retrieve the deepfake detection results and integrate them into your application.

---

## What's New in v1.4

### Turbo Mode

Turbo Mode is our newest feature designed for rapid deepfake detection. It uses dedicated endpoints that process small or short media files in near real-time. This allows you to get immediate results without waiting for traditional asynchronous processing. Turbo Mode is ideal for quick tests, live demos, and rapid prototyping. Remember, Turbo Mode is optimized for small samples only; for larger or longer media files, use the standard processing methods.

---

## API Utilization

### Authentication

All API requests require authentication using the HTTP Bearer token. For secure API interactions:

- Generate a session token (valid for 1 hour) by making a request to the session token endpoint.
- Refresh your token when needed using the token refresh endpoint.

### API Endpoints

#### Fetching Available Models

Retrieve the list of available deepfake detection models by making a request to the models endpoint. The response includes model identifiers and the modalities supported (audio, video, image, text).

#### Uploading Files

Upload your media files using the file upload endpoint. Send the file as a multipart/form-data request; the API will return the filename for further processing.

#### Processing Media Files

DeepID supports several methods for processing media files:

**Standard Processing:**

- *Individual File Processing:*  
  Use the individual processing endpoint with parameters such as the list of modalities, processing mode (asynchronous or synchronous), and the file location.
  
- *Batch Processing:*  
  Use the batch processing endpoint to process multiple files concurrently.

**Turbo Mode Processing:**

- *Turbo Mode:*  
  Use the dedicated Turbo Mode endpoint for near real-time processing. This option bypasses the asynchronous queue and returns immediate results. Note that Turbo Mode is best used for small, short-duration media only.

#### Tracking Processing Status

Monitor the status of processed files by querying the status endpoint with the unique file identifier. For multiple files, use the batch status endpoint. Successful processing statuses include "RESULTS" and "PROCESSED".

#### Getting File Data

Retrieve detailed information about your uploaded files by using the file data endpoints:
- An overview endpoint for all files.
- An endpoint for files matching a specific prefix.
- An endpoint to retrieve file data based on the MD5 hash.

#### Usage Statistics

Check your usage statistics using the organization usage and user usage endpoints.

---

## SDK Utilization

### Setup and Installation

1. **Install the SDK:**  
   Install the DeepID SDK using the provided package installation command.
2. **Configuration for On-Premise Installations:**  
   If you are running an on-premise installation, configure the SDK with your API key and adjust the base domain as needed.

### Workflow Overview

1. **Initialization:**  
   Import and initialize the SDK with your API key.
2. **File Submission:**  
   Submit your media files or web URLs for deepfake detection using the SDK methods.
3. **Tracking:**  
   Monitor the processing status until the detection results are ready.
4. **Result Integration:**  
   Retrieve and integrate the deepfake detection results into your application.

---

## Best Practices and Tips

- **Secure Your API Key:**  
  Always store your API token securely using environment variables or secure configuration files.
- **Optimize File Quality:**  
  Use high-quality, uncompressed files for more accurate detection.
- **Use Turbo Mode Appropriately:**  
  Employ Turbo Mode for rapid testing on small or short media files. Avoid using Turbo Mode for larger files to ensure complete analysis.
- **Efficient Polling:**  
  Adjust your polling intervals based on network conditions and file sizes.
- **Monitor Your Usage:**  
  Regularly review your API usage statistics to manage your resources effectively.

---

## Support and Resources

- **API Documentation:**  
  Visit the DeepID API Documentation page for detailed endpoint information and parameters.
- **SDK Repositories:**  
  Access the DeepID SDK repositories for installation guides, additional usage details, and troubleshooting tips.
- **Support:**  
  For assistance, contact our support team at support@deepmedia.ai.
- **Feedback:**  
  We welcome your feedback and suggestions to help improve our tools and documentation.

---

## Conclusion

The DeepID API and SDK provide robust tools for integrating deepfake detection into your applications. With the new Turbo Mode feature, you can achieve near real-time results for small media samples, making it easier than ever to detect deepfakes quickly. Follow this guide to streamline your integration process and enhance your content security and authenticity verification efforts.

Happy coding and stay secure!
