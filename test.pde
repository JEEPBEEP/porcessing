//Wasuphat Rueksawang 6601012610130
int mode = 0; // 0 = easy, 1 = medium, 2 = hard    2x5, 4x5, 8x5
boolean isSelectedMode = false;    //boolean value to determine if player has selectedMode before the game start

void setup() {
  size(500, 200);
  background(255);
  initializeMode();
}

void draw() {
}

void mousePressed() {
  if (!isSelectedMode) {  //Ignore clicks if haven't selected mode yet
    if (mouseX >= 0 && mouseX <= 450 && mouseY >= 0 && mouseY <= 80) {
      int pos_x = ceil(mouseX/150);
      mode = pos_x;
      isSelectedMode = true;
    }
  }
}

void initializeMode() {
  int button_h = 80, button_w = 150, gap_x = 20, gap_y = 5;
  textSize(20);
  rect(0, 0, button_w, button_h);
  fill(0);
  text("easy", button_w/2-gap_x, button_h/2+gap_y);
  fill(255);
  rect(button_w, 0, button_w, button_h);
  fill(0);
  text("medium", button_w*1.5-gap_x*1.5, button_h/2+gap_y);
  fill(255);
  rect(button_w*2, 0, button_w, button_h);
  fill(0);
  text("hard", button_w*2.5-gap_x, button_h/2+gap_y);
  fill(255);
}
