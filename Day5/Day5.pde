import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2019\\Day5\\data\\mydata");

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


  IntcodeProgram ip=new IntcodeProgram(input.lines.get(0));
  ip.addInput(5);
  ip.execute();
  
  ip.initialise();
  ip.addInput(5);
  ip.execute();
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
  ArrayList<Integer> inputStack = new ArrayList<Integer>();
  boolean running=false;
  int lastOutput=0;
  
  public IntcodeProgram(String s)
  {
    rawData=s.split(",");
     
    initialise();
  }
  
  // clear all state info and reset to initial state
  // this allows the object to be re-enterant and
  // re-run repeatedly (e.g. with different input).
  public void initialise()
  {
     int l=rawData.length;
     int i=0;
     int temp=0;
     
     opcode.clear();
     
     for (i=0;i<l;i++)
     {
       temp=Integer.parseInt(rawData[i]);
       opcode.put(i,temp);
     }
     
     inputStack.clear();
     pc=0;
     running=false;
     lastOutput=0;
  }
  
  public void addInput(int i)
  {
    inputStack.add(i);
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
  
  public int execute()
  {
    running=true;
    
    while(running)
    {
      executeStep();
    }
    println("___ EXITING with ["+lastOutput+"] ____");
    return(lastOutput);
  }
  
  public void executeStep()
  {
    int command=0;
    int temp=0;
    int lhs=0, rhs=0, dest=0;
    int rawOpcode=0;
    int maxParams=3;
    int[] mode = new int[maxParams];
    int i=0;
    boolean needLhs=false, needRhs=false, needDest=false;

    rawOpcode=opcode.get(pc++);
    
    // Strip off the actual instruction
    command=rawOpcode % 100;
    rawOpcode-=command;
    rawOpcode/=100;

    if (dl>0)
    {
      println("OPCODE Parse cmd=["+command+"] mode bits=["+rawOpcode+"]");
    }

    // Recover the mode and default any missing modes to 0
    for (i=0;i<maxParams;i++)
    {
      if (rawOpcode>0)
      {
        mode[i]=rawOpcode%10;
        rawOpcode/=10;
      }
      else
      {
        mode[i]=0;
      }
    }
    
    if (dl>0)
    {
      for (i=0;i<maxParams;i++)
      {
        println("M"+i+":"+mode[i]);
      }
    }
    
    
    // Work out what class of parameters this command is
    // and decide which parameters it needs to pull from
    // the stack
    needLhs=false;
    needRhs=false;
    needDest=false;
    switch (command)
    {
      // Anything that needs dest?
      case 1: // Add
      case 2: // Multiple
      case 7: // less than
      case 8: // equals
        needLhs=true;
        needRhs=true;
        // intention fall through
      case 3: // input
        needDest=true;
        break;
        
      // Anything that doesnt need dest?
      case 5: // jump-if-true
      case 6: // jump-if-false
        needRhs=true;
        // intention fall through
      case 4: // output
        needLhs=true;
        break;
    }
    
    
    // Now pull the specific parameters that we need
    // from the stack based on the above classification
    if (needLhs==true)
    {
      if (mode[0]==0)
      {
        lhs=opcode.get(opcode.get(pc++));
      }
      else
      {
        lhs=opcode.get(pc++);
      }
    }
    if (needRhs==true)
    {
      if (mode[1]==0)
      {
        rhs=opcode.get(opcode.get(pc++));
      }
      else
      {
        rhs=opcode.get(pc++);
      }
    }
    if (needDest==true)
    {
      dest=opcode.get(pc++);
    }
    
    
    // Now that we've fetched the parameters and decoded
    // the addressing modes, we should now actually
    // execute the logic based on the command in question
    switch (command)
    {
      case 1: // add
        if (dl>0)
        {
          println("->"+lhs+"+"+rhs+"->"+dest);
        }
        opcode.put(dest,(lhs+rhs));
        break;
        
      case 2: // multiple
        if (dl>0)
        {
          println("->"+lhs+"*"+rhs+"->"+dest);
        }
        opcode.put(dest,(lhs*rhs));
        break;
        
      case 3: // input
        // pop an input value off the stack
        temp=inputStack.get(0);
        inputStack.remove(0);
        
        if (dl>0)
        {
          println("->IN="+temp+"->"+dest);
        }
        opcode.put(dest,temp);
        break;
        
      case 4: // output
        println("OUTPUT==["+lhs+"]==");
        lastOutput=lhs;
        break;

      case 5: // jump-if-true
        if (lhs!=0)
        {
          pc=rhs;
        }
        break;
        
      case 6: // jump-if-false
        if (lhs==0)
        {
          pc=rhs;
        }
        break;
        
      case 7: // less than
        if (dl>0)
        {
          println("->"+lhs+"<"+rhs+"->"+dest);
        }
        opcode.put(dest,(lhs<rhs?1:0));
        break;
        
      case 8: // equals
        if (dl>0)
        {
          println("->"+lhs+"=="+rhs+"->"+dest);
        }
        opcode.put(dest,(lhs==rhs?1:0));
        break;
        
      case 99: // no-op
        running=false;
        break;
        
      default:
        println("*** UNKNOWN OPCODE="+command+" ***");
    }
    
    return;
  }
}
