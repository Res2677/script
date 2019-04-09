import threading
import os
import sys
import argparse
from itertools import islice

parser = argparse.ArgumentParser(description='manual to this script')
parser.add_argument('--conf', type = str, default = 'None')

option_dict = {}
args = parser.parse_args()
cfg = args.conf
ff = open(cfg).readlines()
for line in ff:
  if line.strip():
    line_t = line.strip()
    if line_t[0] != '#':
      line_k = line_t.split('#')
      option = line_k [0].split('=')
      option_dict[option[0].strip()] = option[1].strip()

def path_deal(k):
  path = k.split('/')
  m = "/".join(path)
  if path[-1] != '':
    m = m +'/'
  return m

process_path = path_deal(option_dict['process_path'])
result_path = path_deal(option_dict['result_path'])
os.popen('mkdir -p '+process_path)
os.popen('mkdir -p '+result_path)

prefix = option_dict['prefix']
hh = option_dict['target_bed'].split('/')
print hh[-1]
bed_m = hh[-1].split('.bed')
print bed_m[0]
bed1 = bed_m[0] + '.target.bed'
bed2 = bed_m[0] + '.antitarget.bed'

if (not option_dict['thread']):
  option_dict['thread'] = 4

sh_out = open(process_path + 'run.sh','w')

def coverage(bam,bed,output):
  cmd = 'python ' + option_dict['cnvkit_path'] + ' coverage '+ bam + ' ' + bed + ' -o ' + output + ' -p ' + option_dict['thread']
  sh_out.write(cmd + '\n')
  print cmd
  pp = os.popen(cmd)
  print pp.read()

print process_path
creat_bed = ''
ko1 = 'python ' + option_dict['cnvkit_path'] +' access -x '+ option_dict['target_bed'] + ' ' + option_dict['reffasta'] +' -o ' + process_path + 'access.bed'
ko2 = 'python ' + option_dict['cnvkit_path'] + ' autobin '+ option_dict['cancer_bam'] + ' -t ' + option_dict['target_bed'] + ' -g '+process_path+'access.bed --annotate '+option_dict['refflat']
sh_out.write(ko1 + '\n')
print ko1 
o1 = os.popen(ko1)
print o1.read()

sh_out.write(ko2 + '\n')
print ko2
o2 = os.popen(ko2)
print o2.read()

exitFlag = 0
 
class myThread (threading.Thread):
  def __init__(self, threadID, bam, bed, output):
    threading.Thread.__init__(self)
    self.threadID = threadID
    self.bam = bam
    self.bed = bed
    self.output = output
  def run(self):
    print "Starting " + self.threadID
    coverage(self.bam, self.bed, self.output)
    print "Exiting " + self.threadID

output1 = process_path + prefix + '_C.targetcoverage.cnn'
output2 = process_path + prefix + '_C.antitargetcoverage.cnn'
output3 = process_path + prefix + '_N.targetcoverage.cnn'
output4 = process_path + prefix + '_N.antitargetcoverage.cnn'
thread1 = myThread('t1',option_dict['cancer_bam'], bed1, output1)
thread2 = myThread('t2',option_dict['cancer_bam'], bed2, output2)
thread3 = myThread('t3',option_dict['normal_bam'], bed1, output3)
thread4 = myThread('t4',option_dict['normal_bam'], bed2, output4)
thread1.start()
thread2.start()
thread3.start()
thread4.start()
thread1.join()
thread2.join()
thread3.join()
thread4.join()
print "Exiting Main Thread"

ko4 = 'python ' + option_dict['cnvkit_path'] + ' reference -f '+ option_dict['reffasta'] + ' -t ' + process_path + prefix + '_C.targetcoverage.cnn' + ' -a ' + process_path + prefix + '_N.antitargetcoverage.cnn' + ' -o '+ process_path + 'N_reference.cnn'
print ko4
sh_out.write(ko4 + '\n')
o4 = os.popen(ko4)
print o4.read()

ko5 = 'python ' + option_dict['cnvkit_path'] + ' fix ' + process_path + prefix + '_C.targetcoverage.cnn ' + process_path + prefix + '_C.antitargetcoverage.cnn ' + process_path + 'N_reference.cnn -o ' + process_path + prefix + '_C.cnr'
print ko5
sh_out.write(ko5 + '\n')
o5 = os.popen(ko5)
print o5.read()

ko6 = 'python ' + option_dict['cnvkit_path'] + ' segment ' + process_path + prefix + '_C.cnr -o ' + process_path + prefix + '_C.cns'
print ko6
sh_out.write(ko6 + '\n')
o6 = os.popen(ko6)
print o6.read()

##plot
scatter_arr = option_dict['scatter'].split('&&')
for i in scatter_arr:
  cmd = 'python ' + option_dict['cnvkit_path'] + ' scatter -s ' + process_path + prefix +'_C.cn{s,r} ' + i
  sh_out.write(cmd)
  print cmd
  os.popen(cmd)

sed_cmd = 'sed -n \'1p\' ' +process_path + prefix +'_C.cns >' + process_path + prefix + '_C.d.cns'
awk_cmd = 'grep -v \'chromosome\' ' + process_path + prefix +'_C.cns |awk \'{if ($4!=\"-\") $4=\"-\";print $0}\' >>' + process_path + prefix + '_C.d.cns'

print sed_cmd
print awk_cmd

sh_out.write(sed_cmd + '\n')
o10_1 = os.popen(sed_cmd)
print o10_1.read()

sh_out.write(awk_cmd + '\n')
o10_2 = os.popen(awk_cmd)
print o10_2.read()

ko11 = 'python '+option_dict['cnvkit_path'] + '  diagram -s ' + process_path + prefix+ '_C.d.cns ' + process_path + prefix + '_C.cnr ' + option_dict['diagram']
print ko11
sh_out.write(ko11 + '\n')
o11 = os.popen(ko11)
print o11.read()
