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
  
  
  //register keys
  keyboard.keyPressed();
  //debugging keys
  background(0);
  if(keyboard.pressed[0x1]){
    textSize(128);
    text('1', 100,100);
  }
  if(keyboard.pressed[0x4]){
  textSize(128);
    text('Q', 300,100);
  }
  //sets key array items to false
  keyboard.arraySet();
}
