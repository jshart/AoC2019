import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2019\\Day10\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();


// Raw input and parsed input lists for *all data*
InputFile input = new InputFile("input.txt");

int maxX, maxY;
Location[][] matrix;
int gs=48;


void setup() {
  size(1200, 1200);
  background(0);
  stroke(255);
  frameRate(30);

  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  input.printFile();
  
  int i=0,j=0;
  
  int x,y;
  maxX=input.lines.get(0).length();
  maxY=input.lines.size();

  matrix = new Location[maxX][maxY];

  // load the matrix from the raw data of the file
  for (x=0;x<maxX;x++)
  {
    for (y=0;y<maxY;y++)
    {
      if (input.lines.get(y).charAt(x)=='#')
      {
        matrix[x][y]=new Location(x,y,true);
      }
      else
      {
        
        //matrix[x][y]=new Location(x,y,true);
        
        matrix[x][y]=new Location(x,y,false);
      }
    }
  }
  
}

//int xl=0;
//int yl=0;

//int xc=maxX/2;
//int yc=maxY/2;

int basex=0,basey=0;
int sx1=0,sy1=0,sx2=0,sy2=0;
boolean resetBaseCandidate=false;

void draw() {
  
  int x,y;
  
  background(50);
  
  // current candidate - but its not an
  // asteroid, so lets reset & skip.
  if (matrix[basex][basey].asteroid==false)
  {
    // CONDITION 1 for resetting the candidate
    // for the base location is met - this location
    // is not an asteroid and therefore we cant
    // build a base here
    resetBaseCandidate=true;
  }

  // We must be processing a valid base location if
  // there is no request to reset it - therefore
  // we should run a sweep.
  if (resetBaseCandidate==false)
  {
    // increase the radius of the scan zone
    sx1=(sx1>0?sx1-1:sx1);
    sy1=(sy1>0?sy1-1:sy1);
    sx2=(sx2>=maxX?maxX:sx2+1);
    sy2=(sy2>=maxY?maxY:sy2+1);
    
    // run a scan
    for (x=sx1;x<sx2;x++)
    {
      for (y=sy1;y<sy2;y++)
      {
        // mark that we want to highlight this location as its
        // part of this sweep.
        matrix[x][y].hl=true;
        
        // is this an asteroid? if so it means we can see it
        if (matrix[x][y].asteroid==true)
        {
          matrix[x][y].processed=true;
          // calculate the delta;
          //println("Ad;"+(x-basex)+","+(y-basey));
          matrix[x][y].dx=(x-basex);
          matrix[x][y].dy=(y-basey);
          matrix[x][y].factoriseDelta();
        }
      }
    }
    
    // if the radar has covered the whole area then signal
    // that we want to reset the target
    if (sx1==0 && sy1==0 && sx2>maxX-1 && sy2>maxY-1)
    {
      // CONDITION 2 for resetting the candidate
      // for the base location is met - we have completed
      // the sweep for all asteroids, and now know how to
      // score this location.
      resetBaseCandidate=true;
    }
  }
  
  // Draw the grid
  for (x=0;x<maxX;x++)
  {
    for (y=0;y<maxY;y++)
    {
      matrix[x][y].draw();
      
      // We're done with this sweep, so lets use
      // this convenient run of the draw cycle to
      // reset all the processed flags ready for
      // the next cycle.
      if (resetBaseCandidate==true)
      {
        matrix[x][y].reset();
      }
    }
  }
  matrix[basex][basey].drawBase();
  
  // OK time to reset the target - which can happen
  // if the existing target is an asteroid which
  // we've completed the sweep for, or if the current
  // slot is not actually an asteroid and therefore
  // not a valid candiate.
  if (resetBaseCandidate==true)
  {
    resetBaseCandidate=false;
  
    // Move on candiate base location
    basex++;
    if (basex>=maxX)
    {
      basex=0;
      basey++;
    }
    if (basey>=maxY)
    {
      basey=0;
    }
  
    // setup a sweep zone based on current base location
    sx1=basex;
    sy1=basey;
    sx2=sx1;
    sy2=sy1;
    setCardinalsAsBlocked(basex,basey);
  }
}

void setCardinalsAsBlocked(int x, int y)
{
  int i=0;
  boolean firstAsteroid=false;

  // South
  for (i=y+1;i<maxY;i++)
  {
    if (matrix[x][i].asteroid==true)
    {
      if (firstAsteroid==true)
      {
        matrix[x][i].blocked=true;
      }
      firstAsteroid=true;
    }
  }
  
  firstAsteroid=false;
  // East
  for (i=x+1;i<maxX;i++)
  {
    if (matrix[i][y].asteroid==true)
    {
      if (firstAsteroid==true)
      {
        matrix[i][y].blocked=true;
      }
      firstAsteroid=true;
    }
  }
  
  firstAsteroid=false;
  // North
  for (i=y-1;i>=0;i--)
  {
    if (matrix[x][i].asteroid==true)
    {
      if (firstAsteroid==true)
      {
        matrix[x][i].blocked=true;
      }
      firstAsteroid=true;
    }
  }
  
  firstAsteroid=false;
  // West
  for (i=x-1;i>=0;i--)
  {
    if (matrix[i][y].asteroid==true)
    {
      if (firstAsteroid==true)
      {
        matrix[i][y].blocked=true;
      }
      firstAsteroid=true;
    }
  }
}

void keyPressed()
{
  if (key==112) // p
  {
    frameRate(1);
  }
  if (key==103) // g
  {
    frameRate(30);
  }
  if (key==115) // s
  {
    noLoop();
  }
}

void drawLineN(int x1,int y1,int x2,int y2)
{
  int dx=x2-x1;
  int dy=y2-y1;
  int x=0,y=0;

  fill(255,0,0);

  for (x=x1;x<x2;x++)
  {
    y=y1+dy*(x-x1)/dx;
    println("X,Y>"+x+","+y);
    rect(x*gs,y*gs,gs,gs);
  }
}

void drawLineA(int d,float x1,float y1,float x2,float y2)
{
  float dx=(Math.abs(x2-x1))/2.0;
  float dy=(Math.abs(y2-y1))/2.0;
  int i=0;

  if (d>20)
  {
    return;
  }

  if (dx>0.5 || dy>0.5)
  {
    //print(d+" ");
    //for (i=0;i<d;i++)
    //{
    //    print("-");
    //}
    //print("x1,y1="+x1+","+y1);
    //print("|  dx,dy="+dx+","+dy);
    //println("|  x2,y2="+x2+","+y2);
    
    dx=(x2<x1?-dx:dx);
    dy=(y2<y1?-dy:dy);
    drawLineA(d+1,x1,y1,x1+dx,y1+dy);
    drawLineA(d+1,x1+dx,y1+dy,x2,y2);
  }
  else
  {
    
    dx=(x2<x1?-dx:dx);
    dy=(y2<y1?-dy:dy);
    fill(255,0,0);
    rect(Math.round(x1+dx)*gs,Math.round(y1+dy)*gs,gs,gs);
  }
}


public class Location
{
  boolean asteroid=false;
  boolean blocked=false;
  boolean processed=false;
  boolean hl=false;
  int cellx,celly;
  int dx=0,dy=0,sf=0;
  
  public void reset()
  {
    dx=0;
    dy=0;
    sf=0;
    processed=false;
    blocked=false;
    hl=false;
  }
  
  public Location(int x, int y, boolean a)
  {
    cellx=x;
    celly=y;
    asteroid=a;
  }
  
  public void simplifySlope()
  {
    int c;
    if (Math.abs(dx)<=1 || Math.abs(dy)<=1)
    {
      return;
    }
    if (Math.abs(dx)>Math.abs(dy))
    { 
      c=dx/dy;
      if ((c*dy)==dx)
      {
        sf=c;
      }
    }
    else
    {
      c=dy/dx;
      if ((c*dx)==dy)
      {
        sf=c;
      }
    }
  }
  
  public void factoriseDelta()
  {
    int a=Math.abs(dx);
    int b=Math.abs(dy);
    if (a>b)
    {
      sf=highestCommonFactor(a,b);
    }
    else
    {
      sf=highestCommonFactor(b,a);
    }
  }
  
  public int highestCommonFactor(int a, int b)
  {
    int i;
    int af=0,bf=0;
    
    for (i=b;i>1;i--)
    {
      af=a % i;
      bf=b % i;
      if (af==0 && bf==0)
      {
        return(i);
      }
    }
    return(0);
  }
  
  public void draw()
  {
    int tp=3;
    int r,g,b;
    if (asteroid==false)
    {
      fill(0,0,0);
    }
    else
    {
      r=100;
      g=100;
      b=100;
      if (processed==true)
      {
        r=255;
        g=69;
        b=0;
      }
      if (sf!=0)
      {
        r=0;
        g=100;
        b=100;
      }
      if (blocked==true)
      {
        r=0;
        g=150;
        b=150;
      }
      fill(r,g,b);
    }
    if (hl==true)
    {
      stroke(0,255,0);
      hl=false;
    }
    else
    {
      stroke(100,100,100);
    }
    rect(cellx*gs,celly*gs,gs,gs);
    if (asteroid==true)
    {
      stroke(0,255,0);
      fill(0,255,0);
      text(dx+","+dy+"#"+sf,(cellx*gs)+tp,(celly*gs)+gs-tp);
    }
  }
  
  public void drawBase()
  {
    fill(0,0,255);
    circle((cellx*gs)+gs/2,(celly*gs)+gs/2,gs/2);
  }
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

public class Maximum
{
  int value=0;
  
  public Maximum()
  {
  }

  public void set(int v)
  {

    if (v>value)
    {
      value=v;
    }
  }
}

public class LinkedList
{
  LinkedList forward=null;
  LinkedList back=null;
  int cupLabel=-1;
  
  public LinkedList(int c)
  {
    cupLabel=c;
  }
  
  public LinkedList(int c, LinkedList l)
  {
    cupLabel=c;
    back=l;
    l.forward=this;
  }
  
  public boolean inList(int c)
  {
    LinkedList start;
    LinkedList n;
    
    n=this;
    start=this;
    
    do 
    {
      if (n.cupLabel==c)
      {
        return(true);
      }
      n=n.forward;
    }
    while (n!=null && n!=start);
    return(false);
  }
  
  public LinkedList cutSubList(int nodes)
  {
    int i=0;
    LinkedList subListStart=null;
    LinkedList remainderList=null;
    LinkedList cutpoint=null;
    
    // capture the start of the sublist
    subListStart=this.forward;
    this.forward=null;
    cutpoint=this;
    
    // wind forward to the point where the remainder list starts
    remainderList=subListStart;
    for (i=0;i<nodes;i++)
    {
      remainderList=remainderList.forward;
    }
    
    // detach the sublist from the main list
    remainderList.back.forward=null;
    subListStart.back=null;
    
    //reattach the 2 halves of the list
    //println("recombining lists; this node");
    //this.printNode();
    //println("remainder:");
    //remainderList.printList();
    
    cutpoint.forward=remainderList;
    remainderList.back=cutpoint;

    //println("Combined list:");
    //this.printList();
    
    return(subListStart);
  }
  
  public void addListAfter(LinkedList subListToAdd)
  {
    LinkedList addToLocation=null;
    LinkedList nextNodeToAdd=null;
    
    addToLocation=this;
    boolean done=false;

    int max=5;
    
    do 
    {
      // is this the end of the sublist?
      if (subListToAdd.forward==null)
      {
        done=true;
      }
      else
      {
        // Save the next node
        nextNodeToAdd=subListToAdd.forward;
        
        // detach this one from the sub list.
        subListToAdd.forward=null;
      }

      //print("adding to node:");
      //addToLocation.printNode();

      //print("adding node:");
      //subListToAdd.printNode();
      subListToAdd.addNodeAfter(addToLocation);
      
      //print("node added:");
      //subListToAdd.printNode();
      
      // move forward after the node we just added
      addToLocation=addToLocation.forward;
      
      
      // move to the next node in the sublist we're trying to add
      subListToAdd=nextNodeToAdd;
    }
    while (done==false && max-- >=0);    
  }

  // Assumes an *always* valid node b to attach too, will optionally forward
  // link if b already has a forward link. i.e. will *insert* if b is middle
  // of a list, but will add if b is end of list.
  public void addNodeAfter(LinkedList b)
  {
    // save the current forward link, as we'll attach this node to that eventually
    LinkedList f=b.forward;
    
    // connect this node *backwards* to the b node...
    this.back=b;
    b.forward=this;
    
    if (f!=null)
    {
      // ... and *forwards* to the f node, which we saved earlier
      this.forward=f;
      f.back=this;
    }
  }

  public void printList()
  {
    LinkedList start;
    LinkedList n;
    
    n=this;
    start=this;
    
    do 
    {
      n.printNode();
      n=n.forward;
    }
    while (n!=null && n!=start);
  }
  
  
  public void printNode()
  {
    //println("C:"+cupLabel+" fwd cup label:"+(forward==null?"null":forward.cupLabel)+" back cup label:"+(back==null?"null":back.cupLabel));
    println((back==null?"null":back.cupLabel)+"<-["+cupLabel+"]->"+(forward==null?"null":forward.cupLabel));
  }
}

// Given a string, this class can create *all* permutations
// of that string by rearranging characters - each character
// is still used only the same amount of times as the original
// source.
public class Permutations
{
  String components;
  
  public Permutations(String s)
  {
    components=s;
  }
  
  public void walk()
  {
    walk(components,"");
  }
  
  public void walk(String input, String current)
  {
    int i=0;
    
    // for each character in the input
    for (i=0;i<input.length();i++)
    {
      // if there is more than 1 character left, then we need to fork and repeat
      // the walk for each new substring
      if (input.length()>1)
      {
        // lock in this char, by removing the character at the current index from the string
        String remainder=input.substring(0,i)+input.substring(i+1,input.length());
        //println(input.charAt(i)+" R:"+remainder);
        
        // walk the tree for the remaining characters now that we've locked one
        // in for this set of permuations.
        walk(remainder,current+input.charAt(i));
      }
      else
      {
        // we only have one character left, so we cant "walk" any further on this branch
        // dump the permuation so far, plus this last remaining char
        //println("[P]-->"+current+input);
        printPerm(current+input);
      }
    }
  }
  
  public void printPerm(String s)
  {
    int i=0;
    print("{");
    
    for (i=0;i<s.length();i++)
    {
      print(s.charAt(i));
      if (i+1<s.length())
      {
        print(",");
      }
    }
    println("},");
  }
}
