import numpy as np
import math

def calculateFuel(fuel):
    r=math.floor(fuel/3)
    f=r-2
    if(f<0):
        f=0

    if (f>0):
        f=f+calculateFuel(f)
    return f

#f=open("data/example.txt")
f=open("data/input.txt")

input=f.read();
print(input)
s=len(input)
layers=0
#width=3
#height=2
width=25
height=6

pixelsPerLayer=width*height
layers=int(s/pixelsPerLayer)
print("total="+str(s))
print("Ppl="+str(pixelsPerLayer))
print("layers="+str(layers))

layer = np.zeros((layers,height,width))
output = np.zeros((height,width))

zeros=0
ones=0
twos=0
savedZeros=-1
savedOnes=0
savedTwoes=0
for l in range(layers):
    
    zeros=0
    ones=0
    twos=0
    for h in range(height):
        for w in range(width):
            c=input[((height*width)*l)+(width*h)+w]
            layer[l,h,w]=int(c)
            #print(c)
            
            if (c=='0'):
                zeros=zeros+1
            if (c=='1'):
                ones=ones+1
            if (c=='2'):
                twos=twos+1
                
    if (savedZeros==-1):
        savedZeros=zeros
        savedOnes=ones
        savedTwos=twos
        
    if (zeros<savedZeros):
        savedZeros=zeros
        savedOnes=ones
        savedTwos=twos
                
    print("layer:"+str(l)+" zeros:"+str(zeros)+" ones:"+str(ones)+" twos:"+str(twos))
                
print("Finished")
total=savedOnes * savedTwos
print("saved:"+str(total))

for h in range(height):
    for w in range(width):
        transparent=True
        l=0
        while (transparent==True):
            c=layer[l,h,w]
            
            if (c==0.0):
                output[h,w]=0
                transparent=False
            if (c==1.0):
                output[h,w]=1
                transparent=False
            l=l+1


str=""
for h in range(height):
    for w in range(width):
        if (output[h,w]==0.0):
            str=str+" "
        if (output[h,w]==1.0):
            str=str+"#"
    print(str)
    str=""

str=""
for h in range(height):
    for w in range(width):
        if (output[h,w]==0.0):
            str=str+"#"
        if (output[h,w]==1.0):
            str=str+" "
    print(str)
    str=""



