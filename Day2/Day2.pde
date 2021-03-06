import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2019\\Day2\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();


// Raw input and parsed input lists for *all data*
InputFile input = new InputFile("input.txt");

// Master list of all suspect allergens
ArrayList<String> masterList = new ArrayList<String>();

void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);
  
  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  input.printFile();
  
  int i=0,j=0,result=0;

  for (i=0;i<100;i++)
  {
    for (j=0;j<100;j++)
    {
      IntcodeProgram ip=new IntcodeProgram(input.lines.get(0));
      //ip.printCode();
      println("*** modify");
      ip.opcode.put(1,i);
      ip.opcode.put(2,j);
      println("*** execute");
      ip.execute();
      //ip.printCode();
      println("result:"+ip.opcode.get(0));
      if (ip.opcode.get(0)==19690720)
      {
        print(i+","+j);
        result=(100*i)+j;
        println(" RESULT:"+result);
        
        i=100;j=100;
        break;
      }
    }
  }
}

void printMasterList()
{
  int i=0;
  for (i=0;i<masterList.size();i++)
  {
    println("Allergen ML:"+masterList.get(i));
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

public class IntcodeProgram
{
  String[] rawData;
  HashMap<Integer, Integer> opcode = new HashMap<Integer, Integer>();
  int pc=0;
  int dl=0;
  
  public IntcodeProgram(String s)
  {
     rawData=s.split(",");
     
     int l=rawData.length;
     int i=0;
     int temp=0;
     
     for (i=0;i<l;i++)
     {
       temp=Integer.parseInt(rawData[i]);
       opcode.put(i,temp);
     }
  }
  
  public void printCode()
  {
     int i=0;
     int l=opcode.size();
     
     for (i=0;i<l;i++)
     {
        println(" Pos:"+i+" val:"+opcode.get(i)+" (Raw:"+rawData[i]+")");
     }
  }
  
  public void execute()
  {
    int command=0;
    int lhs=0, rhs=0, dest=0;
    
    while (true)
    {
      
      switch (command=opcode.get(pc++))
      {
        case 1: // add
          lhs=opcode.get(opcode.get(pc++));
          rhs=opcode.get(opcode.get(pc++));
          dest=opcode.get(pc++);
          if (dl>0)
          {
            println("->"+lhs+"+"+rhs+"->"+dest);
          }
          opcode.put(dest,(lhs+rhs));
          break;
        case 2: // multiple
          lhs=opcode.get(opcode.get(pc++));
          rhs=opcode.get(opcode.get(pc++));
          dest=opcode.get(pc++);
          if (dl>0)
          {
            println("->"+lhs+"*"+rhs+"->"+dest);
          }
          opcode.put(dest,(lhs*rhs));
          break;
        case 99: // no-op
          return;
      }
    }
  }
}
