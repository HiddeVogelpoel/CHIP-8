import java.util.Random;

class CPU{
  // Random
  private Random random;
 
 // Connections required
  private Memory memory;
  private Keyboard keyboard;
  
  // Registers
  public byte[] v; // Vx registers 0x0 - 0xf
  public short regI, pc; // Register to store memory addresses & Program Counter
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
  
 void decodeExecute(short opcode){
   // Debug information
   if(CHIP8.DEBUG) System.out.println(String.format("Address: %x  |  Nibble: %x  |  X: %x  |  Y: %x  | KK: %x", extractAddress(opcode), extractNibble(opcode),  extractX(opcode),  extractY(opcode),  extractKK(opcode)));
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
 
 // TODO: 8xy5, 8xy6, 8xy7, 8xyE
 
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
 
 // TODO: Ex9e, ExA1; both require keyboard inputs
 
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
