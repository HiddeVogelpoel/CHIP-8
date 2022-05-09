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
  
}

void draw() {
  // cpu.decodeExecute((short)0xF1D4);
}
