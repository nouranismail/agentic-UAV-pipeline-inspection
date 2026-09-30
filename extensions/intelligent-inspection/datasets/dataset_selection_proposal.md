# Phase 7 Public-Dataset Selection Proposal

## 1. Control Record

| Field | Value |
|---|---|
| ECR | ECR-20260906-001 |
| Activity | Phase 7 dataset-selection research |
| Prepared by | Nouran Ismail — AI & Algorithm Developer, with Codex assistance |
| Preparation date | 2026-09-08 |
| Decision status | **CONDITIONALLY SELECTED BY PROJECT OWNER — VERIFICATION PENDING** |
| Selected dataset | Kolektor Surface-Defect Dataset 2 (KolektorSDD2 / KSDD2) |
| Selection authority/date | Nouran Ismail — Project Owner; 2026-09-08 |
| Dataset downloaded | **NO** |
| Dataset manifest created | **NO** |
| Training or evaluation performed | **NO** |

The Project Owner conditionally selected KSDD2 for a non-commercial internship research/demonstration and authorized controlled acquisition and governance steps only. Selection remains subject to source, license, archive, and annotation verification. Dataset use, annotation modification, training, tuning, calibration, performance evaluation, model creation, and performance claims remain prohibited. Facts below come from the linked publisher sources. Values explicitly marked **estimate** are planning estimates that must be verified after acquisition.

## 2. Candidate Comparison

| Criterion | KolektorSDD2 | MVTec AD | METU Concrete Crack Images |
|---|---|---|---|
| Publisher | ViCoS Laboratory, University of Ljubljana; source items supplied and annotated by Kolektor Group d.o.o. | MVTec Software GmbH | Çağlar Fırat Özgenel / Middle East Technical University, published by Mendeley Data |
| Official source | [ViCoS KSDD2 dataset page](https://www.vicos.si/resources/kolektorsdd2/) | [MVTec AD dataset page](https://www.mvtec.com/research-teaching/datasets/mvtec-ad) | [Mendeley Data record, DOI 10.17632/5y9wdsg2zt.1](https://data.mendeley.com/datasets/5y9wdsg2zt/1) |
| License | CC BY-NC-SA 4.0 | CC BY-NC-SA 4.0 | CC BY 4.0 |
| Commercial use | Prohibited without separate permission; publisher requests contact for commercial use | Prohibited; publisher requests contact if applicability is uncertain | Permitted by CC BY 4.0 subject to attribution and license terms |
| Redistribution | Attribution, non-commercial use, and ShareAlike apply to redistributed adaptations | Attribution, non-commercial use, and ShareAlike apply to redistributed adaptations | Redistribution and adaptation permitted with attribution and indication of changes |
| Images | 3,335 total: 356 positive and 2,979 negative | 5,354 high-resolution color images across 15 object/texture categories | 40,000 RGB patches: 20,000 positive and 20,000 negative, each 227 × 227 pixels |
| Published split | Train: 246 positive + 2,085 negative; test: 110 positive + 894 negative | Defect-free training images; normal and anomalous test images | Publisher supplies positive and negative classes; no leakage-safe train/validation/test split is documented on the landing page |
| Annotation | Publisher states the production items were annotated and describes mixed weak-to-full supervision. Binary anomaly localization/segmentation is the intended task. Exact archive mask encoding must be verified before approval to download. | Pixel-precise anomaly ground truth; 73 anomaly types in the associated publisher paper | Image-level positive/negative labels only; no bounding boxes or pixel masks |
| File format | **Not verified:** official page states images near 230 × 630 pixels but does not state archive image/mask encoding | **Partly verified:** high-resolution color images and pixel-precise masks; exact archive encoding is not stated on the landing page | RGB image patches; exact encoded file extension is not stated on the landing page |
| Approximate download size | **Estimate:** 0.2–0.8 GB | **Estimate:** about 5 GB for the complete dataset | **Estimate:** 0.2–0.5 GB |
| Formal anomaly classes | Binary visible-defect versus no-defect. Scratches, minor spots, and surface imperfections are examples, not confirmed separate label IDs. | Fifteen object/texture categories with category-specific anomaly types; use a versioned mapping to numeric label IDs | Binary positive/negative surface condition |
| Best task fit | Supervised anomaly localization or segmentation; masks can be reduced to regions for generic detection output | Unsupervised anomaly detection and pixel localization; less direct for supervised defect training because training data are defect-free | Image classification only; localization cannot be trained from the released labels |
| Internship manageability | High | Medium if restricted to a pre-approved category subset; lower for the full high-resolution corpus | Medium computationally, but serious split-leakage and localization limitations |
| Generic `DetectionResult` compatibility | Yes: derive a region centroid/bounds from an approved mask conversion, map binary class to numeric `labelId`, and leave physical `locationValid=false` without calibration | Yes: derive region evidence from masks and use versioned numeric category mappings; physical location remains invalid without calibration | Partial: emit image-level detection and confidence with `locationValid=false`; no ground-truth localization is available |

## 3. Candidate Assessments

### 3.1 Kolektor Surface-Defect Dataset 2 (KolektorSDD2)

**Verified facts.** ViCoS identifies the dataset researchers as Jakob Božič, Domen Tabernik, and Danijel Skočaj. Kolektor Group supplied and annotated production-item images captured in a controlled industrial environment. The dataset contains 356 positive and 2,979 negative images, approximately 230 × 630 pixels, and provides a publisher-defined train/test split. Its license is CC BY-NC-SA 4.0; commercial use needs separate permission. The publisher describes several visible anomaly forms but does not establish them as separate machine-readable classes on the landing page.

**Limitations and bias.** The imagery comes from one production context under controlled acquisition, so lighting, material, camera, and product diversity are limited. Class imbalance is substantial. The public page does not expose acquisition-group identifiers, the archive size, image encoding, or mask encoding; these must be checked before a manifest or training approval.

**Leakage-safe split proposal.** Preserve the official test set untouched. Divide the official training set into training and validation only after exact-duplicate and perceptual-near-duplicate analysis. Keep any samples linked by filename stem, acquisition sequence, or visually near-identical product instance in the same split. Stratify by binary disposition and documented anomaly subtype where reliable. Freeze hashes and membership in the later manifest.

**Required preprocessing proposal.** Decode validation; channel normalization; configured resizing or padding without changing mask alignment; intensity normalization fitted only on the training split; and identical geometric transforms for images and masks. Any augmentation policy requires separate approval and must run only on training data.

**Compute estimate.** A compact transfer-learning segmentation or mask-to-box detector should be feasible on one modern GPU with roughly 6–12 GB VRAM. CPU-only experimentation is possible but slower. Allow approximately 2 GB local working storage after extraction, converted labels, caches, and checkpoints. These are estimates, not measured requirements.

### 3.2 MVTec Anomaly Detection (MVTec AD)

**Verified facts.** MVTec publishes 5,354 high-resolution color images across five texture and ten object categories. Training data are defect-free; test data contain normal and anomalous samples. The dataset provides pixel-precise anomaly annotations and covers 73 anomaly types. It is licensed CC BY-NC-SA 4.0 and excludes commercial use.

**Limitations and bias.** This is primarily an unsupervised anomaly-detection benchmark, not a conventional supervised object-detection dataset. Defect labels occur in the test portion, so repurposing them for supervised training would invalidate the benchmark protocol unless a separately approved demonstration protocol is defined. Categories use controlled industrial imagery and may not represent field acquisition.

**Leakage-safe split proposal.** Prefer the published normal-training/test boundary. For an internship anomaly-detection demonstration, derive validation only from defect-free training images, grouped by category and screened for duplicates; do not tune on labeled test anomalies. If a supervised mask experiment is desired, create a separately approved non-benchmark split grouped by category and image identity and label it clearly as a demonstration rather than an official benchmark result.

**Required preprocessing proposal.** Category-specific decode validation, configured resizing/padding, color normalization, mask-aligned geometric handling, and training-only normalization statistics. A small approved category subset would reduce storage and training time while retaining the generic interface.

**Compute estimate.** Full-resolution multi-category training likely benefits from a GPU with 8–16 GB VRAM and approximately 10–20 GB working storage. A one- or two-category resized demonstration could use 6–8 GB VRAM and materially less storage. These are estimates.

### 3.3 METU Concrete Crack Images for Classification

**Verified facts.** The Mendeley Data record contains 40,000 RGB patches at 227 × 227 pixels, evenly divided between positive and negative classes. They were generated from 458 high-resolution images captured at METU campus buildings. The record is versioned, has a DOI, identifies the contributor and institution, and uses CC BY 4.0.

**Limitations and bias.** Labels are image-level only, so this candidate cannot verify localization. Patch generation from only 458 parent images creates a high leakage risk if related patches cross splits. The landing page does not state that parent-image identifiers are retained. The domain is concrete building surfaces and binary classification, with no broader industrial anomaly taxonomy.

**Leakage-safe split proposal.** Use only if every patch can be traced to its source high-resolution image. Assign entire parent images—not patches—to train, validation, or test, then perform duplicate and overlap checks. If parent grouping cannot be reconstructed from metadata or filenames, reject this dataset for training because a defensible leakage-safe split cannot be demonstrated.

**Required preprocessing proposal.** Decode validation, configured RGB normalization, and no resize if the selected network accepts 227 × 227 input. Compute normalization parameters from training parents only. Do not create pseudo-boxes from image-level labels.

**Compute estimate.** Transfer learning at 227 × 227 should be feasible with 4–8 GB GPU VRAM, or on CPU at slower speed. Allow approximately 1–3 GB working storage for images, indices, caches, and checkpoints. These are estimates.

## 4. Recommendation

The Project Owner has conditionally selected **KolektorSDD2**, subject to the approved source, license, archive, and annotation verification sequence.

Reasons:

- Its explicit CC BY-NC-SA 4.0 license is suitable for a non-commercial internship demonstration if attribution and ShareAlike obligations are followed.
- Its 3,335-image scale and moderate image dimensions are more manageable than the complete MVTec AD corpus.
- It is directly relevant to controlled industrial inspection and supports localization/segmentation rather than image-level classification alone.
- It has a publisher-defined train/test separation and enough positive and negative samples for a small demonstration.
- Mask-derived region results can be adapted to the existing generic `DetectionResult` without changing the interface or claiming physical coordinates.
- MVTec AD remains a strong future reuse candidate for demonstrating a different unsupervised anomaly-detection configuration. The METU dataset is useful as a classification baseline but is not recommended because it lacks localization annotations and may not permit a defensible parent-group split from released metadata.

The Project Owner selected KSDD2 on 2026-09-08 subject to successful source, license, archive, and annotation verification. This conditional selection is not approval to train or evaluate a model. Before training, the Project Owner must approve the verified dataset version, integrity hashes, category and annotation interpretation, immutable split membership, leakage analysis, metrics, thresholds, confidence policy, and compute budget.

## 5. Required Verification and Training Hold Points

The acquisition evidence and later training-approval record must resolve:

1. Selected dataset and immutable publisher version.
2. License compatibility, attribution text, ShareAlike handling, and whether repository redistribution is permitted or prohibited.
3. Dataset owner, project steward, storage location, retention, and access controls.
4. Exact archive size, file encodings, annotation schema, integrity hashes, and acquisition/group metadata.
5. Inclusion, exclusion, deduplication, split membership, and leakage-analysis procedure.
6. Numeric label mapping, approved anomaly scope, preprocessing, augmentation, metrics, operating slices, thresholds, confidence policy, and compute limits.

Controlled download from the official source is authorized only to an approved external location after the source and license pre-checks. Annotation changes, training, tuning, calibration, model creation, performance evaluation, and performance claims remain prohibited.
