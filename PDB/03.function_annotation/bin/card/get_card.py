import sys
import os
with open(sys.argv[1],'r') as fr,open(sys.argv[2],'w') as fw:
	fw.write('ORF_ID\tContig\tStart\tStop\tOrientation\tCut_Off\tPass_Bitscore\tBest_Hit_Bitscore\tBest_Hit_ARO\tBest_Identities\tARO\tModel_type\tSNPs_in_Best_Hit_ARO\tOther_SNPs\tDrug Class\tResistance Mechanism\tAMR Gene Family\tPredicted_DNA\tPredicted_Protein\tCARD_Protein_Sequence\tPercentage Length of Reference Sequence\tID\tModel_ID\tNudged\tNote\n')
	for line in fr:
		l = line.strip('\n')
		if l != '' and not l.startswith('#') and not l.startswith('ORF_ID\tContig'):
			ll = l.split('\t')
			if ll[5] != 'Loose':
				line_list = []
				for i in ll:
					if i == '':
						line_list.append('-')
					else:
						line_list.append(i)
				fw.write('\t'.join(line_list)+'\n')
