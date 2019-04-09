def addtwodimdict(thedict, key_a, key_b, val): 
    if key_a in thedict:
        thedict[key_a].update({key_b: val})
    else:
        thedict.update({key_a:{key_b: val}})

ddd = {}
addtwodimdict(ddd,'a',21314,24124)
addtwodimdict(ddd,'a',213444,4124)
addtwodimdict(ddd,'b',2155,1224)
addtwodimdict(ddd,'b',21364,1234)

for i in ddd.keys():
  print min(ddd[i].keys())

