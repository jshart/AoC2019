import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2019\\Day10\\data\\mydata");
// part 1 solution; 20,18=281 (minus 1 for the base)

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
        matrix[x][y]=new Location(x,y,false);
      }
    }
  }
}


int basex=0,basey=0;
int sx1=0,sy1=0,sx2=0,sy2=0;

void draw() {
  
  int x,y;
  
  background(50);
  
  // Draw the grid
  for (x=0;x<maxX;x++)
  {
    for (y=0;y<maxY;y++)
    {
      matrix[x][y].draw();
    }
  }
  matrix[basex][basey].drawBase();
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
  
  public void draw()
  {
    int tp=3;
    int r,g,b;
    
    // not an asteroid - so paint as black for "space"
    if (asteroid==false) 
    {
      r=0;
      g=0;
      b=0;
    }
    else
    {
      r=100;
      g=100;
      b=100;
    }
    
    fill(r,g,b);
    rect(cellx*gs,celly*gs,gs,gs);

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
