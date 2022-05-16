// Emulator is built using information from http://devernay.free.fr/hacks/chip8/C8TECH10.HTM

CPU cpu;
Memory memory;
Keyboard keyboard;
Display display;

int freqHz;              //CPU frequency
long periodNanos;       //Time for each cycle
int cyclesForRefreshing; //Cycles to refresh screen (60 times a second)
boolean noThread = true;

// Enable/Disable debug mode
public static boolean DEBUG = false;

void setup() {
  size(1280, 640);
  
  //the frequency of processing is set to 500Hz for the CPU
  this.freqHz = 500;
  this.periodNanos = 1000000000/ freqHz;
  this.cyclesForRefreshing = freqHz / 60;
  
  //initialization of the system components
  memory = new Memory();
  keyboard = new Keyboard();
  display = new Display(memory);
  cpu = new CPU(memory, keyboard);
  loadRom();
  //display.debugDisplay();
  
  for(int i = 0; i < 3; i++){
   cpu.fetch();
   cpu.incrementPC();
   cpu.decodeExecute();
  }
  
  emulationThread.start();
  
}

void draw(){
  
}

void loadRom(){
  byte bytes[] = loadBytes("test_opcode.ch8");
  short currentAddr = (short)0x200;
  int loadedBytes = 0;
  for(byte b: bytes){
   System.out.println(String.format("loading byte %x", b)); 
   memory.setMemory(currentAddr, b);
   currentAddr = (short)(currentAddr + 0x1);
   loadedBytes++;
  }
  System.out.println(String.format("Finished loading ROM with length of %d bytes", loadedBytes));
}

Thread emulationThread = new Thread(){
void run(){
  int emulatedCycles = 0; //Number of emulated cycles (reset every 500 (freqHz) cycles)

  //Number of emulated cycles (gets reseted every "cyclesForRefreshing" cycles).
  //Used for controlling refreshing rate of screen (set to 60hz)
  int refreshCycles = 0;

  //Variables used to measure time
  long passedTime = 0;
  long initTime;
  long endTime;
  
  while(true){
    //start counting time
    initTime = System.nanoTime();
    
    //fetch: load instructions from memory
    cpu.fetch();
    //increment PC before execution
    cpu.incrementPC();
    //decode and execute the instruction
    cpu.decodeExecute();
    
    //Actions done 60 times per second -> every cpuFreqHz/60 cycles
    if(refreshCycles%(cyclesForRefreshing)==0){
      refreshCycles=0;
      //4.- Update screen only every 1/60 seconds (Screen freq = 60Hz)
      if(memory.drawFlag){
        display.drawScreen();
        memory.drawFlag=false;
     }
     
     //5.- Decrement DT
     if(cpu.dt > 0){
       cpu.dt = (byte)(cpu.dt - 0x01);
     }
     
     //6.- Decrement ST. If previously on silence -> new sound. If now is 0 -> stop sound
     if(cpu.st > 0){
        //sound.startSound();
        cpu.st = (byte)(cpu.st - 0x01);
          if(cpu.st == 0){
            //sound.stopSound();   
          }
      }
    }
    
    //record the current time and increment the refresh cycle count
    endTime = System.nanoTime();
    refreshCycles++;
  
    waitForCompleteCycle(endTime,initTime); //Wait time to simulate real speed
  
    //after cycle complemeted, increment and record the current time
    endTime = System.nanoTime();
    emulatedCycles++;
    passedTime += (endTime - initTime);
  
    //after the cycles match the cpu frequency, reset the cycles count and time
    if(emulatedCycles == freqHz){
      System.out.println("Time to emulate " + freqHz + " Hz: " + passedTime/1000000.0 + " ms");
      emulatedCycles=0;
      passedTime=0;
    }
  
  }
}
};

void keyPressed(){
 keyboard.keyPressed(); 
}


//need to add comments later
void waitForCompleteCycle(long endTime, long initTime){

        long nanosToWait= periodNanos - (endTime - initTime);
        long initNanos = System.nanoTime();
        long targetNanos = initNanos + nanosToWait;
        while(System.nanoTime()<targetNanos){
            try {
                Thread.sleep(0);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }


    }
