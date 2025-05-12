import sys
with open(sys.argv[1],'r') as f1,open(sys.argv[2],'w') as f2:
    f2.write('SeqID\tAccession\tAnnotation\n')
    for line in f1:
        l = line.strip()
        if l != '' and not l.startswith('#'):
            ll = l.split('\t')
            f2.write(ll[0]+'\t'+ll[1]+'\t'+ll[-1].split(' ',1)[-1].split(' GOInfoGO=')[0]+'\n')
