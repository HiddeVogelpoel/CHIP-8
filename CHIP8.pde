// Emulator is built using information from http://devernay.free.fr/hacks/chip8/C8TECH10.HTM

CPU cpu;
Memory memory;
Keyboard keyboard;
Display display;

// Enable/Disable debug mode
public static boolean DEBUG = true;

void setup() {
  size(1280, 640);
  
  memory = new Memory();
  keyboard = new Keyboard();
  display = new Display(memory);
  cpu = new CPU(memory, keyboard);
  loadRom();
  
  for(int i = 0; i < 3; i++){
   cpu.fetch();
   cpu.incrementPC();
   cpu.decodeExecute();
  }
  
}

void draw() {
  if(memory.drawFlag){
    display.drawScreen();
    memory.drawFlag = false;
  }
  
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