import os
import argparse
from itertools import islice
parser = argparse.ArgumentParser(description='manual to this script')

parser.add_argument('--genelist', type = str, default = None)
parser.add_argument('--generegion', type = str, default = None)
args = parser.parse_args()

gene_list = open(args.genelist).readlines()
for line in gene_list:
  gene = line.split()[0]
  awk_cmd = 'awk \'{if($1 == \"'+ gene +'\")print $0}\' ' +args.generegion  
  h = os.popen(awk_cmd).read()
  print h.strip()
#awk '{if($1 == "gene")print $0}' 
