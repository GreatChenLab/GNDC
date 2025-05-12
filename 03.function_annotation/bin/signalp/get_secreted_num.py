import sys
num = 0
with open(sys.argv[1],'r') as f:
    f.readline()
    for line in f:
        if line.strip() != '':
            num += 1
with open(sys.argv[2],'w') as f:
    f.write('ProteinType\tNumber\n')
    f.write('Secreted protein\t%s\n'%(str(num)))