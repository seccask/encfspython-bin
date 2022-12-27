import time

start_time = time.time()

import torch
import torch.nn
print(torch.__version__)

print("PyTorch Initialization Time: {:.8}".format(time.time() - start_time))

for i in range(5):
    start_time = time.time()
    
    import torch
    import torch.nn
    print(torch.__version__)

    print("PyTorch Cached Time: {:.8f}".format(time.time() - start_time))