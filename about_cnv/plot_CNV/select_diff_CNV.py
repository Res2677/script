import linecache
import argparse
import numpy as np
import pprint
from itertools import islice 
import re
parser = argparse.ArgumentParser(description='manaul of this script')
parser.add_argument('--log',type = int,default = None)
parser.add_argument('--cnr',type = str,default = None)
parser.add_argument('--gtf',type = str,default = None)
args =parser.parse_args()

def addtwodimdict(thedict, key_a, key_b, val): 
  if key_a in adic:  
    thedict[key_a].update({key_b: val})
  else:
    thedict.update({key_a:{key_b: val}})

chrom = {}
chrom_s = {}
chrom_e = {}
dictc = {}
gg = {}

gtf = open(args.gtf).readlines()
for i in gtf:
  k = i.split('\t')
  if (len(k) >=9):
    if (k[2] == 'gene'):
      m = re.search('gene_name "(.+)";  l',k[8])
      gene = m.group(1)
      chrom[gene]=k[0]
      chrom_s[gene]=k[3]
      chrom_e[gene]=k[4]

f = open(args.cnr)
for i in islice(f, 1, None):
  v = float(i.split('\t')[4])
  mmm = 0 - args.log
  if (v > args.log or v < mmm):
    chro = i.split('\t')[0]
    star = i.split('\t')[1]
    #end = i.split('\t')[2]
    gg[chro] = star

for gene in chrom.keys():
  if chrom[gene] in gg.keys():
    if (gg[chrom[gene]] > chrom_s[gene] and gg[chrom[gene]] < chrom_e[gene]):
      print gene
