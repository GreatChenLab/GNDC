import sys
all_go = {}
with open(sys.argv[1],'r') as f1:
    for line in f1:
        l = line.strip()
        if l != '':
            ll = l.split('\t')
            all_go[ll[0]] = ll[1]+'\t'+ll[2]+'\t'+ll[3]
go_id = {}
id_go = {}
with open(sys.argv[2],'r') as f2:
    for line in f2:
        l = line.strip()
        if l != '' and not l.startswith('#'):
            ll = l.split('\t')
            if ' GOInfoGO=' in ll[-1]:
                ll_id = ll[0]
                GG = ll[-1].split(' GOInfoGO=')[1]
                if ll_id not in id_go:
                    id_go[ll_id] = {}
                for i in GG.split(';'):
                    if 'GO' in i:
                        id_go[ll_id][i] = ''
                        if i not in go_id:
                            go_id[i] = {}
                        go_id[i][ll_id] = ''
with open(sys.argv[3],'w') as f3:
    f3.write('SeqID\tAccession\tGOterm\tNameSpace\tDescription\n')
    for aa in id_go:
        for bb in id_go[aa]:
            if bb in all_go:
                f3.write(aa+'\t'+bb+'\t'+all_go[bb]+'\n')
            else:
                print('Can not find %s !!!'%(bb))
with open(sys.argv[4],'w') as f3:
    for aa in id_go:
        id_go_list = []
        for bb in id_go[aa]:
            id_go_list.append(bb)
        f3.write(aa+'\t'+'\t'.join(id_go_list)+'\n')
with open(sys.argv[5],'w') as f3:
    f3.write('GOID\tSeqNum\tSeqList\tGOterm\tNameSpace\tDescription\n')
    for aa in go_id:
        seq_id = []
        for i in go_id[aa]:
            seq_id.append(i)
        if aa in all_go:
            f3.write(aa+'\t'+str(len(seq_id))+'\t'+','.join(seq_id)+'\t'+all_go[aa]+'\n')
        else:
            print('Can not find %s !!!'%(aa))
