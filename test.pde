//Wasuphat Rueksawang 6601012610130
//multiplayer
//hint give player an hint to tell how far the card selected from the same card
//timer count down the player turn if time out swap turn to opponent
int mode = 0; // 0 = easy, 1 = medium, 2 = hard    2x5, 4x5, 8x5int cols = 5;
int cols = 5, rows;
int cardWidth = 50;
int cardHeight = 60;
int[][] cardFlipped;
int[][] cardValues;
int firstCardX = -1, firstCardY = -1; // Store the first card's position
int secondCardX = -1, secondCardY = -1; // Store the second card's position
boolean waitingForSecondCard = false;
int delayCounter = 0;
boolean isSelectedMode = false;    //boolean value to determine if player has selectedMode before the game start

void setup() {
  size(1000, 800);
  background(255);
  rect(0, 0, 999, 799);
  smooth();
  frameRate(30);
  strokeWeight(1);
  textAlign(CENTER, CENTER);
  textSize(20);
  initializeMode();
}

void draw() {
}

void mousePressed() {
  if (!isSelectedMode) {  //Ignore clicks if haven't selected mode yet
    if (mouseX >= 0 && mouseX <= 150 && mouseY >= 0 && mouseY <= 240) {
      int pos_y = ceil(mouseY/80);
      mode = pos_y;
      isSelectedMode = true;
      fill(255);
      rect(0, 0, 999, 799);
      switch(mode) {
      case 0:
        rows = 2;
        break;
      case 1:
        rows = 4;
        break;
      case 2:
        rows = 8;
        break;
      }
      cardFlipped = new int[rows][cols];
      cardValues = new int[rows][cols];
      initializeCardValues();
      shuffleCards();
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          print(cardValues[i][j] + " ");
        }
        println();
      }
    }
  }
}

//void 

void initializeMode() {
  int button_h = 80, button_w = 150;
  textSize(20);
  rect(0, 0, button_w, button_h);
  fill(0);
  text("easy", button_w/2, button_h/2);
  fill(255);
  rect(0, button_h, button_w, button_h);
  fill(0);
  text("medium", button_w/2, button_h*1.5);
  fill(255);
  rect(0, button_h*2, button_w, button_h);
  fill(0);
  text("hard", button_w/2, button_h*2.5);
  fill(255);
}

void initializeCardValues() {
  // Create unique pairs for the card values
  int totalPairs = (rows * cols) / 2;
  int[] pairs = new int[totalPairs];

  for (int i = 0; i < totalPairs; i++) {
    pairs[i] = i + 1; // Create pairs 1 to totalPairs
  }

  // Fill cardValues with pairs
  int[] flatValues = new int[rows * cols];
  for (int i = 0; i < totalPairs; i++) {
    flatValues[i * 2] = pairs[i];      // Place first instance of the pair
    flatValues[i * 2 + 1] = pairs[i];  // Place second instance of the pair
  }

  // Fill cardValues 2D array
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      cardValues[i][j] = flatValues[i * cols + j];
    }
  }
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      print(cardValues[i][j] + " ");
    }
    println();
  }
}

void shuffleCards() {
  // Shuffle the card values
  int[] flatValues = new int[rows * cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      flatValues[i * cols + j] = cardValues[i][j];
    }
  }
  // Simple Fisher-Yates shuffle
  for (int i = flatValues.length - 1; i > 0; i--) {
    int j = (int) random(i + 1);
    int temp = flatValues[i];
    flatValues[i] = flatValues[j];
    flatValues[j] = temp;
  }
  // Refill cardValues
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      cardValues[i][j] = flatValues[i * cols + j];
    }
  }
}
