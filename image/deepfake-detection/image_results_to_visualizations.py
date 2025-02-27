import os
import json
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import (roc_curve, roc_auc_score,
                             precision_recall_curve, average_precision_score,
                             confusion_matrix, ConfusionMatrixDisplay)

# --- Set up file paths and folder ---
json_file = '/path/to/your/image_results.json'  # Update this path for image results
folder_name = os.path.splitext(os.path.basename(json_file))[0]
if not os.path.exists(folder_name):
    os.makedirs(folder_name)

# --- Load the JSON results ---
with open(json_file, 'r') as f:
    data = json.load(f)

# Convert the list of records into a DataFrame.
df = pd.DataFrame(data)

# --- Deepfake Detection Evaluation for Image ---
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
plt.title('ROC Curve for Image Deepfake Detection')
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
plt.title('Precision-Recall Curve for Image Deepfake Detection')
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
ax.set_title('Confusion Matrix for Image Deepfake Detection\n(model_score vs real_score)')
cm_detection_path = os.path.join(folder_name, "confusion_matrix_detection.png")
plt.savefig(cm_detection_path, bbox_inches='tight')
plt.close()

# --- Generator Attribution Evaluation (only for images) ---
generators = np.unique(np.concatenate([df['real_generator'].unique(), df['model_generator'].unique()]))
cm_generator = confusion_matrix(df['real_generator'], df['model_generator'], labels=generators)

disp_generator = ConfusionMatrixDisplay(confusion_matrix=cm_generator, display_labels=generators)
fig, ax = plt.subplots(figsize=(8, 6))
disp_generator.plot(ax=ax, cmap=plt.cm.Blues)
ax.set_title('Confusion Matrix for Generator Attribution\n(model_generator vs real_generator)')
plt.setp(ax.get_xticklabels(), rotation=45, ha="right", rotation_mode="anchor")
plt.tight_layout()
cm_generator_path = os.path.join(folder_name, "confusion_matrix_generator.png")
plt.savefig(cm_generator_path, bbox_inches='tight')
plt.close()

# --- Optional: Save both confusion matrices side by side ---
fig, axes = plt.subplots(1, 2, figsize=(14, 6))
# Left: Detection confusion matrix.
disp_detection = ConfusionMatrixDisplay(confusion_matrix=cm_detection)
disp_detection.plot(ax=axes[0], cmap=plt.cm.Blues)
axes[0].set_title('Deepfake Detection\n(model_score vs real_score)')
# Right: Generator attribution confusion matrix.
disp_generator = ConfusionMatrixDisplay(confusion_matrix=cm_generator, display_labels=generators)
disp_generator.plot(ax=axes[1], cmap=plt.cm.Blues)
axes[1].set_title('Generator Attribution\n(model_generator vs real_generator)')
plt.setp(axes[1].get_xticklabels(), rotation=45, ha="right", rotation_mode="anchor")
plt.tight_layout()
side_by_side_path = os.path.join(folder_name, "side_by_side_confusion_matrices.png")
plt.savefig(side_by_side_path, bbox_inches='tight')
plt.close()

print(f"Graphs saved in folder: {folder_name}")
