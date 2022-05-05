class Memory{
  
  // Information taken from http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.1
  private byte[] memory;
  private boolean[][] screen;
  
  public Memory(){
    this.memory = new byte[4096];
    // Screen is 64x32 pixels
    this.screen = new boolean[64][32];
   initMemory(); 
  }
  
  // http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#memmap
  void initMemory(){
    
  }
  
  byte getMemory(short address){
   if(address > 0xFFF){
     System.out.println("Memory out of range");
     return 0x0;
   }
   return memory[address];
  }
  
  void setMemory(short address, byte value){
   if(address > 0xFFF){ 
     System.err.println("Error, value out of range"); 
   }else{
     memory[address] = (value);
   }
  }
}
