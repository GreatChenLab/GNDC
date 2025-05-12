import sys
import glob
import os
dd = os.path.abspath('./')
ll = glob.glob('%s/*.eps'%(dd))
ll.sort()
#aa = os.system('mkdir -p TMHMM_plot')
#if aa != 0:
#	print('run err !!')
#	exit(1)
for i in ll:
	ok_file = os.path.basename(i).rsplit('.eps',1)[0]
	#print(i+'\t'+ok_file)
	print('convert -density 500 %s -resize 100%% %s.pdf'%(i,ok_file))
	aa = os.system('convert -density 500 %s -resize 100%% %s.pdf'%(i,ok_file))
	if aa != 0:
		print('run err !!')
		exit(2)
	print('convert -density 500 %s -resize 100%% %s.png'%(i,ok_file))
	aa = os.system('convert -density 500 %s -resize 100%% %s.png'%(i,ok_file))
	if aa != 0:
		print('run err !!')
		exit(2)
