import os
import argparse
import linecache
from itertools import islice
parser = argparse.ArgumentParser(description='manual to this script')
parser.add_argument('--psl', type = str, default = None)
parser.add_argument('--fa', type = str, default = None)
parser.add_argument('--out', type = str, default= None)
args = parser.parse_args()
start_max = 2
end_min = 2
miss_max = 2
q_gap_max = 2
t_gap_max = 2

fudict = {}
psl_file = open(args.psl)
for line in islice(psl_file, 5, None):
  mess = line.strip().split()
  #print mess[1],mess[5],mess[6]
  if (int(mess[1]) <= miss_max and int(mess[5]) <= q_gap_max and int(mess[6]) <= t_gap_max):
    #print mess
    if mess[9] in fudict.keys():
      fudict[mess[9]].append(line)
    else:
      fudict[mess[9]] =[]
      fudict[mess[9]].append(line)

final_dict = dict()
for fusion in fudict.keys():
  if fudict[fusion] == []:
    continue
  #fusion_arr = fusion.split('.')
  fusion_name = fusion
  #print fusion_name
  upstream_d = {}
  downstream_d = {}
  upstream = ''
  downstream = ''
  upstream_max = 0
  cc = fudict[fusion][0].split()
  downstream_min = int(cc[10])
  length = int(cc[10])
  for line in fudict[fusion]:
    mess = line.split()
    #print mess
    end_e = int(mess[10])-end_min
    cha = int(mess[12]) - int(mess[11])
    if (int(mess[11]) <=start_max and int(mess[12]) >= end_e ):
      continue
    elif (cha > length):
      continue
    elif (int(mess[11]) <= start_max):
      if (int(mess[12]) >= upstream_max):
        upstream_d['start'] = mess[11]
        upstream_d['end'] = mess[12]
        upstream = line
        upstream_max = int(mess[11])
    #print int(mess[12]),end_e
    elif (int(mess[12]) >= end_e):
      #print int(mess[12]),end_e
      if (int(mess[11]) <= downstream_min):
        downstream_d['start'] = mess[11]
        downstream_d['end'] = mess[12]
        downstream = line
        downstream_min = int(mess[12])
    else:
      pass
    #print len(upstream_d['end'])
    if(upstream_d.has_key('end') and downstream_d.has_key('start')):
      pp = int(upstream_d['end']) - int(downstream_d['start'])
    else:
      pp = -1000
    try:
      if (pp > -2):
        res = upstream + downstream.strip()
        final_dict[fusion_name] = res
        #print upstream,downstream
    except:
      pass

#print final_dict
out_file = open(args.out,'w')
print >> out_file,'fusion\tsequence\tleft part\tleft seq\tleft on ref\tright part\tright seq\tright on ref'
fasta_c = len(open(args.fa).readlines())
for i in range(fasta_c):
  if (i-1) % 2 == 0:
    fu = linecache.getline(args.fa,i)
    seq = linecache.getline(args.fa,i+1).strip()
    fu_name = fu.strip('>').strip().split('fusion.')[1].split('.fasta')[0]
    if fu_name in final_dict.keys():
      up_mess = final_dict[fu_name].split('\n')[0]
      up_mess_arr = up_mess.split('\t')
      down_mess = final_dict[fu_name].split('\n')[1]
      down_mess_arr = down_mess.split('\t')
      up_seq = seq[int(up_mess_arr[11]):int(up_mess_arr[12])]
      down_seq = seq[int(down_mess_arr[11]):int(down_mess_arr[12])]
      up_sppos = up_mess_arr[13]+up_mess_arr[8]+':'+up_mess_arr[15]+'-'+up_mess_arr[16]
      down_sppos = down_mess_arr[13]+down_mess_arr[8]+':'+down_mess_arr[15]+'-'+down_mess_arr[16]
      fu_m = fu_name + '\t' + seq
      up_m = up_mess_arr[11]+'-'+up_mess_arr[12]+'\t'+up_seq+'\t'+up_sppos
      down_m = down_mess_arr[11]+'-'+down_mess_arr[12]+'\t'+down_seq+'\t'+down_sppos
      #print 'up_seq: ' + seq[int(up_mess_arr[11]):int(up_mess_arr[12])] + '\n' + 'down_seq: ' + seq[int(down_mess_arr[11]):int(down_mess_arr[12])]
      print >> out_file,fu_m + '\t' + up_m + '\t' + down_m
      #print (up_mess +'\n' + down_mess + '\n')
