## DeepID API Quick Start Guide for Deepfake Detection  
**Version v1.5 – May 2025**

---

### Introduction  
DeepID delivers state-of-the-art deepfake detection through a simple, REST-ful API. This guide shows you how to authenticate, upload media, launch processing, retrieve holistic results **and** extract only the most suspicious segments with the new **threshold filtering** endpoint. Follow along with plain `curl` commands or adapt them to your favourite language or CI pipeline.

---

### Prerequisites  

| Requirement | Details |
|-------------|---------|
| **DeepID account & API key** | Obtain from the DeepID dashboard |
| **`curl`** | Version ≥ 7.68.0 |
| **Media file(s)** | Image / audio / video to analyse |
| **Skillset** | Basic command-line & HTTP knowledge |

---

### 1 Authentication  

1. **Set your API key**

   ```bash
   export DEEPID_API_KEY="<your_api_key_here>"
   ```

2. **(Optional) Get a 1-hour session token**

   ```bash
   curl -X GET "https://api.deepidentify.ai/user/token/session"         -H "Authorization: Bearer $DEEPID_API_KEY"
   ```

3. **Refresh an expired session token**

   ```bash
   curl -X POST "https://api.deepidentify.ai/user/token/refresh"         -H "Authorization: Bearer $DEEPID_API_KEY"
   ```

---

### 2 Discover Available Models  

```bash
curl -X GET "https://api.deepidentify.ai/models"      -H "Authorization: Bearer $DEEPID_API_KEY"
```

Review the returned JSON to choose a model that balances speed, accuracy, and modality coverage for your use-case.

---

### 3 Upload Media  

```bash
curl -X POST "https://api.deepidentify.ai/file/uploadS3"      -H "Authorization: Bearer $DEEPID_API_KEY"      -H "Content-Type: multipart/form-data"      -F "file=@/path/to/media.mp4"
```

The response contains a `filename` (e.g. `uploaded_1234567890.mp4`). Note it—you’ll reference it in the next step.

---

### 4 Process the File (asynchronously)  

```bash
curl -X POST "https://api.deepidentify.ai/v2/file/process"      -H "Authorization: Bearer $DEEPID_API_KEY"      -H "Content-Type: application/json"      -d '{
           "modalities": ["video"],
           "mode": "async",
           "s3Locations": "uploaded_1234567890.mp4"
         }'
```

The JSON response returns an `id` (e.g. `1234abcd5678efgh`). This **file request ID** is your handle for polling status and pulling results.

---

### 5 Poll Processing Status  

```bash
curl -X GET "https://api.deepidentify.ai/file/status/1234abcd5678efgh"      -H "Authorization: Bearer $DEEPID_API_KEY"
```

Repeat until status ≥ `RESULTS`.

---

### 6 Retrieve Holistic Results  

Once status is `RESULTS` or `PROCESSED`, the `/file/status` response already contains top-level probabilities:

```json
{
  "status": "RESULTS",
  "results": {
    "video": 0.0576
  }
}
```

* **< 0.30** → likely authentic  
* **0.30 – 0.70** → caution  
* **> 0.70** → likely deepfake  

---

## 7 NEW – Filter Results by Confidence Threshold  

Need to know **where** manipulation occurs? Use the threshold endpoint to pull only segments whose scores meet or exceed your chosen cutoff.

Important: The threshold endpoint is not compatible with Turbo Mode. If you processed a file with Turbo Mode enabled, re‑process it in standard (non‑Turbo) mode to access segment‑level filtering.Sometimes you need more than a single probability – you need to know where manipulation is most likely. DeepID now exposes a threshold endpoint that returns only the segments whose scores meet or exceed a threshold you specify.

#### Endpoint  

```
GET /results/threshold/{file_request_id}/{modality}/{threshold}
```

* `file_request_id` – the `id` from Step 4  
* `modality` – `video`, `audio`, or `image`  
* `threshold` – float 0 – 1

#### Example Call  

```bash
curl -X GET      "https://api.deepidentify.ai/results/threshold/1234abcd5678efgh/video/0.85"      -H "Authorization: Bearer $DEEPID_API_KEY"
```

#### Example Response  

```json
{
  "file_id": "1234abcd5678efgh",
  "modality": "video",
  "threshold": 0.85,
  "segments": [
    {
      "start_time": 4.19,
      "end_time": 8.25,
      "score": 0.999999
    },
    {
      "start_time": 28.50,
      "end_time": 32.74,
      "score": 0.923451
    }
  ]
}
```

#### How to Use  

* **Fine-grained review** – play just the returned temporal windows to verify manipulation.
* **Red-flag triage** – automatically hand segments exceeding a high threshold (e.g. 0.9) to human analysts.
* **UI overlay** – highlight suspect portions in a media‑player UI

| Scenario | Suggested Threshold |
|----------|--------------------|
| High-throughput screening | `0.70` |
| Analyst-in-the-loop review | `0.85` |
| Zero-false-positive policy | `0.95` |

> **Note** For `image`, each entry includes `frame_number` instead of `start_time` / `end_time`.

---

### 8 Next Steps  

* Combine threshold results with `/file/process/batch` for large-scale audits.  
* Log both holistic and thresholded responses to refine your risk metrics.  
* Experiment with different models (Step 2) – some offer denser per-frame scoring.

Deepfake tactics evolve quickly—so does DeepID. Keep exploring, share feedback, and stay ahead of synthetic media threats!
