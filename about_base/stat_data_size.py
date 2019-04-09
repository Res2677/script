import argparse
import linecache
from itertools import islice
parser = argparse.ArgumentParser(description='manual to this script')
parser.add_argument('--fq', type = str, default = None)
args = parser.parse_args()

total = 0
fq_c = len(open(args.fq).readlines())
for i in range(fq_c):
  if (i-1) % 4 == 0:
    ll = len(linecache.getline(args.fq,i+1))
    total = total +ll
print total
