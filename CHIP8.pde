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
  
  memory.setMemory((short)0x123, (byte)0xFA);
  System.out.println(Byte.toUnsignedInt(memory.getMemory((short)0x123)));
  System.out.println(memory.getMemory((short)0xFFF));
  
  memory.getMemory((short) 0x000, (short) 0x50);
}

void draw() {
  // cpu.decodeExecute((short)0xF1D4);
}
