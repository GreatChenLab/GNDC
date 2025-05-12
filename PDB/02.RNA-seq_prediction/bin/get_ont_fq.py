import sys
import os
import glob
sample_name = sys.argv[2]
new_file = sys.argv[2]+'.raw_no_filter.fq'
for i in sys.argv[1].split(','):
	if i.strip() != '':
		if os.path.isdir(i):
			aa = os.system('cat %s/*.fastq >> %s'%(i,new_file))
			if aa != 0:
				print('cat %s/*.fastq >> %s |||| run failed !!!!'%(i,new_file))
				exit(1)
		elif i.endswith('.gz'):
			if i.endswith('.tar.gz'):
				aa = os.system('mkdir tt_dd_dir && tar zxvf %s -C tt_dd_dir/'%(i))
				if aa != 0:
					print('mkdir tt_dd_dir && tar zxvf %s -C tt_dd_dir/ |||| run failed !!!!'%(i))
					exit(1)
				ll = glob.glob('tt_dd_dir/*.fastq')
				if len(ll) > 0:
					aa = os.system('cat tt_dd_dir/*.fastq >> %s && rm -rf tt_dd_dir/'%(new_file))
					if aa != 0:
						print('cat tt_dd_dir/*.fastq >> %s && rm -rf tt_dd_dir/ |||| run failed !!!!'%(new_file))
						exit(1)
				else:
					aa = os.system('cat tt_dd_dir/*/*.fastq >> %s && rm -rf tt_dd_dir/'%(new_file))
					if aa != 0:
						print('cat tt_dd_dir/*/*.fastq >> %s && rm -rf tt_dd_dir/ |||| run failed !!!!'%(new_file))
						exit(1)
			else:
				aa = os.system('gunzip %s -c >> %s'%(i,new_file))
				if aa != 0:
					print('gunzip %s -c >> %s |||| run failed !!!!'%(i,new_file))
					exit(1)
		else:
			aa = os.system('cat %s >> %s'%(i,new_file))
			if aa != 0:
				print('cat %s >> %s |||| run failed !!!!'%(i,new_file))
				exit(1)
