class CPU{
 
  Memory memory;
  Keyboard keyboard;
  
  CPU(Memory memory, Keyboard keyboard){
   this.memory = memory;
   this.keyboard = keyboard;
   
   memory.setMemory((short)0xFFF, (byte)0x0F);
  }
  
 void decodeExecute(short opcode){
   // Debug information
   if(CHIP8.DEBUG) System.out.println(String.format("Address: %x  |  Nibble: %x  |  X: %x  |  Y: %x  | KK: %x", extractAddress(opcode), extractNibble(opcode),  extractX(opcode),  extractY(opcode),  extractKK(opcode)));
 }
 
 // CPU instructions, see http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#3.1
 
 // 00E0
 void cls(){
   for(int x = 0; x < 64; x++){
    for(int y = 0; y < 32; y++){
     memory.screen[x][y] = false;
    }
   }
 }
 
 
 // Variable extraction from opcode, see http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#3.0
 private short extractAddress(short opcode){
  return (short)(opcode & 0xFFF);
 }
 
 private byte extractNibble(short opcode){
   return (byte) (opcode & 0x00F);
 }
 
 private byte extractX(short opcode){
   return (byte) ( (opcode & 0x0F00) >>> 8 );
 }
 
 private byte extractY(short opcode){
   return (byte) ( (opcode & 0x00F0) >>> 4);
 }
 
 private byte extractKK(short opcode){
   return (byte)(opcode & 0xFF);
 }
 
}
