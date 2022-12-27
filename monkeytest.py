#!/usr/bin/env python
'''
MonkeyTest -- test your hard drive read-write speed in Python
A simplistic script to show that such system programming
tasks are possible and convenient to be solved in Python

The file is being created, then written with random data, randomly read
and deleted, so the script doesn't waste your drive

(!) Be sure, that the file you point to is not something
    you need, cause it'll be overwritten during test

Runs on both Python3 and 2, despite that I prefer 3
Has been tested on 3.5 and 2.7 under ArchLinux
Has been tested on 3.5.2 under Ubuntu Xenial
'''
from __future__ import division, print_function  # for compatability with py2

import os, sys
from random import shuffle
import argparse
import json

ASCIIART = r'''Brought to you by coding monkeys.
Eat bananas, drink coffee & enjoy!
                 _
               ,//)
               ) /
              / /
        _,^^,/ /
       (G,66<_/
       _/\_,_)    _
      / _    \  ,' )
     / /"\    \/  ,_\
  __(,/   >  e ) / (_\.oO
  \_ /   (   -,_/    \_/
    U     \_, _)
           (  /
            >/
           (.oO
'''
# ASCII-art: used part of text-image @ http://www.ascii-art.de/ascii/mno/monkey.txt
# it seems that its original author is Mic Barendsz (mic aka miK)
# text-image is a bit old (1999) so I couldn't find a way to communicate with author
# if You're reading this and You're an author -- feel free to write me

try:  # if Python >= 3.3 use new high-res counter
    from time import perf_counter as time
except ImportError:  # else select highest available resolution counter
    if sys.platform[:3] == 'win':
        from time import clock as time
    else:
        from time import time


def get_args():
    parser = argparse.ArgumentParser(description='Arguments', formatter_class = argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-f', '--file',
                        required=False,
                        action='store',
                        default='/tmp/monkeytest',
                        help='The file to read/write to')
    parser.add_argument('-s', '--size',
                        required=False,
                        action='store',
                        type=int,
                        default=128,
                        help='Total MB to write')
    parser.add_argument('-w', '--write-block-size',
                        required=False,
                        action='store',
                        type=int,
                        default=1024,
                        help='The block size for writing in KB')
    parser.add_argument('-r', '--read-block-size',
                        required=False,
                        action='store',
                        type=int,
                        default=512,
                        help='The block size for reading in KB')
    parser.add_argument('-j', '--json',
                        required=False,
                        action='store',
                        help='Output to json file')
    args = parser.parse_args()
    return args


class Benchmark:

    def __init__(self, file,write_mb, write_block_kb, read_block_kb):
        self.file = file
        self.write_mb = write_mb
        self.write_block_kb = write_block_kb
        self.read_block_kb = read_block_kb
        wr_blocks = int(self.write_mb * 1024 / self.write_block_kb)
        rd_blocks = int(self.write_mb * 1024 / self.read_block_kb)
        self.write_results = self.write_test(self.write_block_kb, wr_blocks)
        self.read_results = self.read_test(self.read_block_kb, rd_blocks)

    def write_test(self, block_size_kb, blocks_count, show_progress=True):
        '''
        Tests write speed by writing random blocks, at total quantity
        of blocks_count, each at size of block_size bytes to disk.
        Function returns a list of write times in sec of each block.
        '''
        # f = os.open(self.file, os.O_CREAT | os.O_WRONLY, 0o777)  # low-level I/O
        f = open(self.file, "wb")

        took = []
        for i in range(blocks_count):
            if show_progress and i % (1024 * 1) == 0:
                # dirty trick to actually print progress on each iteration
                sys.stdout.write('\rWriting: {:.2f} %'.format(
                    (i + 1) * 100 / blocks_count))
                sys.stdout.flush()
            buff = os.urandom(block_size_kb * 1024)
            start = time()
            # os.write(f, buff)
            f.write(buff)
            os.fsync(f)  # force write to disk
            t = time() - start
            took.append(t)

        # os.close(f)
        f.close()
        return took

    def read_test(self, block_size_kb, blocks_count, show_progress=True):
        '''
        Performs read speed test by reading random offset blocks from
        file, at maximum of blocks_count, each at size of block_size
        bytes until the End Of File reached.
        Returns a list of read times in sec of each block.
        '''
        # f = os.open(self.file, os.O_RDONLY, 0o777)  # low-level I/O
        f = open(self.file, "rb")
        # generate random read positions
        offsets = list(range(0, blocks_count * block_size_kb * 1024, block_size_kb * 1024))
        shuffle(offsets)

        took = []
        for i, offset in enumerate(offsets, 1):
            if show_progress and i % (1024 * 1) == 0:
                sys.stdout.write('\rReading: {:.2f} %'.format(
                    (i + 1) * 100 / blocks_count))
                sys.stdout.flush()
            start = time()
            # os.lseek(f, offset, os.SEEK_SET)  # set position
            f.seek(offset, os.SEEK_SET)  # set position)
            # buff = os.read(f, block_size)  # read from position
            buff = f.read(block_size_kb * 1024)
            t = time() - start
            if not buff: break  # if EOF reached
            took.append(t)

        # os.close(f)
        f.close()
        return took

    def print_result(self):
        result = ('\n\nWritten {} MB in {:.4f} s\n'
                  'WRITE {:.2f} MAX {max:.2f} MIN {min:.2f} (MB/s)\n'.format(
            self.write_mb, sum(self.write_results), self.write_mb / sum(self.write_results),
            max=self.write_block_kb / (1024 * min(self.write_results)),
            min=self.write_block_kb / (1024 * max(self.write_results))))
        result += ('\nRead {} x {} B blocks in {:.4f} s\n'
                   'READ {:.2f} MAX {max:.2f} MIN {min:.2f} (MB/s)\n'.format(
            len(self.read_results), self.read_block_kb,
            sum(self.read_results), self.write_mb / sum(self.read_results),
            max=self.read_block_kb / (1024 * min(self.read_results)),
            min=self.read_block_kb / (1024 * max(self.read_results))))
        print(result)
        #print(ASCIIART)


    def get_json_result(self,output_file):
        results_json = {}
        results_json["Written MB"] = self.write_mb
        results_json["Write time (sec)"] = round(sum(self.write_results),2)
        results_json["Write speed in MB/s"] = round(self.write_mb / sum(self.write_results),2)
        results_json["Read blocks"] = len(self.read_results)
        results_json["Read time (sec)"] = round(sum(self.read_results),2)
        results_json["Read speed in MB/s"] = round(self.write_mb / sum(self.read_results),2)
        with open(output_file,'w') as f:
            json.dump(results_json,f)


def main():
    args = get_args()
    benchmark = Benchmark(args.file, args.size, args.write_block_size, args.read_block_size)
    if args.json is not None:
        benchmark.get_json_result(args.json)
    else:
        benchmark.print_result()
    os.remove(args.file)

if __name__ == "__main__":
    main()
