import java.util.Random;

class CPU{
  // Random
  private Random random;
 
 // Connections required
  private Memory memory;
  private Keyboard keyboard;
  
  // Registers
  public byte[] v; // Vx registers 0x0 - 0xf
  public short regI, pc, currentInstruction; // Register to store memory addresses & Program Counter
  public byte sp, dt, st; // Stack pointer, delay timer, sound timer

  
  
  CPU(Memory memory, Keyboard keyboard){
   random = new Random();
   this.memory = memory;
   this.keyboard = keyboard;
   v = new byte[16];
   regI = 0x0;
   pc = 0x200;
   sp = 0x0;
   dt = 0x0;
   st = 0x0;
   
  }
  
  void fetch(){
   byte msb = memory.getMemory(pc);
   byte lsb = memory.getMemory((short)(pc + 0x1));
   currentInstruction = (short)((short) (msb << 8) | (lsb & 0xFF));
  }
  
  void incrementPC(){
   pc = (short)(pc + 0x2); 
  }
  
 void decodeExecute(){
   // Debug information
   if(CHIP8.DEBUG) System.out.println(String.format("Address: %x  |  Nibble: %x  |  X: %x  |  Y: %x  | KK: %x", extractAddress(currentInstruction), extractNibble(currentInstruction),  extractX(currentInstruction),  extractY(currentInstruction),  extractKK(currentInstruction)));

   byte x = extractX(currentInstruction); // X
   byte y = extractY(currentInstruction); // Y
   byte nibble = extractNibble(currentInstruction); // N
   short addr = extractAddress(currentInstruction); // NNN
   byte kk = extractKK(currentInstruction);
   
   if(match(currentInstruction, 0, 0, 0xE, 0)){
    cls(); 
    return;
   }
   else if(match(currentInstruction, 0, 0, 0xE, 0xE)){
    ret();
    return;
   }
   else if(match(currentInstruction, 1, null, null, null)){
     jp(addr);
     return;
   }
   else if(match(currentInstruction, 2, null, null, null)){
    call(addr);
    return;
   }
   else if(match(currentInstruction, 3, null, null, null)){
     seByte(x, kk);
     return;
   }
   else if(match(currentInstruction, 4, null, null, null)){
     sneByte(x, kk);
     return;
   }
   else if(match(currentInstruction, 5, null, null, 0)){
    seReg(x, y); 
    return;
   }
   else if(match(currentInstruction, 6, null, null, null)){
    ldByteOnReg(x, kk);
    return;
   }
   else if(match(currentInstruction, 7, null, null, null)){
     addByte(x, kk);
     return;
   }
   else if(match(currentInstruction, 8, null, null, null)){
    byte last = extractNibbleAtPos(currentInstruction, 0); 
    
    switch(last){
      case 0x0:
        ldRegOnReg(x, y);
        return;
      
      case 0x1:
        or(x, y);
        return;
      
      case 0x2:
        and(x, y);
        return;
      
      case 0x3:
        xor(x, y);
        return;
      
      case 0x4:
        addReg(x, y);
        return;
      
      case 0x5:
        sub(x, y);
        return;
      
      case 0x6:
        shr(x);
        return;
      
      case 0x7:
        subn(x, y);
        return;
      
      case 0xE:
        shl(x);
        return;
      default:
      
    }
   }
   else if(match(currentInstruction, 9, null, null, 0)){
     sneReg(x, y);
     return;
   }
   else if(match(currentInstruction, 0xA, null, null, null)){
     ldAddrOnRegI(addr);
     return;
   }
   else if(match(currentInstruction, 0xB, null, null, null)){
     jpZero(addr);
     return;
   }
   else if(match(currentInstruction, 0xC, null, null, null)){
     rnd(x, kk);
     return;
   }
   else if(match(currentInstruction, 0xD, null, null, null)){
     draw(x, y, nibble);
     return;
   }
   else if(match(currentInstruction, 0xE, null, 0x9, 0xE)){
     skipIfPressed(x);
     return;
   }
   else if(match(currentInstruction, 0xE, null, 0xA, 0x1)){
     skipIfNotPressed(x);
     return;
   }
   else if(match(currentInstruction, 0xF, null, null, null)){
     if(match(currentInstruction, 0xF, null, 0x0, 0xF)){
      ldDTOnReg(x);
      return;
     }
     else if(match(currentInstruction, 0xF, null, 0x0, 0xA)){
       // TODO: add
      System.err.printf("Error instruction not found: %04X\n", currentInstruction);
      return;
     }
     else if(match(currentInstruction, 0xF, null, 0x1, 0x5)){
      loadRegOnDT(x);
      return;
     }
     else if(match(currentInstruction, 0xF, null, 0x1, 0x8)){
      loadRegOnST(x);
      return;
     }
     else if(match(currentInstruction, 0xF, null, 0x1, 0xE)){
      addToRegI(x);
      return;
     }
     else if(match(currentInstruction, 0xF, null, 0x1, 0xE)){
      addToRegI(x);
      return;
     }
     else if(match(currentInstruction, 0xF, null, 0x2, 0x9)){
      loadSpriteOnRegI(x);
      return;
     }
     else if(match(currentInstruction, 0xF, null, 0x3, 0x3)){
      loadBCDToMem(x);
      return;
     }
     else if(match(currentInstruction, 0xF, null, 0x5, 0x5)){
      loadRegSeqToMem(x);
      return;
     }
     else if(match(currentInstruction, 0xF, null, 0x6, 0x5)){
      loadMemSeqToReg(x);
      return;
     }
   }
   System.err.printf("Error instruction not found: %04X\n", currentInstruction);
   
 }
 
 // CPU instructions, see http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#3.1
 
 // 00E0 clear screen
 void cls(){
   for(int x = 0; x < 64; x++){
    for(int y = 0; y < 32; y++){
     memory.screen[x][y] = false;
    }
   }
   memory.drawFlag = true;
 }
 
 // 00EE return from subroutine
 void ret(){
   pc = memory.stack[sp];
   sp = (byte)(sp - 0x01);
 }
 
 // 1nnn jump to address nnn
 void jp(short addr){
  pc  = (short) (addr & 0x0FFF); 
 }
 
 // 2nnn call subroutine at nnn
 void call(short addr){
   sp = (byte)(sp + (byte)0x01);
   memory.stack[sp] = pc;
   pc = addr;
 }
 
 // 3xkk skip next instruction if Vx = kk  |  compare register Vx to byte kk, increase pc by 2 when equal
 void seByte(byte x, byte kk){
   if(v[x] == kk){
    pc = (short)(pc + (short)0x2); 
   }
 }
 
 // 4xkk skip next instruction if Vx != kk  |  compare register Vx to byte kk, increase pc by 2 when not equal
 void sneByte(byte x, byte kk){
   if(v[x] != kk){
    pc = (short)(pc + (short)0x2); 
   }
 }
 
 // 5xy0 skip next instruction if Vx = Vy  |  compare register Vx to register Vy, increase pc by 2 when equal
 void seReg(byte x, byte y){
   if(v[x] == v[y]){
    pc = (short)(pc + (short)0x2); 
   }
 }
 
 // 6xkk put value kk into register Vx
 void ldByteOnReg(byte x, byte kk){
  v[x] = kk; 
 }
 
 // 7xkk Vx+=kk  |  Add kk to value of Vx, store result in Vx
 void addByte(byte x, byte kk){
  v[x] = (byte)(v[x] + kk); 
 }
 
 // 8xy0 Set Vx = Vy
 void ldRegOnReg(byte x, byte y){
  v[x] = v[y]; 
 }
 
 // 8xy1 'Vx = Vx | Vy'
 void or(byte x, byte y){
   v[x] = (byte)(v[x] | v[y]);
 }
 
 // 8xy2 'Vx = Vx & Vy'
 void and(byte x, byte y){
  v[x] = (byte)(v[x] & v[y]); 
 }
 
 // 8xy3 'Vx = Vx ^ Vy'
 void xor(byte x, byte y){
  v[x] = (byte)(v[x] ^ v[y]); 
 }
 
 // 8xy4 'Vx = Vx + Vy', VF = carry bit
 void addReg(byte x, byte y){
  byte res = (byte)(v[x] + v[y]);
  
  // Overflow check requires unsigned int
  int intRes = (res & 0xFF); 
  int intVX = (v[x] & 0xFF);
  int intVY = (v[y] & 0xFF);
  
  if(intRes < intVY || intRes < intVX){
   v[0xF] = (byte)0x1; 
  }else{
    v[0xF] = (byte)0x0;
  }
  
  v[x] = res;
 }
 
 // 8xy5
 void sub(byte x, byte y){
  byte result = (byte)(v[x] - v[y]);
  int intVX = (v[x] & 0xFF);
  int intVY = (v[y] & 0xFF);
  
  if(intVX > intVY){
   v[0xF] = 0x1; 
  }else{
   v[0xF] = 0x0; 
  }
  
  v[x] = result;
 }
 
 // 8xy6
 void shr(byte x){
  byte lsb = (byte)(v[x] & (byte)0x01); 
  v[0xF] = lsb;
  int intVX = (v[x] & 0xFF);
  v[x] = (byte)(intVX >>> 1);
 }
 
 // 8xy7
 void subn(byte x, byte y){
  byte result = (byte)(v[y] - v[x]);
  int intVX = (v[x] & 0xFF);
  int intVY = (v[y] & 0xFF);
  
  if(intVY > intVX){
   v[0xF] = 0x1; 
  }else{
   v[0xF] = 0x0; 
  }
  
  v[x] = result;
  
 }
 
 // 8xye
 void shl(byte x){
  byte msb = (byte)(v[x] & 0x80);
  
  if(msb != 0){
   msb = (byte)0x1; 
  }
  
  v[0xF] = msb;
  
  int intVX = (v[x] & 0xFF);
  v[x] = (byte)(intVX << 1);
  
 }
 
 // 9xy0 skip next instruction if Vx != Vy  |  compare register Vx to register Vy, increase pc by 2 when not equal
 void sneReg(byte x, byte y){
   if(v[x] != v[y]){
     pc = (short)(pc + (short)0x2);
   }
 }
 
 // Annn I = nnn
 void ldAddrOnRegI(short addr){
   regI = addr;
 }
 
 // Bnnn jump to nnn + V0
 void jpZero(short addr){
  int intV0 = (v[0x0] & 0xFF);
  int intAddr = (addr & 0xFF);
  
  pc = (short)(intV0 + intAddr);
 }
 
 // Cxkk set Vx to random byte and kk
 void rnd(byte x, byte kk){
  byte rand = (byte) random.nextInt(266);
  v[x] = (byte)(rand & kk);
 }
 
 // Dxyn draw to screen
 void draw(byte x, byte y, byte nibble){
  byte readBytes = 0;
  
  byte vf = (byte)0x0;
  while(readBytes < nibble){
    byte currByte = memory.getMemory((short)(regI + readBytes));
    for(int i = 0; i <= 7; i++){
     int intX = (v[x] & 0xFF);
     int intY = (v[y] & 0xFF);
     
     int realX = (intX + i)%64;
     int realY = (intY + readBytes)%32;
     
     boolean prevPixel = memory.screen[realX][realY];
     boolean newPixel = prevPixel ^ isBitSet(currByte, 7 - i);
     memory.screen[realX][realY] = newPixel;
     
     if(prevPixel == true && newPixel == false){
       vf = (byte)0x1;
     }
    }
    v[0xF] = vf;
    readBytes++;
  }
  memory.drawFlag = true;
 }
 

 // Ex9e
 void skipIfPressed(byte x){
  byte key = (byte)(v[x] & 0xF);
  if(keyboard.pressed[key]){
   pc = (short)(pc + 0x2);  
  }
 }
 
 // ExA1
 void skipIfNotPressed(byte x){
  byte key = (byte)(v[x] & 0xF);
  if(!keyboard.pressed[key]){
   pc = (short)(pc + 0x2);  
  }
 }
 
 // Fx07 Vx = dt
 void ldDTOnReg(byte x){
  v[x] = dt; 
 }
 
 // TODO: Fx0A; requires keyboard input
 
 // Fx15 dt = Vx
 void loadRegOnDT(byte x){
  dt = v[x]; 
 }
 
 // Fx18 st = Vx
 void loadRegOnST(byte x){
  st = v[x]; 
 }
 
 // Fx1E I += Vx
 void addToRegI(byte x){
  int intVX = (v[x] & 0xFF);
  int intRegI = (regI & 0xFFFF);
  
  regI = (short)(intVX + intRegI);
 }
 
 // Fx29 I = set location of sprite for digit Vx
 void loadSpriteOnRegI(byte x){
  regI = (short)(0x000 + 5 * v[x]); 
 }
 
 // Fx33 The interpreter takes the decimal value of Vx, and places the hundreds digit in memory at location in I, the tens digit at location I+1, and the ones digit at location I+2.
 void loadBCDToMem(byte x){
  short startAddr = regI;
  int intVX = (v[x] & 0xFF);
  
  int hundred = intVX / 100;
  intVX = intVX - hundred * 100;
  
  int ten = intVX / 10;
  intVX = intVX - ten * 10;
  
  int units = intVX;
  
  memory.setMemory(startAddr, (byte) hundred);
  memory.setMemory((short) (startAddr + 1), (byte)ten);
  memory.setMemory((short) (startAddr + 2), (byte)units);
 }
 
 // Fx55
 void loadRegSeqToMem(byte x){
   for(byte reg = 0; reg <= x; reg++){
    memory.setMemory((short)(regI + reg), v[reg]);
   }
 }
 
 // Fx65
 void loadMemSeqToReg(byte x){
   for(byte reg = 0; reg <= x; reg++){
    v[reg] = memory.getMemory((short)(regI + reg));
   }
 }
 
 // Variable extraction from opcode, see http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#3.0
 private byte extractNibbleAtPos(short opcode, int pos){
   opcode = (short)(opcode >> pos*4);
   return (byte)(opcode & 0x000F);
 }
 
 //TODO: research later
 private boolean match(short opcode, Integer posThree, Integer posTwo, Integer posOne, Integer posZero){
   boolean matches = true;
   if(posThree != null){
     matches &= (posThree == extractNibbleAtPos(opcode, 3));
   }
   
   if(posTwo != null){
     matches &= (posTwo == extractNibbleAtPos(opcode, 2));
   }
   
   if(posOne != null){
     matches &= (posOne == extractNibbleAtPos(opcode, 1));
   }
   
   if(posZero != null){
     matches &= (posZero == extractNibbleAtPos(opcode, 0));
   }
   return matches;
 }
 
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
 
 private boolean isBitSet(byte b, int bit){
  return (b & ( 1 << bit)) != 0; 
 }
 
}
