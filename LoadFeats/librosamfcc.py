import librosa
import pandas as pd
import numpy as np
import pathlib
import csv
import os
import scipy.io as sio
from tqdm import tqdm

genres = ['blues' , 'classical' , 'country', 'disco', 'hiphop', 'jazz', 'metal', 'pop', 'reggae', 'rock']

print(genres)
for g in tqdm(genres):
    os.makedirs('./mfcc/'+g+'/',exist_ok=True)
    for filename in os.listdir('./genres/'+g):
        songname = './genres/'+g+'/'+filename
        #file = open('./mfcc/'+g+'/'filename+'.mfcc', 'w', newline='')
        y, sr = librosa.load(songname, mono=True, duration=30)
        #print(sr)
        chroma_stft = librosa.feature.chroma_stft(y=y, sr=sr)
	print(chroma_stft.shape)
        #rmse = librosa.feature.rmse(y=y)
        spec_cent = librosa.feature.spectral_centroid(y=y, sr=sr)
        spec_bw = librosa.feature.spectral_bandwidth(y=y, sr=sr)
        rolloff = librosa.feature.spectral_rolloff(y=y, sr=sr)
        zcr = librosa.feature.zero_crossing_rate(y)
        fcc = librosa.feature.mfcc(y=y, sr=sr)
        feats=np.append(fcc,chroma_stft,axis=0)
        feats=np.append(feats,spec_cent,axis=0)
        feats=np.append(feats,spec_bw,axis=0)
        feats=np.append(feats,rolloff,axis=0)
        feats=np.append(feats,zcr,axis=0)

        print(feats.shape)

        #np.savetxt('./mfcc/'+g+'/'+filename+'.mfcc',np.array(fcc), fmt='%.18e', delimiter=' ', newline='\n')
        loc =os.path.splitext('./mfcc/'+g+'/'+filename)[0]
        sio.savemat(loc+'.mat',{'data':feats})
    #    to_append = f'{filename} {np.mean(chroma_stft)} {np.mean(rmse)} {np.mean(spec_cent)} {np.mean(spec_bw)} {np.mean(rolloff)} {np.mean(zcr)}'
        #for e in mfcc:
        #    to_append += f' {np.mean(e)}'
        #to_append += f' {g}'
        #file = open('data.csv', 'a', newline='')
        #with file:''
    #        writer = csv.writer(file)
    #        writer.writerow(to_append.split())
