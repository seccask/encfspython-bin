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
import os
# import multiprocessing
import librosa
import soundfile as sf

# import soxbindings as sox



def preprocess(data, input_dir, dest_dir, target_sr=None, speed=None,
               overwrite=True):
    speed = speed or []
    speed.append(1)
    speed = list(set(speed))  # Make uniqe

    input_fname = os.path.join(input_dir,
                               data['input_relpath'],
                               data['input_fname'])
    
    # input_sr = sox.file_info.sample_rate(input_fname)
    f = open(input_fname, 'rb')
    file = sf.SoundFile(f)
    # metadata = soundfile.info(file, verbose=True)
    # file = audioread.rawread.RawAudioFile(input_fname)
    y, input_sr = librosa.load(file)
    target_sr = target_sr or input_sr
    

    os.makedirs(os.path.join(dest_dir, data['input_relpath']), exist_ok=True)

    output_dict = {}
    output_dict['transcript'] = data['transcript'].lower().strip()
    output_dict['files'] = []

    fname = os.path.splitext(data['input_fname'])[0]
    for s in speed:
        output_fname = fname + '{}.wav'.format('' if s==1 else '-{}'.format(s))
        output_fpath = os.path.join(dest_dir,
                                    data['input_relpath'],
                                    output_fname)

        # if not os.path.exists(output_fpath) or overwrite:
            # cbn = sox.Transformer().speed(factor=s).convert(target_sr)
            # cbn.build(input_fname, output_fpath)
        y_out = librosa.resample(y, orig_sr=input_sr, target_sr=target_sr)
        y_out = librosa.effects.time_stretch(y_out, rate=s)
        with open(output_fpath, 'wb') as wf:
            sf.write(wf, y_out, target_sr)

        # file_info = sox.file_info.info(output_fpath)
        # file_info = {
        #     "name": metadata.name,
        #     "samplerate": metadata.samplerate,
        #     "channels": metadata.channels,
        #     "frames": metadata.frames,
        #     "duration": metadata._duration_str,
        #     "format": f"{metadata.format_info} ({metadata.format})",
        #     "subtype": f"{metadata.subtype_info} ({metadata.subtype})",
        # }
        file_info = {
            "name": output_fname,
            "samplerate": target_sr,
            "channels": y_out.shape[0] if len(y_out.shape) > 1 else 1,
            "frames": y_out.shape[1] if len(y_out.shape) > 1 else y_out.shape[0],
            "duration": (y_out.shape[1] / target_sr) if len(y_out.shape) > 1 else (y_out.shape[0] / target_sr),
        }
        file_info['fname'] = os.path.join(os.path.basename(dest_dir),
                                          data['input_relpath'],
                                          output_fname)
        file_info['speed'] = s
        output_dict['files'].append(file_info)

        # if s == 1:
            # file_info = sox.file_info.info(output_fpath)
            # output_dict['original_duration'] = file_info['duration']
            # output_dict['original_num_samples'] = file_info['num_samples']
            
    f.close()

    return output_dict


# def parallel_preprocess(dataset, input_dir, dest_dir, target_sr, speed, overwrite, parallel):
#     with multiprocessing.Pool(parallel) as p:
#         func = functools.partial(preprocess,
#             input_dir=input_dir, dest_dir=dest_dir,
#             target_sr=target_sr, speed=speed, overwrite=overwrite)
#         dataset = list(tqdm(p.imap(func, dataset), total=len(dataset)))
#         return dataset
