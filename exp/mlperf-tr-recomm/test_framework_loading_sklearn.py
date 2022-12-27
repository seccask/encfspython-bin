import time

start_time = time.time()

# import torch
# import torch.nn
# print(torch.__version__)

# import tensorflow as tf
# print(tf.__version__)

import sklearn
print(sklearn.__version__)

print("Scikit-Learn Initialization Time: {:.8}".format(time.time() - start_time))

for i in range(5):
    start_time = time.time()
    
    # import torch
    # import torch.nn
    # print(torch.__version__)
    
    # import tensorflow as tf
    # print(tf.__version__)
    
    import sklearn
    print(sklearn.__version__)

    print("Scikit-Learn Cached Time: {:.8f}".format(time.time() - start_time))