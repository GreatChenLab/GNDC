import sys
import glob
import os
dd = os.path.abspath('./')
ll = glob.glob('%s/*.eps'%(dd))
#ll.sort()
#aa = os.system('mkdir -p Signalp_plot')
#if aa != 0:
#	print('run err !!')
#	exit(1)
#ll = []
#with open(sys.argv[1],'r') as f:
#	for line in f:
#		if not line.startswith('#'):
#			if line.strip() != '':
#				l = line.strip().split('\t')
#				if l[1] != 'OTHER':
#					ll.append(l[0])
for i in ll:
	jj_file = i#os.path.join(dd,sys.argv[2]+'_'+i+'_plot.eps')
	ok_file = os.path.basename(i).split('_plot.eps')[0].split(sys.argv[1]+'_')[1]
	#print(i+'\t'+ok_file)
	print('convert -density 500 %s -resize 100%% %s.pdf'%(jj_file,ok_file))
	aa = os.system('convert -density 500 %s -resize 100%% %s.pdf'%(jj_file,ok_file))
	if aa != 0:
		print('run err !!')
		exit(2)
	print('convert -density 500 %s -resize 100%% %s.png'%(jj_file,ok_file))
	aa = os.system('convert -density 500 %s -resize 100%% %s.png'%(jj_file,ok_file))
	if aa != 0:
		print('run err !!')
		exit(2)
