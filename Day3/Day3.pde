import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2019\\Day3\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
HashMap<String, Tracker> memoryMap = new HashMap<String, Tracker>();


// Raw input and parsed input lists for *all data*
InputFile input = new InputFile("input.txt");

// Master list of all suspect allergens
ArrayList<Wire> masterList = new ArrayList<Wire>();
Minimum target = new Minimum();

//int cpx=14000, cpy=6000;
int cpx=0, cpy=0;

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  input.printFile();
  
  int i=0,j=0;

  // Loop through each food...
  for (i=0;i<input.lines.size();i++)
  {
    println("WIRE:"+input.lines.get(i));
    masterList.add(new Wire(input.lines.get(i),i));
    masterList.get(i).executeWire();
    println("Min Manhattan;"+masterList.get(i).minManhattan);
  }
  println("Target dist;"+target.value);
  println();
}

void printMasterList()
{
  int i=0;
  for (i=0;i<masterList.size();i++)
  {
    masterList.get(i).printDirections();
  }
}


void draw() {  

}





public class InputFile
{
  ArrayList<String> lines = new ArrayList<String>();
  int numLines=0;
  String fileName;
  
  public InputFile(String fname)
  {
    fileName=fname;
    
    try {
      String line;
      
      File fl = new File(filebase+File.separator+fileName);
  
      FileReader frd = new FileReader(fl);
      BufferedReader brd = new BufferedReader(frd);
    
      while ((line=brd.readLine())!=null)
      {
        println("loading:"+line);
        lines.add(line);
      }
      brd.close();
      frd.close();
  
    } catch (IOException e) {
       e.printStackTrace();
    }
    
    numLines=lines.size();
  }
  
  public void printFile()
  {
    println("CONTENTS FOR:"+fileName);
    int i=0;
    for (i=0;i<numLines;i++)
    {
      println("L"+i+": "+lines.get(i));
    }
  }
}

public class Wire
{
  String[] directions;
  int x=cpx;
  int y=cpy;
  int dirIndex=0;
  int minX=0, maxX=0;
  int minY=0, maxY=0;
  int xrange=0,yrange=0;
  int distTravelledSoFar=0;
  int wireID=0;
  
  int debug=0;

  boolean manhattanFound=false;
  int minManhattan=0;

  public Wire(String input, int id)
  {
    directions=input.split(",");
    wireID=id;
  }
  
  public void printDirections()
  {
    int i=0;
    
    for (i=0;i<directions.length;i++)
    {
      println("D:"+directions[i]);
    }
  }
  
  public void executeWire()
  {
    int i=0;
    for (i=0;i<directions.length;i++)
    {
      step();
    }
    xrange=maxX-minX;
    yrange=maxY-minY;
    println("X in range:"+minX+","+maxX+"="+xrange+" x:"+x);
    println("Y in range:"+minY+","+maxY+"="+yrange+" y:"+y);
    println("Dist Travelled="+distTravelledSoFar);
  }
  
  public void step()
  {
    String t=directions[dirIndex];
    char d=t.charAt(0);
    int distToTravelThisStep=Integer.parseInt(t.substring(1,t.length()));
    int xDelta=0, yDelta=0;
 
    if (debug>0)
    {
      print("Running:"+t);
    }
    
    switch (d)
    {
      case 'R':
        //x+=dist;
        xDelta=distToTravelThisStep;
        break;
      case 'L':
        //x-=dist;
        xDelta=-distToTravelThisStep;
        break;
      case 'U':
        //y-=dist;
        yDelta=-distToTravelThisStep;
        break;
      case 'D':
        //y+=dist;
        yDelta=distToTravelThisStep;
        break;
    }
    recordSteps(distTravelledSoFar,xDelta,yDelta);
    x+=xDelta;
    y+=yDelta;
    
    distTravelledSoFar+=Math.abs(distToTravelThisStep);
    
    if (debug>0)
    {
      println(" New X,Y="+x+","+y);
    }
    maxX=(x>maxX?x:maxX);
    minX=(x<minX?x:minX);
    maxY=(y>maxY?y:maxY);
    minY=(y<minY?y:minY);
    dirIndex++;
  } 

  void recordSteps(int distSoFar, int xDelta, int yDelta)
  {
    int i=0;
    
    if (xDelta<0)
    {
      for (i=0;i!=xDelta;i--)
      {
        //println("-"+(x+i)+","+y);
        addStep(distSoFar+Math.abs(i),x+i,y);
      }
    }
    else
    {
      for (i=0;i!=xDelta;i++)
      {
        //println("-"+(x+i)+","+y);
        addStep(distSoFar+Math.abs(i),x+i,y);
      }
    }
    
    if (yDelta<0)
    {
      for (i=0;i!=yDelta;i--)
      {
        //println("-"+x+","+(y+i));
        addStep(distSoFar+Math.abs(i),x,y+i);
      }
    }
    else
    {
      for (i=0;i!=yDelta;i++)
      {
        //println("-"+x+","+(y+i));
        addStep(distSoFar+Math.abs(i),x,y+i);
      }
    }
  }

  void addStep(int distSoFar, int xs, int ys)
  {
    Tracker t=null;    
    String dKey = new String(xs+" "+ys);
    //println(dKey);

    // For this location - do we already have a tracker
    // (indicating that a wire has already passed through
    // this location)
    t=(Tracker)memoryMap.get(dKey);
    if (t==null)
    {
      //println("New Entry Needed;"+dKey);
      t = new Tracker();
    }
    else
    {
      //println("Clash, updating;"+dKey);
    }
    
    // At this point its either a pointer to the existing
    // tracker or a pointer to a new one - either way
    // set the bit to indicate the wire has been seen
    // at this location
    t.setWire(wireID,distSoFar);
    
    // if both wires are here - then we have a clash
    // and we should calculate the manhatten distance
    if (t.bm.bitSet(0)>0 && t.bm.bitSet(1)>0)
    {
      int manhattan=0;
      print("overlap, found;"+dKey);
      manhattan=Math.abs(xs)+Math.abs(ys);
      print(" Manhattan;"+manhattan);
      print(" dist[]:"+t.dist[0]+","+t.dist[1]);
      println(" total:"+t.totalDist());
      
      // Ignore orgin (0,0) case
      if (manhattan!=0)
      {
        setManhattan(manhattan);
        target.set(t.totalDist());
      }
    }
    memoryMap.put(dKey,t);
  }
  
  void setManhattan(int m)
  {
    if (manhattanFound==false)
    {
      minManhattan=m;
      manhattanFound=true;
    }
    else
    {
      if (m<minManhattan)
      {
        minManhattan=m;
      }
    }
  }
}

public class BitMask
{
  int bm=0;
  public BitMask()
  {
  }
  public int setBit(int i)
  {
    bm |= 1<<i;   
    return(bm);
  }
  public int bitSet(int i)
  {
    return(bm & (1<<i));
  }
  public void printBitMask()
  {
    println("BM:"+Integer.toBinaryString(bm));
  }
}

public class Tracker
{
  int maxWires=2; // Hard coded for now - as this example only has 2 wires
  int[] dist = new int[maxWires];
  boolean[] set = new boolean[maxWires];
  BitMask bm = new BitMask();
  
  public Tracker()
  {
  }

  public void setWire(int id, int d)
  {
    // Always set if this is the first time, but subsequently only set
    // if its less as we're trying to track the shortest distant. This
    // is overkill, as the *first* time should always be the shortest
    if (set[id]==false)
    {
      dist[id]=d;
      set[id]=true;
    }
    else
    {
      if (d<dist[id])
      {
        dist[id]=d;
      }
    }
    
    // Always set this bit.
    bm.setBit(id);
  }
  
  public int totalDist()
  {
    int i=0;
    int total=0;
    for (i=0;i<dist.length;i++)
    {
      total+=dist[i];
    }
    return(total);
  }
}

public class Minimum
{
  int value=0;
  boolean set=false;
  
  public Minimum()
  {
  }

  public void set(int v)
  {
    // Always set if this is the first time, but subsequently only set
    // if its less as we're trying to track the shortest distant. This
    // is overkill, as the *first* time should always be the shortest
    if (set==false)
    {
      value=v;
      set=true;
    }
    else
    {
      if (v<value)
      {
        value=v;
      }
    }
  }
}
