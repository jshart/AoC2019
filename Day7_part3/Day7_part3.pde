import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

String filebase = new String("C:\\Users\\jsh27\\OneDrive\\Documents\\GitHub\\AoC2019\\Day7_part3\\data\\mydata");

//ArrayList<String> fieldLines = new ArrayList<String>();
//int numFieldLines=0;
//ArrayList<Long> invertedNumbers = new ArrayList<Long>();
//long[] invertedNumbers = new long[25];
//HashMap<Long, Long> memoryMap = new HashMap<Long, Long>();


// Raw input and parsed input lists for *all data*
InputFile input = new InputFile("input.txt");

// Master list of all suspect allergens
ArrayList<String> masterList = new ArrayList<String>();


int[][] perms=new int[][]{
  {5,6,7,8,9},
  {5,6,7,9,8},
  {5,6,8,7,9},
  {5,6,8,9,7},
  {5,6,9,7,8},
  {5,6,9,8,7},
  {5,7,6,8,9},
  {5,7,6,9,8},
  {5,7,8,6,9},
  {5,7,8,9,6},
  {5,7,9,6,8},
  {5,7,9,8,6},
  {5,8,6,7,9},
  {5,8,6,9,7},
  {5,8,7,6,9},
  {5,8,7,9,6},
  {5,8,9,6,7},
  {5,8,9,7,6},
  {5,9,6,7,8},
  {5,9,6,8,7},
  {5,9,7,6,8},
  {5,9,7,8,6},
  {5,9,8,6,7},
  {5,9,8,7,6},
  {6,5,7,8,9},
  {6,5,7,9,8},
  {6,5,8,7,9},
  {6,5,8,9,7},
  {6,5,9,7,8},
  {6,5,9,8,7},
  {6,7,5,8,9},
  {6,7,5,9,8},
  {6,7,8,5,9},
  {6,7,8,9,5},
  {6,7,9,5,8},
  {6,7,9,8,5},
  {6,8,5,7,9},
  {6,8,5,9,7},
  {6,8,7,5,9},
  {6,8,7,9,5},
  {6,8,9,5,7},
  {6,8,9,7,5},
  {6,9,5,7,8},
  {6,9,5,8,7},
  {6,9,7,5,8},
  {6,9,7,8,5},
  {6,9,8,5,7},
  {6,9,8,7,5},
  {7,5,6,8,9},
  {7,5,6,9,8},
  {7,5,8,6,9},
  {7,5,8,9,6},
  {7,5,9,6,8},
  {7,5,9,8,6},
  {7,6,5,8,9},
  {7,6,5,9,8},
  {7,6,8,5,9},
  {7,6,8,9,5},
  {7,6,9,5,8},
  {7,6,9,8,5},
  {7,8,5,6,9},
  {7,8,5,9,6},
  {7,8,6,5,9},
  {7,8,6,9,5},
  {7,8,9,5,6},
  {7,8,9,6,5},
  {7,9,5,6,8},
  {7,9,5,8,6},
  {7,9,6,5,8},
  {7,9,6,8,5},
  {7,9,8,5,6},
  {7,9,8,6,5},
  {8,5,6,7,9},
  {8,5,6,9,7},
  {8,5,7,6,9},
  {8,5,7,9,6},
  {8,5,9,6,7},
  {8,5,9,7,6},
  {8,6,5,7,9},
  {8,6,5,9,7},
  {8,6,7,5,9},
  {8,6,7,9,5},
  {8,6,9,5,7},
  {8,6,9,7,5},
  {8,7,5,6,9},
  {8,7,5,9,6},
  {8,7,6,5,9},
  {8,7,6,9,5},
  {8,7,9,5,6},
  {8,7,9,6,5},
  {8,9,5,6,7},
  {8,9,5,7,6},
  {8,9,6,5,7},
  {8,9,6,7,5},
  {8,9,7,5,6},
  {8,9,7,6,5},
  {9,5,6,7,8},
  {9,5,6,8,7},
  {9,5,7,6,8},
  {9,5,7,8,6},
  {9,5,8,6,7},
  {9,5,8,7,6},
  {9,6,5,7,8},
  {9,6,5,8,7},
  {9,6,7,5,8},
  {9,6,7,8,5},
  {9,6,8,5,7},
  {9,6,8,7,5},
  {9,7,5,6,8},
  {9,7,5,8,6},
  {9,7,6,5,8},
  {9,7,6,8,5},
  {9,7,8,5,6},
  {9,7,8,6,5},
  {9,8,5,6,7},
  {9,8,5,7,6},
  {9,8,6,5,7},
  {9,8,6,7,5},
  {9,8,7,5,6},
  {9,8,7,6,5}
};





void setup() {
  size(200, 200);
  background(0);
  stroke(255);
  frameRate(10);
  
  System.out.println("Working Directory = " + System.getProperty("user.dir"));
  println();
  input.printFile();
  
  int i=0,j=0,result=0;
  Maximum m=new Maximum();
  int maxEngines=5;
  boolean anEngineRunning=false;

  IntcodeProgram[] ip=new IntcodeProgram[maxEngines];
  
  // init all the engines, and cross-connect their I/O channels
  for (i=0;i<maxEngines;i++)
  {
    ip[i]=new IntcodeProgram(i,input.lines.get(0));
    if (i>0)
    {
      // this input needs to feed from the output of the previous one
      ip[i].input = ip[i-1].output;
    }
  }
  // the input of the very first element needs to link to the output
  // of the very last, in order to close the loop.
  ip[0].input=ip[maxEngines-1].output;
  
  
  // Loop through all permutations
  for (i=0;i<perms.length;i++)
  //for (i=0;i<1;i++)
  {
    // initialise all intcode engines with initial
    // state for this set of permutations. 
    for (j=0;j<maxEngines;j++)
    {
      ip[j].initialise();
      ip[j].running=true;
    }
    print("==== STARTING RUN {"+i+"} ==== with values; ");
    
    
    for (j=0;j<perms[i].length;j++)
    { 
      ip[j].input.pushValue(perms[i][j]);
      print(perms[i][j]+" ");
    }
    println();

    // to start the whole system off each time, we need to
    // prime the first engine with an additional input value
    ip[0].input.pushValue(0);
    
    
    // whilst any engines are running
    do
    {
      anEngineRunning=false;
 
      // check if any can execute
      for (j=0;j<maxEngines;j++)
      {   
        // If this thread is still running then execute it
        if (ip[j].running==true)
        {
          print("["+j+"] re-enter? |");
          
          anEngineRunning=true;
          
          // execute until we get an output
          result=ip[j].execute();
        }
      }
    } while(anEngineRunning==true);
        
    m.set(result);
    result=0;
    println();
    
    println("==== ENDING RUN {"+i+"} ==== R:"+anEngineRunning);

  }
  
  println("Maximum Value idenitied as:"+m.value);
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

public class StackValues
{
  ArrayList<Integer> values = new ArrayList<Integer>();

  public void dump()
  {
    int i=0;
    for (i=0;i<values.size();i++)
    {
      print("s["+i+"]="+values.get(i)+" ");
    }
  }
  
  public void pushValue(int i)
  {
    values.add(i);
  }
  
  public void reset()
  {
    values.clear();
  }
  
  public int popValue()
  {
    int i;
    i=values.get(0);
    values.remove(0);
    return(i);
  }
}

public class IntcodeProgram
{
  String[] rawData;
  HashMap<Integer, Integer> opcode = new HashMap<Integer, Integer>();
  StackValues input = new StackValues();
  StackValues output = new StackValues();
  int pc=0;
  int dl=0;
  boolean running=false;
  boolean yielded=false;
  int lastOutput=0;
  int threadID=-1;
  
  public IntcodeProgram(int id, String s)
  {
    threadID=id;
    
    rawData=s.split(",");
     
    initialise();
  }
  
  // Allows us to "chain" programs together, we can pass an
  // *output* stack to the input of this stack and have the
  // "threads" communicate via their I/O commands.
  public void connectToInput(StackValues s)
  {
    input=s;
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
     
     input.reset();
     output.reset();
     pc=0;
     running=false;
     lastOutput=0;
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
    yielded=false;

    while (running==true && yielded==false)
    {
      executeStep();
    }
    if (yielded==true)
    {
      print("["+threadID+"]___ YIELDING ____ PC="+pc+" |out size=["+output.values.size()+"] ");
      output.dump();
      print("|in size=["+input.values.size()+"] ");
      input.dump();
      println();
    }
    else
    {
      println("["+threadID+"]___ EXITING with ["+lastOutput+"] ____");
    }
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
    int savedPC=pc;
    
    rawOpcode=opcode.get(pc++);
    
    // Strip off the actual instruction
    command=rawOpcode % 100;
    rawOpcode-=command;
    rawOpcode/=100;

    if (dl>0)
    {
      println("["+threadID+"] OPCODE Parse cmd=["+command+"] mode bits=["+rawOpcode+"]");
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
        println("["+threadID+"] M"+i+":"+mode[i]);
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
          println("["+threadID+"] ->"+lhs+"+"+rhs+"->"+dest);
        }
        opcode.put(dest,(lhs+rhs));
        break;
        
      case 2: // multiple
        if (dl>0)
        {
          println("["+threadID+"] ->"+lhs+"*"+rhs+"->"+dest);
        }
        opcode.put(dest,(lhs*rhs));
        break;
        
      case 3: // input
        // If the input stack is empty, then we
        // yield until we have a value
        if (input.values.size()==0)
        {
          input.dump();
          yielded=true;
          // reset the PC
          pc=savedPC;
        }
        else
        {
          // pop an input value off the stack
          temp=input.popValue();
          
          if (dl>0)
          {
            println("["+threadID+"] ->IN="+temp+"->"+dest);
          }
          opcode.put(dest,temp);
        }
        break;
        
      case 4: // output
        println("["+threadID+"] OUTPUT==["+lhs+"]==");
        lastOutput=lhs;
        output.pushValue(lhs);        
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
          println("["+threadID+"] ->"+lhs+"<"+rhs+"->"+dest);
        }
        opcode.put(dest,(lhs<rhs?1:0));
        break;
        
      case 8: // equals
        if (dl>0)
        {
          println("["+threadID+"] ->"+lhs+"=="+rhs+"->"+dest);
        }
        opcode.put(dest,(lhs==rhs?1:0));
        break;
        
      case 99: // no-op
        running=false;
        break;
        
      default:
        println("["+threadID+"] *** UNKNOWN OPCODE="+command+" ***");
    }
    
    return;
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
