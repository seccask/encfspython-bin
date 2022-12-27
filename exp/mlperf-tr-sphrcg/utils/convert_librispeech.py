# Copyright (c) 2019, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#!/usr/bin/env python
import argparse
import os
import glob
import json
import time
import builtins

import pandas as pd

from preprocessing_utils import preprocess
# from preprocessing_utils import parallel_preprocess


SETUP = 'encfs'
INPUT_BASE = f'/mnt/ramdisk/{SETUP}/input'
DEST_BASE = f'/mnt/ramdisk/{SETUP}/dest'
# INPUT_BASE = '/data0/mlcask/slr12/LibriSpeech'
# DEST_BASE = '/data0/mlcask/out'


# builtins.num_part = -1


def process_one_file(args):
    args.input_dir = args.input_dir.rstrip('/')
    args.dest_dir = args.dest_dir.rstrip('/')

    def build_input_arr(input_dir):
        txt_files = glob.glob(os.path.join(input_dir, '**', '*.trans.txt'),
                            recursive=True)
        input_data = []
        for txt_file in txt_files:
            rel_path = os.path.relpath(txt_file, input_dir)
            with open(txt_file) as fp:
                for line in fp:
                    fname, _, transcript = line.partition(' ')
                    input_data.append(dict(input_relpath=os.path.dirname(rel_path),
                                        input_fname=fname+'.flac',
                                        transcript=transcript))
        return input_data


    print("[%s] Scaning input dir..." % args.output_json)
    
    start_time = time.time()
    dataset = build_input_arr(input_dir=args.input_dir)
    print('[SID] Duration: %f' % (time.time() - start_time))
    
    print("[%s] Converting audio files..." % args.output_json)
    
    def do_preprocess(input):
        dataset = []
        for d in input:
            # start_time = time.time()
            
            dataset.append(preprocess(data=d, 
                        input_dir=args.input_dir, 
                        dest_dir=args.dest_dir, 
                        target_sr=args.target_sr, 
                        speed=args.speed, 
                        overwrite=args.overwrite))
            
            # builtins.num_part += 1
            # if builtins.num_part > 0:
            #     print('[%d] Duration: %f' % (builtins.num_part, time.time() - start_time))
            
        return dataset
    
    start_time = time.time()
    do_preprocess(dataset)
    print('[PP] Duration: %f' % (time.time() - start_time))

    # dataset = parallel_preprocess(dataset=dataset,
    #                               input_dir=args.input_dir,
    #                               dest_dir=args.dest_dir,
    #                               target_sr=args.target_sr,
    #                               speed=args.speed,
    #                               overwrite=args.overwrite,
    #                               parallel=args.parallel)

    print("[%s] Generating json..." % args.output_json)
    
    start_time = time.time()
    
    df = pd.DataFrame(dataset, dtype=object)

    # Save json with python. df.to_json() produces back slashed in file paths
    dataset = df.to_dict(orient='records')
    
    with open(args.output_json, 'w') as fp:
        json.dump(dataset, fp, indent=2)

    print('[JSON] Duration: %f' % (time.time() - start_time))

parser = argparse.ArgumentParser(description='Preprocess LibriSpeech.')
parser.add_argument('--input_dir', type=str, required=True,
                    help='LibriSpeech collection input dir')
parser.add_argument('--dest_dir', type=str, required=True,
                    help='Output dir')
parser.add_argument('--output_json', type=str, default='./',
                    help='name of the output json file.')
parser.add_argument('-s','--speed', type=float, nargs='*',
                    help='Speed perturbation ratio')
parser.add_argument('--target_sr', type=int, default=None,
                    help='Target sample rate. '
                         'defaults to the input sample rate')
parser.add_argument('--overwrite', action='store_true',
                    help='Overwrite file if exists')
# parser.add_argument('--parallel', type=int, default=multiprocessing.cpu_count(),
#                     help='Number of threads to use when processing audio files')

setups = [
    f"--input_dir {INPUT_BASE}/train-clean-100 --dest_dir {DEST_BASE}/train-clean-100-wav --output_json {DEST_BASE}/librispeech-train-clean-100-wav.json",
    # f"--input_dir {INPUT_BASE}/train-clean-360 --dest_dir {DEST_BASE}/train-clean-360-wav --output_json {DEST_BASE}/librispeech-train-clean-360-wav.json",
    # f"--input_dir {INPUT_BASE}/train-other-500 --dest_dir {DEST_BASE}/train-other-500-wav --output_json {DEST_BASE}/librispeech-train-other-500-wav.json",
    # f"--input_dir {INPUT_BASE}/dev-clean --dest_dir {DEST_BASE}/dev-clean-wav --output_json {DEST_BASE}/librispeech-dev-clean-wav.json",
    # f"--input_dir {INPUT_BASE}/dev-other --dest_dir {DEST_BASE}/dev-other-wav --output_json {DEST_BASE}/librispeech-dev-other-wav.json",
    # f"--input_dir {INPUT_BASE}/test-clean --dest_dir {DEST_BASE}/test-clean-wav --output_json {DEST_BASE}/librispeech-test-clean-wav.json",
    # f"--input_dir {INPUT_BASE}/test-other --dest_dir {DEST_BASE}/test-other-wav --output_json {DEST_BASE}/librispeech-test-other-wav.json",
]


start_time = time.time()

for i, args_str in enumerate(setups):
    args = parser.parse_args(args_str.split())
    
    process_one_file(args)

print('Total Time: %f' % (time.time() - start_time))
