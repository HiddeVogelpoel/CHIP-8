// Reference: http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#2.3

/**
 * ORIGINAL:
 * 1 2 3 C
 * 4 5 6 D
 * 7 8 9 E
 * A 0 B F
 *
 * MAPPED:
 * 1 2 3 4
 * Q W E R
 * A S D F
 * Z X C V
 */

class Keyboard{
  //the array stores the states of pressed keys
  public boolean[] pressed = new boolean[16];
  
  public HashMap<Character, Byte> keys;
 
  Keyboard(){
    keys = new HashMap<Character, Byte>();
    hashSet();
    arrayReset();
    keyPressed();
  }
  
  void hashSet(){
    keys.put('1', (byte)0x1);
    keys.put('2', (byte)0x2);
    keys.put('3', (byte)0x3);
    keys.put('4', (byte)0xC);
    keys.put('Q', (byte)0x4);
    keys.put('W', (byte)0x5);
    keys.put('E', (byte)0x6);
    keys.put('R', (byte)0xD);
    keys.put('A', (byte)0x7);
    keys.put('S', (byte)0x8);
    keys.put('D', (byte)0x9);
    keys.put('F', (byte)0xE);
    keys.put('Z', (byte)0xA);
    keys.put('Y', (byte)0xA);
    keys.put('X', (byte)0x0);
    keys.put('C', (byte)0xB);
    keys.put('V', (byte)0xF);
  }
  
  //set all values to false in array to avoid stuck keys
  void arrayReset(){
    pressed[0x1] = false;
    pressed[0x2] = false;
    pressed[0x3] = false;
    pressed[0xC] = false;
    pressed[0x4] = false;
    pressed[0x5] = false;
    pressed[0x6] = false;
    pressed[0xD] = false;
    pressed[0x7] = false;
    pressed[0x8] = false;
    pressed[0x9] = false;
    pressed[0xE] = false;
    pressed[0xA] = false;
    pressed[0x0] = false;
    pressed[0xB] = false;
    pressed[0xF] = false;
  }

  //reset array if no keys are pressed
  void checkKeyPress(){
    if(!keyPressed){
      arrayReset();
    }
  }
  
  //event for the input check
  void keyPressed(){
    //for each detected pressed key, change the boolean state in the mapped array
    //number 1 key
    if(key == '1'){
      pressed[0x1] = true;
    }
    else{
      pressed[0x1] = false;
    }
    //number 2 key
    if(key == '2'){
      pressed[0x2] = true;
    }
    else{
      pressed[0x2] = false;
    }
    //number 2 key
    if(key == '3'){
      pressed[0x3] = true;
    }
    else{
      pressed[0x3] = false;
    }
    //number 4 key
    if(key == '4'){
      pressed[0xC] = true;
    }
    else{
      pressed[0xC] = false;
    }
    //Q letter detection in both upper and lowercases
    if(key == 'Q' || key == 'q'){
      pressed[0x4] = true;
    }
    else{
      pressed[0x4] = false;
    }
    //W letter detection in both upper and lowercases
    if(key == 'W' || key == 'w'){
      pressed[0x5] = true;
    }
    else{
      pressed[0x5] = false;
    }
    //E letter detection in both upper and lowercases
    if(key == 'E' || key == 'e'){
      pressed[0x6] = true;
    }
    else{
      pressed[0x6] = false;
    }
    //R letter detection in both upper and lowercases
    if(key == 'R' || key == 'r'){
      pressed[0xD] = true;
    }
    else{
      pressed[0xD] = false;
    }
    //A letter detection in both upper and lowercases
    if(key == 'A' || key == 'a'){
      pressed[0x7] = true;
    }
    else{
      pressed[0x7] = false;
    }
    //S letter detection in both upper and lowercases
    if(key == 'S' || key == 's'){
      pressed[0x8] = true;
    }
    else{
      pressed[0x8] = false;
    }
    //D letter detection in both upper and lowercases
    if(key == 'D' || key == 'd'){
      pressed[0x9] = true;
    }
    else{
      pressed[0x9] = false;
    }
    //F letter detection in both upper and lowercases
    if(key == 'F' || key == 'f'){
      pressed[0xE] = true;
    }
    else{
      pressed[0xE] = false;
    }
    //Z letter detection in both upper and lowercases, added Y for a German keyboard layout
    if(key == 'Z' || key == 'z' || key == 'Y' || key == 'y'){
      pressed[0xA] = true;
    }
    else{
      pressed[0xA] = false;
    }
    //X letter detection in both upper and lowercases
    if(key == 'X' || key == 'x'){
      pressed[0x0] = true;
    }
    else{
      pressed[0x0] = false;
    }
    //C letter detection in both upper and lowercases
    if(key == 'C' || key == 'c'){
      pressed[0xB] = true;
    }
    else{
      pressed[0xB] = false;
    }
    //V letter detection in both upper and lowercases
    if(key == 'V' || key == 'v'){
      pressed[0xF] = true;
    }
    else{
      pressed[0xF] = false;
    }
  }
}
