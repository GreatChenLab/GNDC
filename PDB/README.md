# Data Processing Pipeline for Small Peptides


![Uploading Figures S3.png…]()


## Pipeline Workflow

### 1. Data Download

Retrieve datasets from the following sources:
- [NCBI](https://www.ncbi.nlm.nih.gov/)
- [1K-MPGD](http://www.herbgenome.com/)
- [TCMPG](https://cbcb.cdutcm.edu.cn/TCMPG/)
- [GPGD](http://www.gpgenome.com)

### 2. Annotation of small peptides

- The genome-wide prediction of small peptides was performed using a six-frame translation approach implemented in EMBOSS (http://emboss.open-bio.org) and ORFIPY (https://github.com/urmi-21/orfipy), generating all possible protein-coding sequences extending from termination codons. Filtering criteria were applied to retain sequences ranging from 5 to 75 amino acids in length. 
- Transcriptome data from the NCBI Sequence Read Archive (https://www.ncbi.nlm.nih.gov/sra) were aligned to their corresponding reference genomes using HISAT2 (https://daehwankimlab.github.io/hisat2/). Reconstructed transcripts were processed with StringTie (https://github.com/gpertea/stringtie), and coding sequences were identified using TransDecoder (https://github.com/TransDecoder/TransDecoder). The mmseq2 (https://github.com/soedinglab/MMseqs2, Version: Release 17-b804f) was used to compare transcriptome-annotated proteins with genome-predicted small peptides, generating a small peptide dataset supported by transcriptome data. 
- Mass spectrometry data were incorporated to enhance the confidence of predicted small peptides. Experimentally derived small peptide sequences were compared against the genome- and transcriptome-predicted datasets using BLASTp (https://blast.ncbi.nlm.nih.gov/BlastAlign.cgi), and peptides with significant sequence matches were retained as high-confidence candidates.
### 3.  Functional annotation of small peptides 
- The functional characterization of small peptides was performed through comparative analyses against established protein function and pathway databases. KEGG pathway annotations were assigned using HMMSCAN (https://www.ebi.ac.uk/Tools/hmmer/search/hmmscan), enabling the identification of metabolic and signaling pathways associated with these small peptides. Functional classification was further refined through sequence homology searches against the UniProt database using BLASTp, providing insights into potential biological roles and molecular interactions. 
- To evaluate the physicochemical properties of small peptides, including pH, optical rotation, and isoelectric point, predictions were conducted using the ProtParam module within Bio.SeqUtils (https://biopython.org/docs/1.75/api/Bio.SeqUtils.html). 
- Antimicrobial activity was predicted using iAMPCN (https://github.com/joy50706/iAMPCN) with default parameters, while anti-inflammatory properties were assessed using PepNet. The blood-brain barrier permeability of small peptides was evaluated using DeepB3P (https://github.com/GreatChenLab/DeepB3P) ensuring a comprehensive functional analysis of these bioactive compounds.
