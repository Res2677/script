import numpy as np  
import pprint   
a = np.array(  
                [[  2,  7,  11, 2],  
                [ 35,  9,  3, 1],  
                [ 22, 12,  1, 55]]  
             )  
  
a1 = a[:,::-1].T  
a2 = np.lexsort(a1)  
a3 = a[a2]
pprint.pprint(a[:,::-1])
pprint.pprint(a)
pprint.pprint(a1)
pprint.pprint(a2)
pprint.pprint(a3)

a4 = a[a[:,2].argsort()]
pprint.pprint(a4)
np.savetxt("asda.txt",a4,delimiter='\t')
