// Emulator is built using information from http://devernay.free.fr/hacks/chip8/C8TECH10.HTM

CPU cpu;
Memory memory;
Keyboard keyboard;

//remove later
boolean newletter;  


// Enable/Disable debug mode
public static boolean DEBUG = true;

void setup() {
  
  memory = new Memory();
  keyboard = new Keyboard();
  cpu = new CPU(memory, keyboard);
  
  memory.setMemory((short)0x123, (byte)0xFA);
  System.out.println(Byte.toUnsignedInt(memory.getMemory((short)0x123)));
  System.out.println(memory.getMemory((short)0xFFF));
  
  
  //for debug
  size(640, 360);
  noStroke();
  background(0);
  frameRate(60);
  
}

void draw() {
  // cpu.decodeExecute((short)0xF1D4);
  
  //use for debug
  background(0);
  if(newletter == true) {
    newletter = false;
  }
}

void keyPressed()
{
  
  /*
  // If the key is between 'A'(65) to 'Z' and 'a' to 'z'(122)
  if((key >= 'A' && key <= 'Z') || (key >= 'a' && key <= 'z')) {
    int keyIndex;
    if(key <= 'Z') {
      keyIndex = key-'A';
    } else {
      keyIndex = key-'a';
    }
  } else {
    fill(0);
  }
  */
  if(key == 'A' || key == 'a'){
    text('A', 50,50);
  }
  
  newletter = true;
}
