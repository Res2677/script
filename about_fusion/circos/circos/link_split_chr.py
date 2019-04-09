file1 = open('/public/home/hangjf/cancer-changhai/CIRCOS/depth/ZF003.link.txt').readlines()
chro = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','Y']
for i in chro:
  for line in file1:
    if i in line:
      print i
      file1.remove(line)
