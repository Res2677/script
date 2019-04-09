import subprocess
import os
import re
import argparse
import linecache
from itertools import islice
parser = argparse.ArgumentParser(description='manual to this script')
parser.add_argument('--cbam', type = str, default = None)
parser.add_argument('--nbam', type = str, default = None)
parser.add_argument('--propath', type = str, default = None)
parser.add_argument('--plotpath', type = str, default = None)
parser.add_argument('--reffa', type = str, default = '/public/home/hangjf/data/database/STAR/GRCh38_gencode_v26_CTAT_lib_July192017/ref_genome.fa')
parser.add_argument('--refflat', type = str, default = '/public/home/hangjf/data/database/cnvkit/hg38/refFlat.txt')
parser.add_argument('--thread', type = int, default = 8)
parser.add_argument('--genelist', type = int, default = None)
parser.add_argument('--out', type = int, default = None)
args = parser.parse_args()

def path_deal(k):
  path = k.split('/')
  m = "/".join(path)
  if path[-1] != '':
    m = m +'/'
  return m

outdir = path_deal(args.out)
os.chdir(outdir)

bed_text = '''

'''

os.popen('mkdir -p '+ outdir)
circos_conf = open(outdir + 'circos.conf','w')
bands_conf = open(outdir + 'bands.conf','w')
ideogram_label_conf = open(outdir + 'ideogram.label.conf','w')
ticks_conf = open(outdir + 'ticks.conf','w')

circos_conf.write(circos_text)
bands_conf.write(bands_text)
ideogram_label_conf.write(ideogram_label_text)
ticks_conf.write(ticks_text)

#write configure
#circos_cmd = 'cd ' + outdir + ';/public/home/hangjf/software/circos-0.69-6/bin/circos -conf ' + outdir + 'circos.conf'
#print circos_cmd
#os.system(circos_cmd)
#pipe = subprocess.Popen(circos_cmd,shell=True,stdout=subprocess.PIPE).stdout
#print pipe.read()
#print k
