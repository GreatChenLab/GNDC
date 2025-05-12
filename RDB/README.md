# Data Processing Pipeline for Small RNA Analysis

![HerbalRDB pipeline](./img/banner-CUbVJyQB.png)

## Pipeline Workflow

### 1. Data Download

Retrieve datasets from the following sources:
- [NCBI](https://www.ncbi.nlm.nih.gov/)
- [1K-MPGD](http://www.herbgenome.com/)
- [TCMPG](https://cbcb.cdutcm.edu.cn/TCMPG/)

---

### 2. Genome Predicted Small RNA

#### ncRNA Prediction
Rfam database (version 14.10) alongside INFERNAL software (version 1.1.4) were used for ncRNA prediction. High-confidence predictions were further refined to extract snRNAs and miRNAs. The parameters used for Rfam were "-cut_ga -rfam -nohmmonly -fmt 2", while INFERNAL was executed with "cmscan -cut_ga -nohmmonly -cpu 16 --tblout out.tblout -fmt 2 -clanin Rfam.clanin -rfam Rfam.cm genome.fa". For tRNA sequence characterization, tRNAscan-SE (version 2.0.12) was employed with the parameters "-E -j tRNA.gff -o tRNA.result -f tRNA.struct". Additionally, rRNA prediction was conducted using rRNAmmer (version 1.2) with the parameters "-S euk -m tsu, lsu, ssu".

#### Execution Steps:
1. **Install INFERNAL software**:
   ```bash
   wget -c http://eddylab.org/infernal/infernal-1.1.4.tar.gz
   tar -xzvf infernal-1.1.4.tar.gz
   cd infernal-1.1.4
   ./configure
   make
   make install
   ```

2. **Run INFERNAL for ncRNA prediction**:
   ```bash
   cmscan -cut_ga -nohmmonly -cpu 16 --tblout out.tblout -fmt 2 -clanin Rfam.clanin -rfam Rfam.cm genome.fa
   ```

#### tRNA Sequence Characterization
For tRNA sequence characterization, tRNAscan-SE (version 2.0.12) was employed.

#### Execution Steps:
1. **Install tRNAscan-SE**:
   ```bash
   wget -c http://trna.ucsc.edu/software/tRNAscan-SE-2.0.12.tar.gz
   tar -xzvf tRNAscan-SE-2.0.12.tar.gz
   cd tRNAscan-SE-2.0.12
   ./configure
   make
   make install
   ```

2. **Run tRNAscan-SE for tRNA prediction**:
   ```bash
   tRNAscan-SE -E -j tRNA.gff -o tRNA.result -f tRNA.struct genome.fa
   ```

#### rRNA Prediction
For rRNA prediction, rRNAmmer (version 1.2) was employed.

#### Execution Steps:
1. **Install rRNAmmer**:
   ```bash
   wget -c https://bioinformatics.psb.ugent.be/downloads/rnammer/rnammer-1.2.tar.gz
   tar -xzvf rnammer-1.2.tar.gz
   cd rnammer-1.2
   ./configure
   make
   make install
   ```

2. **Run rRNAmmer for rRNA prediction**:
   ```bash
   rnammer -S euk -m tsu,lsu,ssu genome.fa
   ```

---

### 3. Pre-processing for miRNA-seq
- The tBtools_JRE1.6.jar biocjava.sRNA.Tools.sRNAseqAdaperRemover software was used to remove splice sequences from the sequencing data, followed by merging and de-redundancy of reads with identical sequences using the parameter "--minLen 17".
- Based on the genome annotations provided in the GFF file, gffread (version 0.12.7) was utilized to extract gene sequences from the genome. 

#### Execution Steps:
1. **Install TBtools software**:
   ```bash
   wget -c https://github.com/CJ-Chen/TBtools-II/releases/download/2.224/TBtools_JRE1.6.jar
   ```

2. **Run pre-processing script**:
   ```bash
   sh 01.filter.sh
   ```

   - **Script Parameters**:
	 - `raw_data`: Path to the raw sequencing data (FASTQ file).
	 - `sample`: Sample name.

---

### 4. miRNA Prediction

- miRDeep2 (version 2.0.1.2) software was used for miRNA prediction based on genome sequences and miRBase (version 22.1) database.

#### Execution Steps:
1. **Install miRDeep2**:
   ```bash
   git clone https://github.com/rajewsky-lab/mirdeep2.git
   cd mirdeep2
   perl install.pl
   ```

2. **Run miRNA prediction script**:
   ```bash
   sh 03.predict.sh
   ```

   - **Script Parameters**:
	 - `collapsed_data`: Path to the collapsed data file.
	 - `genome`: Path to the reference genome sequence (FASTA file).
	 - `mapped`: Path to the alignment results (ARF file).
	 - `mature`: Path to the mature miRNA sequence file (downloaded from miRBase).
	 - `other_mature`: Path to the mature sequence file of closely related species (downloaded from miRBase).
	 - `hairpin`: Path to the miRNA precursor sequence file (downloaded from miRBase).
	 - `sample`: Sample name.

---

### 5. Annotation of miRNA Target Genes

- RNAhybrid (version 2.1.2) was used to analyze the complementary pairing patterns between miRNA sequences and target mRNA sequences to identify potential binding sites.

#### Execution Steps:
1. **Install RNAhybrid**:
   ```bash
   wget -c https://bibiserv.cebitec.uni-bielefeld.de/applications/rnahybrid/resources/downloads/RNAhybrid-2.1.2.tar.gz
   tar -xzvf RNAhybrid-2.1.2.tar.gz
   cd RNAhybrid-2.1.2
   ./configure
   make install
   ```

2. **Run target gene prediction script**:
   ```bash
   sh 04.target.sh
   ```

   - **Script Parameters**:
	 - `mRNA`: Path to the target mRNA sequence file.
	 - `miRNA`: Path to the predicted mature miRNA sequence file.
	 - `sample`: Sample name.

---

### 6. miRNA Secondary Structure Prediction

- ViennaRNA software (version 2.6.1) was used for secondary structure prediction using `RNAfold` and `relplot.pl`.

#### Execution Steps:
1. **Install ViennaRNA**:
   ```bash
   conda install -c bioconda viennarna==2.6.1
   ```

2. **Run secondary structure prediction script**:
   ```bash
   sh 05.structure.sh
   ```

   - **Script Parameters**:
	 - `sample`: Sample name.
	 - `miRNA_hairpin`: Path to the predicted miRNA precursor sequence file.

---

### 7. Functional Annotation of miRNA Target Genes

- Functional annotation can be accessed through:
  - [Human Genetics website](https://www.genenames.org/)
  - [Gene Ontology (GO)](http://geneontology.org/)
  - [NCBI Gene Database](https://www.ncbi.nlm.nih.gov/gene/)

---

## Software and Dependencies

### Required Software:
- INFERNAL (version 1.1.4)
- tRNAscan-SE (version 2.0.12)
- rRNAmmer (version 1.2)
- TBtools (version 2.224)
- miRDeep2 (version 2.0.1.2)
- RNAhybrid (version 2.1.2)
- ViennaRNA (version 2.6.1)

### Required Databases:
- Rfam (version 14.10)
- miRBase (version 22.1)

### Required Files:
- Reference genome sequence (FASTA format)
- Sample sequencing data (FASTQ format)
- GFF annotation file
- Mature and precursor miRNA sequences from miRBase

---

## Example Execution Workflow

To run the pipeline, execute the scripts in the following order:
1. `sh 01.filter.sh`
2. `sh 02.map.sh`
3. `sh 03.predict.sh`
4. `sh 04.target.sh`
5. `sh 05.structure.sh`

