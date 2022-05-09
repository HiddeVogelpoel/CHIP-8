class Display{
  
  private Memory memory;
  
  private int scale, width, height;
  
  Display(Memory memory){
    this.memory = memory;
    scale = 20;
    width = 64 * scale;
    height = 32 * scale;
    initDisplay();
  }
  
  void initDisplay(){
   background(0);
  }
  
  void drawOnTick(){
    
  }
  
  void drawPixel(boolean white, int x, int y){
    if(white){
      fill(255);
    }else{
      fill(0); 
    }
    
    rect(x, y, scale, scale);
  }
  
  void drawScreen(){
   for(int y = 0; y < 32; y++){
    for(int x = 0; x < 64; x++){
     boolean white = memory.screen[x][y];
     drawPixel(white, x, y);
    }
   }
  }
}
