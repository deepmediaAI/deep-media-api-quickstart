import os
import json
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import (roc_curve, roc_auc_score,
                             precision_recall_curve, average_precision_score,
                             confusion_matrix, ConfusionMatrixDisplay)

# --- Set up file paths and folder ---
json_file = '/path/to/your/video_results.json'  # Update this path for video results
folder_name = os.path.splitext(os.path.basename(json_file))[0]
if not os.path.exists(folder_name):
    os.makedirs(folder_name)

# --- Load the JSON results ---
with open(json_file, 'r') as f:
    data = json.load(f)

# Convert the list of records into a DataFrame.
df = pd.DataFrame(data)

# --- Deepfake Detection Evaluation for Video ---
# Using 'real_score' as the ground truth and 'model_score' as the model's binary prediction.
y_true = df['real_score']
y_score = df['model_score']

# 1. ROC Curve and AUC
fpr, tpr, _ = roc_curve(y_true, y_score)
roc_auc = roc_auc_score(y_true, y_score)

plt.figure(figsize=(6, 5))
plt.plot(fpr, tpr, label=f'ROC Curve (AUC = {roc_auc:.2f})', linewidth=2)
plt.plot([0, 1], [0, 1], 'k--', label='Chance')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('ROC Curve for Video Deepfake Detection')
plt.legend(loc='best')
plt.grid(True)
roc_path = os.path.join(folder_name, "roc_curve.png")
plt.savefig(roc_path, bbox_inches='tight')
plt.close()

# 2. Precision-Recall Curve and Average Precision
precision, recall, _ = precision_recall_curve(y_true, y_score)
avg_precision = average_precision_score(y_true, y_score)

plt.figure(figsize=(6, 5))
plt.plot(recall, precision, label=f'PR Curve (AP = {avg_precision:.2f})', linewidth=2)
plt.xlabel('Recall')
plt.ylabel('Precision')
plt.title('Precision-Recall Curve for Video Deepfake Detection')
plt.legend(loc='best')
plt.grid(True)
pr_path = os.path.join(folder_name, "precision_recall_curve.png")
plt.savefig(pr_path, bbox_inches='tight')
plt.close()

# 3. Confusion Matrix for Deepfake Detection
cm_detection = confusion_matrix(y_true, y_score)
disp_detection = ConfusionMatrixDisplay(confusion_matrix=cm_detection)
fig, ax = plt.subplots(figsize=(5, 5))
disp_detection.plot(ax=ax, cmap=plt.cm.Blues)
ax.set_title('Confusion Matrix for Video Deepfake Detection\n(model_score vs real_score)')
cm_detection_path = os.path.join(folder_name, "confusion_matrix_detection.png")
plt.savefig(cm_detection_path, bbox_inches='tight')
plt.close()

print(f"Graphs saved in folder: {folder_name}")
