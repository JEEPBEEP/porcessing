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
boolean devMode = false; // Developer mode flag
int playerTurn = 0;    //determine the current turn 0 = player 1 ---- 1 = player 2
int playerScore[] = {0, 0};
int counterTimer = 0;
int limitTime = 20;
String positionX = "";
String positionY = "";
int previousTime = 0;
int currentTime = 0;
int countdownTime = 20;

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
  if (isSelectedMode) {
    background(255);
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int x = j * (cardWidth + 10);
        int y = i * (cardHeight + 10);

        if (cardFlipped[i][j] == 0) {
          flipCard(x, y);
        } else if (cardFlipped[i][j] == 1) {
          memoryGame(x, y, cardValues[i][j]);
        }
        if (devMode) {      //dev mode
          if (cardFlipped[i][j] != 2) {
            fill(0); // Set text color to black
            text(cardValues[i][j], x + cardWidth - 15, y + cardHeight - 15); // Bottom right corner
          }
        }
      }
    }

    // Handle delay for mismatched cards
    if (waitingForSecondCard) {
      delayCounter++;
      if (delayCounter > 30) { // Show the cards for a short duration
        cardFlipped[firstCardY][firstCardX] = 0; // Flip back first card
        cardFlipped[secondCardY][secondCardX] = 0; // Flip back second card
        waitingForSecondCard = false; // Reset
        firstCardX = -1;
        firstCardY = -1;
        secondCardX = -1;
        secondCardY = -1;
        delayCounter = 0; // Reset delay counter
      }
    }

    // Display scores and current turn
    String temp1 = "Player 1 score : " + str(playerScore[0]);
    String temp2 = "Player 2 score : " + str(playerScore[1]);
    text(temp1, 700, 50);
    text(temp2, 700, 100);

    if (playerTurn == 0) {
      text("Player1's turn", 700, 200);
    } else {
      text("Player2's turn", 700, 200);
    }

    // Display hint if a card is flipped
    if (firstCardX != -1) {
      temp1 = "Hint next card is " + positionX + " of your card and " + positionY + " of your card";
      text(temp1, 700, 250);
    }

    // Update and display the timer
    counterTimer++;
    if (counterTimer >= 60) { // Update every second
      countdownTime--;
      counterTimer = 0; // Reset counter timer
    }

    if (countdownTime <= 0) {
      swapTurn(); // Swap turn if time runs out
    }

    temp1 = "Time left: " + str(countdownTime);
    text(temp1, 700, 150);

    fill(255);
    rect(820, 50, 175, 40);
    fill(0);
    text(devMode ? "Disable Dev Mode" : "Enable Dev Mode", 850 + 60, 70);
  }
}

void mousePressed() {
  // Check if the developer mode button is clicked
  if (mouseX > 850 && mouseX < 970 && mouseY > 50 && mouseY < 90) {
    devMode = !devMode; // Toggle developer mode
  }
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
  } else {
    if (waitingForSecondCard) {
      return;
    }

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int x = j * (cardWidth + 10);
        int y = i * (cardHeight + 10);

        if (mouseX > x && mouseX < x + cardWidth && mouseY > y && mouseY < y + cardHeight) {
          if (cardFlipped[i][j] == 0) {
            cardFlipped[i][j] = 1; // Flip the card

            if (firstCardX == -1) {
              // First card flipped
              firstCardX = j;
              firstCardY = i;
              findHint(cardValues[firstCardY][firstCardX], firstCardY, firstCardX);
            } else {
              // Second card flipped
              secondCardX = j;
              secondCardY = i;
              positionX = "";
              positionY = "";
              waitingForSecondCard = true;
              checkForMatch(); // Check if the cards match
            }
          }
        }
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
  //for (int i = 0; i < rows; i++) {
  //  for (int j = 0; j < cols; j++) {
  //    print(cardValues[i][j] + " ");
  //  }
  //  println();
  //}
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

void removeMatchedCards(int y1, int x1, int y2, int x2) {
  // Set the matched cards as flipped permanently
  cardFlipped[y1][x1] = 2; // Mark as matched
  cardFlipped[y2][x2] = 2; // Mark as matched

  // Reset the card positions for the next turn
  firstCardX = -1;
  firstCardY = -1;
  secondCardX = -1;
  secondCardY = -1;
  waitingForSecondCard = false; // Reset
}

void checkForMatch() {
  // Check if the values of the first and second card match
  if (cardValues[firstCardY][firstCardX] == cardValues[secondCardY][secondCardX]) {
    // Cards match; remove them
    removeMatchedCards(firstCardY, firstCardX, secondCardY, secondCardX);
    playerScore[playerTurn] += 1;
  }
  swapTurn();
}

void memoryGame(int x, int y, int number) {
  line(x, y, x + cardWidth, y);
  line(x, y, x, y + cardHeight);
  line(x + cardWidth, y, x + cardWidth, y + cardHeight);
  line(x, y + cardHeight, x + cardWidth, y + cardHeight);

  fill(0);
  text(number, x + cardWidth / 2, y + cardHeight / 2);
}

void flipCard(int x, int y) {
  fill(150);
  rect(x, y, cardWidth, cardHeight);
}

void findHint(int value, int x1, int y1) {
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      if (i == x1 && j == y1)
        continue;
      else if (cardValues[i][j] == value) {
        if (i < x1)
          positionX = "above";
        else if (i > x1)
          positionX = "below";
        else
          positionX = "in the same line";
        if (j > y1)
          positionY = "right";
        else if (j < y1)
          positionY = "left";
        else
          positionY = "in the same line";
        break;
      }
    }
  }
}

void swapTurn() {
  playerTurn = (playerTurn + 1) % 2;
  previousTime = currentTime; // Update previous time to current for next swap
  countdownTime = limitTime; // Reset countdown time for the next player
  counterTimer = 0; // Reset the counter timer
}
