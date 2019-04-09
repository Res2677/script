from sys import argv
def rev(s):
  ss = ''
  l = len(s)-1
  while l >= 0:
    ss += s[l]
    l -= 1
  return ss

def comp(j):
  ss = ''
  l = len(j)
  for i in range(l):
    if j[i] == 'A':
      ss = ss + 'T'
    if j[i] == 'T':
      ss = ss + 'A'
    if j[i] == 'G':
      ss = ss + 'C'
    if j[i] == 'C':
      ss = ss + 'G'
    else:
      pass
  return ss
m = rev(argv[1])
k = comp(m)
p = comp(argv[1])
print (argv[1])
print (m)
print (p)
print (k)
