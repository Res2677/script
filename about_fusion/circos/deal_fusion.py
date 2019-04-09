import re
import argparse
import linecache
from itertools import islice
parser = argparse.ArgumentParser(description='manual to this script')
parser.add_argument('--txt', type = str, default = None)
parser.add_argument('--gout', type = str, default = None)
parser.add_argument('--lout', type = str, default = None)
args = parser.parse_args()

#conf
#circos_out = open('circos/circos.conf','w')
#bands_out = open('circos/bands.conf','w')
#ideogram_label_out = open ('ideogram.label.conf','w')
#ticks_out = open('circos/ticks.conf','w')

#data
gene_out = open(args.gout,'w')
link_out = open(args.lout,'w')

#capture
chr_arr = []
futxt = open(args.txt).readlines()
for line in futxt:
  lll = line.split("\t")
  gene = lll[0].split("--")
  pattern = re.compile(r"chr(\S+)\S:(\S+)-(\S+)")
  match1 = re.findall(pattern,lll[4])
  match2 = re.findall(pattern,lll[7])
  if (match1 and match2):
    gene_out.write("hs" + match1[0][0] + "\t" + match1[0][1] + "\t" + match1[0][2] + "\t" + gene[0] + "\n")
    gene_out.write("hs" + match2[0][0] + "\t" + match2[0][1] + "\t" + match2[0][2] + "\t" + gene[1] + "\n")
    link_out.write("hs" + match1[0][0] + "\t" + match1[0][1] + "\t" + match1[0][2] + "\t" + "hs" + match2[0][0] + "\t" + match2[0][1] + "\t" + match2[0][2] + "\n")
    chr_arr.append(match1[0][0])
    chr_arr.append(match2[0][0])

#write configure
