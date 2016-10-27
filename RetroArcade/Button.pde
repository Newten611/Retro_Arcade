class Button {
  color buttonColor;
  float buttonX;
  float buttonY;
  float buttonWidth;
  float buttonHeight;
  int buttonValue;

  Button(color _buttonColor, float _buttonX, float _buttonY, float _buttonWidth, float _buttonHeight, int _buttonValue) {
    buttonColor=_buttonColor;
    buttonX=_buttonX;
    buttonY=_buttonY;
    buttonWidth=_buttonWidth;
    buttonHeight=_buttonHeight;
    buttonValue=_buttonValue;
  }

  void displayGameMapButton() {
    pushMatrix();
    shapeMode(CENTER);
    if (gameMap==buttonValue) {
      fill(0, 170, 0);
    } else {
      fill(0, 100, 0);
    }
    //stroke(0);
    //strokeWeight(5);
    if (((displayWidth/2+buttonX-buttonWidth/2 < mouseX) && (mouseX< displayWidth/2+buttonX+buttonWidth/2) && (displayHeight/2+buttonY-buttonHeight/2 < mouseY)&&(mouseY < displayHeight/2+buttonY+buttonHeight/2)) || (gameMap==buttonValue)) {
      translate(displayWidth/2+buttonX, displayHeight/2+buttonY, -20);
    } else {
      translate(displayWidth/2+buttonX, displayHeight/2+buttonY, 0);
    }
    box(buttonWidth, buttonHeight, 50);
    translate(0,0,30);
    box(buttonWidth-25, buttonHeight-25, 10);
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(30);
    textAlign(CENTER);

    if (buttonValue==1) {
      text("Pong", buttonX*0.85, 0, 10);
    }
    if (buttonValue==2) {
      text("Asteroids", buttonX*0.85, 0, 10);
    }
    if (buttonValue==3) {
      text("Snake", buttonX*0.85, 0, 10);
    }
    if (buttonValue==4) {
      text("Tank", buttonX*0.85, 0, 10);
      text("Destroyer", buttonX*0.85, 40, 10);
    }

    popMatrix();
    if (((displayWidth/2+buttonX-buttonWidth/2 < mouseX) && (mouseX< displayWidth/2+buttonX+buttonWidth/2) && (displayHeight/2+buttonY-buttonHeight/2 < mouseY)&&(mouseY < displayHeight/2+buttonY+buttonHeight/2)) && (mousePressed==true)) {
      gameMap=buttonValue;
    }
  }
}