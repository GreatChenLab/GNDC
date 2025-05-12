import sys
import glob
import os
dd = os.path.abspath('./Tmp')
#ll = glob.glob('%s/*.eps'%(dd))
#ll.sort()
aa = os.system('mkdir -p Signalp_plot_tmp')
if aa != 0:
	print('run err !!')
	exit(1)
ll = []
with open(sys.argv[1],'r') as f:
	for line in f:
		if not line.startswith('#'):
			if line.strip() != '':
				l = line.strip().split('\t')
				if l[1] != 'OTHER':
					ll.append(l[0])
for i in ll:
	jj_file = os.path.join(dd,sys.argv[2]+'_'+i+'_plot.eps')
	ok_file = i
	#print(i+'\t'+ok_file)
	aa = os.system('cp %s Signalp_plot_tmp/%s'%(jj_file,sys.argv[3]+'_'+i+'_plot.eps'))
	if aa != 0:
		print('run err !!')
		exit(2)
#	print('convert -density 500 %s -resize 100%% %s.pdf'%(jj_file,ok_file))
#	aa = os.system('convert -density 500 %s -resize 100%% %s.pdf'%(jj_file,ok_file))
#	if aa != 0:
#		print('run err !!')
#		exit(2)
#	print('convert -density 500 %s -resize 100%% %s.png'%(jj_file,ok_file))
#	aa = os.system('convert -density 500 %s -resize 100%% %s.png'%(jj_file,ok_file))
#	if aa != 0:
#		print('run err !!')
#		exit(2)
