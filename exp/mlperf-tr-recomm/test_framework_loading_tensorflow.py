import time

start_time = time.time()

import tensorflow as tf
print(tf.__version__)

print("TensorFlow Initialization Time: {:.8}".format(time.time() - start_time))

for i in range(5):
    start_time = time.time()
    
    import tensorflow as tf
    print(tf.__version__)

    print("TensorFlow Cached Time: {:.8f}".format(time.time() - start_time))