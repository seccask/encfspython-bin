import os

CHUNKSIZE = 65536
EXCLUDES = "/.git"
SETUP = 'encfs'

RAW_PATH = '/data0/mlcask/cityscapes'
ENC_PATH = f'/mnt/ramdisk/{SETUP}/cityscapes'

def files(root: str):
    for path, subdirs, files in os.walk(root):
        for name in files:
            yield os.path.join(path, name)
            
if __name__ == "__main__":
    current_path = RAW_PATH
    enc_path = ENC_PATH
    os.makedirs(enc_path, exist_ok=True)
    
    for src in files(current_path):
        if EXCLUDES in src:
            print("Excluding", src)
            continue
        dest = os.path.join(enc_path, os.path.relpath(src, current_path))
        os.makedirs(os.path.dirname(dest), exist_ok=True)
        print(f"Encrypting {src} to {dest}")
        with open(src, "rb") as rf:
            with open(dest, "wb") as wf:
                while True:
                    chunk = rf.read(CHUNKSIZE)
                    if not chunk:
                        break

                    wf.write(chunk)
    
    # src = '/data0/mlcask/criteo/day_0'
    # dest = os.path.join(f'/mnt/ramdisk/{SETUP}', os.path.basename(src))
    # os.makedirs(os.path.dirname(dest), exist_ok=True)
    # print(f"Encrypting {src} to {dest}")
    
    # with open(src, "r", encoding='utf-8') as rf:
    #     with open(dest, "w", encoding='utf-8') as wf:
    #         for line in rf:
    #             wf.write(line)

    # with open(src, "rb") as rf:
    #     with open(dest, "wb") as wf:
    #         while True:
    #             chunk = rf.read(CHUNKSIZE)
    #             if not chunk:
    #                 break

    #             wf.write(chunk)