import math

min=128392
max=643281
min2 = 111120
max2 = min2+4

def sameDigits(x):
    strX=str(x)
    inMatch=False
    matchString=""
    i=0
    #print("\nTesting:"+strX)
    while i<len(strX):
        if inMatch==False:
            # start new match - create a new match string
            # starting from this digit
            #print("checking:"+strX[i]+" as new match")

            matchString=strX[i]
            inMatch=True
        else:
            #print("-- checking:"+strX[i]+" in existing match")
            checkEndCase=False;

            # already in a match, so check if this is still
            # valid, or if we have ended.
            if strX[i] == matchString[0]:
                # Still good - add the digit and move on
                matchString = matchString + strX[i]
                #print("--- apending due to match")
                
                if (i==len(strX)-1):
                    checkEndCase=True
            else:
                checkEndCase=True
                
            if (checkEndCase==True):
                # Match has ended - did we get one we wanted?
                inMatch=False
                i=i-1
                if (len(matchString)==2):
                    # string is the right length, return as the match is good
                    #print("Found matching string:"+strX+" based on:"+matchString)
                    return True
                #else:
                    #print("-- existing match failed")
        i=i+1
        
    return False

def digitsDontDecrease(x):
    strX=str(x)
    oldChar=strX[0]
    for y in strX:
        if int(y)<int(oldChar):
            return False
        oldChar=y
    return True

f1=False
f2=False
total=0
for x in range(min, max):
    if sameDigits(x) == True:
        #print("Found matching digits for: "+str(x))
        f1=True
    if digitsDontDecrease(x) == True:
        #print("Found non decreasing digits for: "+str(x))
        f2=True
    
    if f1==True and f2==True:
        print("Found match: "+str(x))
        total=total+1
    f1=False
    f2=False
        
print("Final Total:"+str(total))
