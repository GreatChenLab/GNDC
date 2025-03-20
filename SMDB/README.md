
# Data Processing Pipeline for Secondary Metabolites Analysis

![Project Overview](https://github.com/GreatChenLab/GNDC/blob/main/SMDB/Image/pipeline.png)

This repository describes a comprehensive pipeline for secondary metabolites analysis, combining data downloading, retrosynthetic analysis, similarity calculation, and multiple predictive modeling steps.


## Pipeline Workflow

### 1. Data Download
Retrieve datasets from the following sources:
- [NPcVar] (https://npcvar.idrblab.net/download)
- [NP-MRD] (https://np-mrd.org/downloads)
- [coconut2.0] (https://coconut.naturalproducts.net/download)
- [NPASSv2.0] (https://bidd.group/NPASS/downloadnpass.html)
- [NPAtlas] (https://www.npatlas.org/download)
- [supernatural3.0] (https://bioinf-applied.charite.de/supernatural_3/subpages/faq.php)
- [TCMBank] (https://tcmbank.cn/Download)
- [TeroKit_V2.5] (http://terokit.qmclab.com/data.html)

### 2. Retrosynthetic Inference (BioNavi-NP)
- Use **BioNavi-NP** (Biosynthetic pathways navigation for natural products) for:
  - Target compound retrosynthetic analysis
  - Generation of precursor compounds
  - Synthetic pathway prediction
  - [BioNavi-NP Documentation](https://github.com/prokia/BioNavi-NP)

### 3. Retrosynthesis Result Processing
- Clean and format output:
  - Remove duplicate structures
  - Generate intermediate datasets

### 4. Similarity Calculation (RDKit)
- Utilize **RDKit** for:
  - Molecular fingerprint generation (Morgan)
  - Tanimoto similarity calculations
  - Example code snippet:
    ```python
    from rdkit import Chem
    from rdkit.Chem import AllChem
    
    mol1 = Chem.MolFromSmiles(smiles1)
    mol2 = Chem.MolFromSmiles(smiles2)
    fp1 = AllChem.GetMorganFingerprint(mol1, 2)
    fp2 = AllChem.GetMorganFingerprint(mol2, 2)
    similarity = AllChem.TanimotoSimilarity(fp1, fp2)
    ```

### 5. ADMET Prediction (ADMET-AI)
- Predict pharmacokinetic properties using **ADMET-AI**:
  - [ADMET-AI Documentation](https://github.com/swansonk14/admet_ai)

### 6. Natural Product Classification (NPClassifier)
- Classify secondary metabolites using **NPClassifier**:
  - [NPClassifier GitHub](https://github.com/mwang87/NP-Classifier)

### 7. DeepICER Prediction
- Apply **DeepICER** for:
  - Signature gene expression profile prediction
  - [DeepICER Documentation](https://github.com/GreatChenLab/DeepICER)
