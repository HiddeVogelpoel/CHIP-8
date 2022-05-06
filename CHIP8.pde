// Emulator is built using information from http://devernay.free.fr/hacks/chip8/C8TECH10.HTM

CPU cpu;
Memory memory;
Keyboard keyboard;

// Enable/Disable debug mode
public static boolean DEBUG = true;

void setup() {
  
  memory = new Memory();
  keyboard = new Keyboard();
  cpu = new CPU(memory, keyboard);
}

void draw() {
  // cpu.decodeExecute((short)0xF1D4);
}
