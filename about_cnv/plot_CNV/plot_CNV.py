import argparse
import os
parser = argparse.ArgumentParser(description = "muanual of this script")
parser.add_argument('--conf',type = str,default =None)

option_dict = {}
args = parser.parse_args()
cfg = args.conf
ff = open(cfg).readlines()
for line in ff:
  if line.strip():
    line_t = line.strip()
    if line_t[0] != '#':
      line_k = line_t.split('\n#')
      option = line_k [0].split('=')
      option_dict[option[0].strip()] = option[1].strip()

def path_deal(k):
  path = k.split('/')
  m = "/".join(path)
  if path[-1] != '':
    m = m +'/'
  return m

outdir = path_deal(option_dict['outdir'])

gene_array = option_dict['gene'].split(',')

region_array = option_dict['region@mark@size'].split('&&')

#print gene_array 
#print region_array

for gene in gene_array:
  #grep = 'grep \'' + gene + '\' '+ option_dict['gene_ref']
  txt1name = gene + '.cnr'
  txt2name = gene + '.tran'
  txt1 = open(outdir + txt1name,'w')
  txt2 = open(outdir + txt2name,'w')
  grep1 = 'grep \'\"' + gene + '\"\' ' + option_dict['gene_gtf'] + '|awk \'{if ($3 == \"gene\") print $1,$4,$5}\''
  reg = os.popen(grep1).read()
  #scatter = os.popen(grep2).read()
  print gene
  #print reg
  reg_e = reg.split()
  print reg_e
  cnr = open(option_dict['cnr']).readlines()
  for line in cnr:
    m = line.split('\t')
    if (m[0] == reg_e[0] and m[1] > str(reg_e[1]) and m[1] < str(reg_e[2])):
