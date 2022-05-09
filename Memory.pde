class Memory{
  
  // Information taken from http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.1
  private byte[] memory;
  public boolean[][] screen;
  public short[] stack;
  public boolean drawFlag = false;
  
  // Building the font sprites, taken from http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.4
  private byte[] sprites = new byte[]{
        (byte)0xF0, (byte)0x90, (byte)0x90, (byte)0x90, (byte)0xF0,
        (byte)0x20, (byte)0x60, (byte)0x20, (byte)0x20, (byte)0x70,
        (byte)0xF0, (byte)0x10, (byte)0xF0, (byte)0x80, (byte)0xF0,
        (byte)0xF0, (byte)0x10, (byte)0xF0, (byte)0x10, (byte)0xF0,
        (byte)0x90, (byte)0x90, (byte)0xF0, (byte)0x10, (byte)0x10,
        (byte)0xF0, (byte)0x80, (byte)0xF0, (byte)0x10, (byte)0xF0,
        (byte)0xF0, (byte)0x80, (byte)0xF0, (byte)0x90, (byte)0xF0,
        (byte)0xF0, (byte)0x10, (byte)0x20, (byte)0x40, (byte)0x40,
        (byte)0xF0, (byte)0x90, (byte)0xF0, (byte)0x90, (byte)0xF0,
        (byte)0xF0, (byte)0x90, (byte)0xF0, (byte)0x10, (byte)0xF0,
        (byte)0xF0, (byte)0x90, (byte)0xF0, (byte)0x90, (byte)0x90,
        (byte)0xE0, (byte)0x90, (byte)0xE0, (byte)0x90, (byte)0xE0,
        (byte)0xF0, (byte)0x80, (byte)0x80, (byte)0x80, (byte)0xF0,
        (byte)0xE0, (byte)0x90, (byte)0x90, (byte)0x90, (byte)0xE0,
        (byte)0xF0, (byte)0x80, (byte)0xF0, (byte)0x80, (byte)0xF0,
        (byte)0xF0, (byte)0x80, (byte)0xF0, (byte)0x80, (byte)0x80
  };
  
  // Constructor
  public Memory(){
    this.memory = new byte[4096];
    // Screen is 64x32 pixels
    this.screen = new boolean[64][32];
    this.stack = new short[16];
   initMemory(); 
  }
  
  // http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#memmap
  void initMemory(){
    for(byte i = 0; i < sprites.length; i++){
     setMemory((short) i, sprites[i]); 
    }
  }
  
  byte getMemory(short address){
   if(address > 0xFFF){
     System.out.println("Memory out of range");
     return 0x0;
   }
   return memory[address];
  }
  
  void getMemory(short addressStart,short addressEnd){
    short addressCurrent = addressStart;
    while(addressCurrent <= addressEnd){
      System.out.println(String.format("0x%03X:  %02X",addressCurrent,memory[addressCurrent]));
      addressCurrent+=0x1;
    }
  }
  
  void setMemory(short address, byte value){
   if(address > 0xFFF){ 
     System.err.println("Error, value out of range"); 
   }else{
     memory[address] = (value);
   }
  }
  
  
}
