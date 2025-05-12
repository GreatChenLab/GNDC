import sys
import re
use_id = {}
with open(sys.argv[1],'r') as f:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			ready_id = ll[3].split('ID=')[1].split(';')[0]
			use_id[ready_id] = ''
with open(sys.argv[2],'r') as f,open('orfipy.gff3','w') as fw:
	for line in f:
		l = line.strip()
		if l != '' and not l.startswith('#'):
			ll = l.split('\t')
			see_id = ll[3].split('ID=')[1].split(';')[0]
			if see_id in use_id:
				chr_name = ll[0]
				method = 'orfipy'
				fang = ll[5]
				#gene mRNA exon
				s1 = '1'
				s2 = ll[2]
				#g_id = 'GENE.' + chr_name + '~~' + see_id
				g_id = 'gene_' + see_id
				g_write = 'ID=%s'%(g_id)
				fw.write('\t'.join([chr_name,method,'gene',s1,s2,'.',fang,'.',g_write])+'\n')
				m_id = 'mRNA_' + see_id
				m_write = 'ID=%s;Parent=%s'%(m_id,g_id)
				fw.write('\t'.join([chr_name,method,'mRNA',s1,s2,'.',fang,'.',m_write])+'\n')
				e_id = 'exon_' + see_id
				e_write = 'ID=%s;Parent=%s'%(e_id,m_id)
				fw.write('\t'.join([chr_name,method,'exon',s1,s2,'.',fang,'.',e_write])+'\n')
				#cds
				if fang == '+':
					s1 = str(int(ll[6])+1)
					s2 = str(int(ll[7]) + 3)
					cds_h = int(s1) - 1
					cds_e = int(s2)
				else:
					s1 = str(int(ll[6])+1-3)
					s2 = ll[7]
					cds_h = int(s1) - 1
					cds_e = int(s2)
				c_id = 'cds_' + see_id
				c_write = 'ID=%s;Parent=%s'%(c_id,m_id)
				fw.write('\t'.join([chr_name,method,'CDS',s1,s2,'.',fang,'0',c_write])+'\n')
				#5utr
				if fang == '+':
					s1 = '1'
					s2 = str(cds_h)
					if (int(s2) - int(s1)) < 1:
						pass
					else:
						u5_id = 'utr5_' + see_id
						u5_write = 'ID=%s;Parent=%s'%(u5_id,m_id)
						fw.write('\t'.join([chr_name,method,'five_prime_UTR',s1,s2,'.',fang,'.',u5_write])+'\n')
				else:
					s1 = str(cds_e+1)
					s2 = str(ll[2])
					if (int(s2) - int(s1)) < 1:
						pass
					else:
						u5_id = 'utr5_' + see_id
						u5_write = 'ID=%s;Parent=%s'%(u5_id,m_id)
						fw.write('\t'.join([chr_name,method,'five_prime_UTR',s1,s2,'.',fang,'.',u5_write])+'\n')
				#3utr
				if fang == '+':
					s1 = str(cds_e+1)
					s2 = str(ll[2])
					if (int(s2) - int(s1)) < 1:
						pass
					else:
						u3_id = 'utr3_' + see_id
						u3_write = 'ID=%s;Parent=%s'%(u3_id,m_id)
						fw.write('\t'.join([chr_name,method,'three_prime_UTR',s1,s2,'.',fang,'.',u3_write])+'\n')
				else:
					s1 = '1'
					s2 = str(cds_h)
					if (int(s2) - int(s1)) < 1:
						pass
					else:
						u3_id = 'utr3_' + see_id
						u3_write = 'ID=%s;Parent=%s'%(u3_id,m_id)
						fw.write('\t'.join([chr_name,method,'three_prime_UTR',s1,s2,'.',fang,'.',u3_write])+'\n')
