import sys,os,glob
from Bio import SeqIO

inputFa = os.path.abspath(sys.argv[1])
outdir = os.getcwd()
speName = os.path.basename(inputFa).split('_peptides')[0]
key = os.path.basename(inputFa).split('.')[-2]
seqText = ''
for recode in SeqIO.parse(inputFa, 'fasta'):
        seqid = str(recode.id)
        seq = str(recode.seq)
        if 'X' in seq.upper() or '.' in seq : continue
        seqText += '>%s\n%s\n' %(seqid,seq)
newFa = os.path.join(outdir,'new.fa')
with open(newFa,'w') as w : w.write(seqText)

PetPath = '/mnt/sharefs/home/bnlihz/software/PepNet/script/'

cmd  = 'cd %s && python predict_fast.py --type AIP --test_fasta %s --output_path %s' %(PetPath,newFa,outdir)
os.system(cmd)
tempAip = os.path.join(outdir, 'AIP_prediction_result.csv')
os.system('mv %s %s/%s.AIP_prediction_result.csv' %(tempAip, outdir, key))

inputAips = glob.glob('%s/part*.AIP_prediction_result.csv' %(outdir))
print(inputAips)
text = "SeqId,Sequence,Probability,Binary\n"
aipInfo = {}
for inputAip in inputAips:
        with open(inputAip, 'r') as f : lines = [i.strip().split(',') for i in f.readlines() if i.strip()]
        for line in lines[1:]:
                index,sequence,probability,binary = line
                aipInfo[sequence] = "%s,%s,%s" %(sequence,probability,binary)

outFile = os.path.join(outdir, '%s.%s.AIP_prediction_result.txt' %(speName,key))
un = ''
for recode in SeqIO.parse(newFa,'fasta'):
        seqid = str(recode.id)
        seq = str(recode.seq)
        if seq in aipInfo:
                text += "%s,%s\n" %(seqid,aipInfo[seq])
        else:
                un += "%s,%s\n" %(seqid,seq)
with open(outFile,'w') as w : w.write(text)
with open('undef.txt','w') as w : w.write(un)
