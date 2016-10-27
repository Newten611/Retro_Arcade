int currentScreen=0; // 0=Title 1=Menu 2=Game
int gameMap=0; // 0=Unselected 1=Pong 2=Asteroids 3=Snake 4=Tank Destroyer
int gameState=0; // 0=Game not running 1=Starting sequence 2=Game running 3=Ending Sequence
int textFade=255;
int textFadeToggle=5;
PImage GameOverScreen;
PImage tankBackground;
PImage snakeBackground;

Button menuButton1;
Button menuButton2;
Button menuButton3;
Button menuButton4;
PixelObjectLoader myPixelObjectLoader;
Bullets bullet1;
ExplosionPoint[] explosionPoints;
Rock[] rock1;
EnemyTank[] myEnemyTank;
Timer myTimer;

void setup() {
  fullScreen(P3D);
  //frameRate(90);
  menuButton1=new Button(color(#6792A2), -200, -200, 150, 150, 1); // Takes you to Pong
  menuButton2=new Button(color(#6792A2), -200, 200, 150, 150, 2); // Takes you to Asteroid
  menuButton3=new Button(color(#6792A2), 200, -200, 150, 150, 3); // Takes you to Snake
  menuButton4=new Button(color(#6792A2), 200, 200, 150, 150, 4); // Takes you to Tank Destroyer
  myPixelObjectLoader=new PixelObjectLoader(); // Space Invader in the title screen.
  myTimer=new Timer(10000);
  GameOverScreen = loadImage("https://cloud.githubusercontent.com/assets/14901273/11832564/3395b590-a37f-11e5-81fc-9aa4395b8177.png");
  tankBackground = loadImage("https://cloud.githubusercontent.com/assets/14901273/11832592/72124af4-a37f-11e5-91d8-fe244fbcd2a4.png");
  snakeBackground = loadImage("https://cloud.githubusercontent.com/assets/14901273/11832579/61659954-a37f-11e5-8426-2f8c14334a97.png");

  bullet1=new Bullets();
  explosionPoints = new ExplosionPoint[40];
  for (int i = 0; i < explosionPoints.length; i=i+1) {
    explosionPoints[i] = new ExplosionPoint();
  }

  rock1=new Rock[10];
  for (int j = 0; j < rock1.length; j=j+1) {
    rock1[j] = new Rock();
  }
  
  myEnemyTank=new EnemyTank[10];
  for (int k = 0; k < myEnemyTank.length; k=k+1) {
    myEnemyTank[k] = new EnemyTank();
  }
}

void draw() {
  background(0);
  lights();
  //debugging();
  if (currentScreen==0) {
    titleScreen();
  }
  if (currentScreen==1) {
    menuScreen();
  }
  if (currentScreen==2) {
    gameScreen();
  }
  if(gameState!=2){
  myTimer.timerStart();
  }
}

void debugging() { // Displays some important information.
  fill(0, 200, 0);
  text(currentScreen, 100, 50);
  text(gameMap, 100, 100);
  text(gameState, 100, 150);
  text(asteroidScore, 100, 200);
}

void titleScreen() {
  borderBox1();
  fill(0, 200, 0);
  stroke(0);
  strokeWeight(3);
  textSize(60);
  textAlign(CENTER);
  myPixelObjectLoader.display();
  myPixelObjectLoader.updatePos();
  text("Retro", displayWidth/2, displayHeight/2-175);
  text("Arcade", displayWidth/2, displayHeight/2+130);
  textSize(30);
  textFade();
  fill(0, 200, 0, textFade);
  text("Press any key to start.", displayWidth/2, displayHeight/2+200);
  if (mousePressed==true) {
    currentScreen=1;
  }
  if (keyPressed==true) {
    currentScreen=1;
  }
}

void menuScreen() {
  borderBox1();
  menuButton1.displayGameMapButton();
  menuButton2.displayGameMapButton();
  menuButton3.displayGameMapButton();
  menuButton4.displayGameMapButton();
  fill(0, 200, 0);
  stroke(0);
  strokeWeight(2);
  textSize(40);
  textAlign(CENTER);
  text("Choose a Game.", displayWidth/2, displayHeight/2);
  if (gameMap!=0) {
    textSize(30);
    text("Press Enter to Start", displayWidth/2, displayHeight/2+50);
  }
  if ((gameMap!=0) && (keyPressed==true) && ((key==ENTER) ||(key==RETURN))) {
    currentScreen=2;
    gameState=1;
  }
}

void gameScreen() {
  borderBox1();
  if (gameMap==1) {
    pongController();
  }
  if (gameMap==2) {
    asteroidsController();
  }
  if (gameMap==3) {
    snakeController();
  }
  if (gameMap==4) {
    tankDestroyerController();
  }
}

void textFade() { // This just makes some text fade in and out.
  if ((textFade==255) || (textFade==0)) {
    textFadeToggle=textFadeToggle*-1;
  }
  textFade=textFade+textFadeToggle;
}

void borderBox1() {  // This is just a decorative box around the outside.
  shapeMode(CENTER);
  stroke(0, 200, 0);
  fill(0, 100, 0);
  strokeWeight(2);
  pushMatrix();
  translate(displayWidth/2-600, displayHeight/2, 0);
  box(50, 700, 50);
  box(40, 700, 50);
  box(30, 700, 50);
  translate(1200, 0, 0);
  box(50, 700, 50);
  box(40, 700, 50);
  box(30, 700, 50);
  popMatrix();

  pushMatrix();
  translate(displayWidth/2, displayHeight/2-375, 0);
  box(1250, 50, 50);
  box(1250, 40, 50);
  box(1250, 30, 50);
  translate(0, 750, 0);
  box(1250, 50, 50);
  box(1250, 40, 50);
  box(1250, 30, 50);
  popMatrix();
}

float asteroidsShipAngle=0;
int asteroidNumber=1;
int asteroidScore=0;
float randomAsteroidAngle=0;
int asteroidLives=3;

void asteroidsController() { // This runs the Asteroids game.
  if (gameState==1) { // Runs if the game is in the intro sequence and has not started yet.
    gameStartTimer();
    textAlign(CENTER);
    textSize(40);
    fill(0, 200, 0);
    text("Score:", 350, 175);
    text(asteroidScore, 450, 175);
    text("Lives:", 350, 225);
    text(asteroidLives, 450, 225);
    ringOfConcealment();
    asteroidShipPoint();
    bullet1.display();
    enemyTankNumber=1;
  }

  if (gameState==2) { //This is the main body of the game.
    textAlign(CENTER);
    textSize(40);
    fill(0, 200, 0);
    text("Score:", 350, 175);
    text(asteroidScore, 450, 175);
    text("Lives:", 350, 225);
    text(asteroidLives, 450, 225);
    ringOfConcealment();
    asteroidShipPoint();
    for (int j = 0; j < asteroidNumber; j=j+1) {
      rock1[j].update();
      rock1[j].display();
    }
    if (myTimer.isFinished()) {
      myTimer.timerStart();
      if (asteroidNumber<=9) {
        asteroidNumber=asteroidNumber+1;
      }
    }

    bullet1.updatePos();
    bullet1.display();
    if (mousePressed==true) {
      bulletVisable=true;
      bullet1.targetPosX=mouseX;
      bullet1.targetPosY=mouseY;
      bullet1.bulletVersion=1;
      bullet1.bulletReturn();
    }

    if (asteroidLives==0) {
      gameState=3;
    }
  }

  if (gameState==3) { // This is the game over screen.
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(70);
    textAlign(CENTER);
    text("Game Over", displayWidth/2, displayHeight/2);
    textSize(50);
    text("Score:", displayWidth/2-35, displayHeight/2+100);
    textAlign(LEFT);
    text(asteroidScore, displayWidth/2+55, displayHeight/2+100);
    image(GameOverScreen, width/2-400, height/2-55, 800, 80);

    textFade();
    fill(0, 200, 0, textFade);
    textAlign(CENTER);
    text("Press any key to return to Menu.", displayWidth/2, displayHeight/2+200);
    if (mousePressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
    }
    if (keyPressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
    }
  }
}



void asteroidShipPoint() {
  if (mouseX - width/2!=0) {
    if (mouseY>=height/2) {
      asteroidsShipAngle=degrees(acos((mouseX-width/2) / dist(mouseX, mouseY, width/2, height/2)));
    } else {
      asteroidsShipAngle=0-degrees(acos((mouseX-width/2) / dist(mouseX, mouseY, width/2, height/2)));
    }
  }
  pushMatrix();
  translate(width/2, height/2);
  rotateZ(radians(asteroidsShipAngle));
  sphereDetail(1);
  sphere(25);
  translate(10, 0, 0);
  sphere(20);
  translate(-20, 6, 0);
  sphere(7);
  translate(0, -12, 0);
  sphere(7);

  popMatrix();
}

void ringOfConcealment() {
  fill(0, 100, 0);
  stroke(0, 200, 0);
  pushMatrix();
  translate(width/2, height/2);
  for (int i=0; i<60; i=i+1) {
    rotateZ(radians(360/60));
    pushMatrix();
    translate(350, 0, 0);
    box(60, 60, 120);
    popMatrix();
  }
  popMatrix();
}



int startTimerValue=60;
int startTimerState=3;

void gameStartTimer() {
  if (startTimerValue==0) {
    startTimerState=startTimerState-1;
    startTimerValue=60;
    if (startTimerState==0) {
      gameState=2;
      for (int j = 0; j < asteroidNumber; j=j+1) {
      rock1[j].newRock();
    }
      startTimerValue=60;
      startTimerState=3;
    }
  }
  startTimerValue=startTimerValue-1;
  ellipseMode(CENTER);
  fill(0, 100, 0);
  stroke(0, 200, 0);
  strokeWeight(2);
  textAlign(CENTER);
  textSize(40);
  if (gameState==1) {  

    if (gameMap==1) {
      pushMatrix();
      translate(0, 0, -70);
      if (startTimerState==3) {
        arc(width/2, height/2, 300, 300, radians(-90), radians(270), PIE);
        translate(0, 0, 10);
        arc(width/2, height/2, 250, 250, radians(-90), radians(270), PIE);
        translate(0, 0, 10);
        arc(width/2, height/2, 200, 200, radians(-90), radians(-90+startTimerValue*6), PIE);
        fill(0, 100, 0);
      }


      if (startTimerState==2) {
        arc(width/2, height/2, 300, 300, radians(-90), radians(270), PIE);
        translate(0, 0, 10);
        arc(width/2, height/2, 250, 250, radians(-90), radians(-90+startTimerValue*6), PIE);
        fill(0, 100, 0);
      }


      if (startTimerState==1) {
        arc(width/2, height/2, 300, 300, radians(-90), radians(-90+startTimerValue*6), PIE);
        fill(0, 100, 0);
      }
      popMatrix();
    }

    if (gameMap==2) {
      pushMatrix();
      translate(width/2,height/2);
      sphereDetail(15);
      if (startTimerState==3) {
        rotateZ(radians(6*startTimerValue));
        sphere(120+startTimerValue);
      }


      if (startTimerState==2) {
        rotateZ(radians(-6*startTimerValue));
        sphere(60+startTimerValue);
      }


      if (startTimerState==1) {
        rotateZ(radians(6*startTimerValue));
        sphere(startTimerValue);
      }
      popMatrix();
    }

    if (gameMap==3) {
      pushMatrix();
      popMatrix();
    }

    if (gameMap==4) {
      pushMatrix();
      popMatrix();
    }
  }
}

float ball1PosX=width/2;
float ball1PosY=height/2;
float ball1Angle=45;
float ball1Speed=10;
float ball1Size=25;
float paddleSize=200;
float paddle1PosY;
float paddle2PosY;
float yBoundaries=350;
float xBoundaries=500;
int pongScore=0;
float ballPosXWin1=0;
float ballPosYWin1=0;
float ballPosXWin2=0;
float ballPosYWin2=0;
float ballPosXWin3=0;
float ballPosYWin3=0;

void pongController() {

  textAlign(CENTER);
  textSize(40);
  fill(0, 200, 0);

  ballPosXWin3=ballPosXWin2;        // This section is the win conditional. There is a rare bug where the ball gets stuck on the enemy paddle, and this section checks for it and tells the player they won if it happens.
  ballPosYWin3=ballPosYWin2;
  ballPosXWin2=ballPosXWin1;
  ballPosYWin2=ballPosYWin1;
  ballPosXWin1=ball1PosX;
  ballPosYWin1=ball1PosY;
  if (gameState==2) {
    if ((abs(ballPosXWin3-ballPosXWin1)<5)&&(abs(ballPosYWin3-ballPosYWin1)<5)) {
      gameState=4;
    }
  }


  if (gameState==1) {
    gameStartTimer();
    paddle1();
    ball1PosX=width/2;
    ball1PosY=height/2;
    ball1Speed=10;
    pongScore=0;
    ball1Angle=random(-45, 45);
    ball1();
    paddle2();
  }


  if (gameState==2) {
    fill(0, 100, 0);
    stroke(0, 200, 0);
    paddle1();
    ball1Move();
    ball1();
    paddle2();
    text("Score:", 350, 175);
    text(pongScore, 450, 175);
  }


  if (gameState==3) {
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(70);
    textAlign(CENTER);
    text("Game Over", displayWidth/2, displayHeight/2);
    textSize(50);
    text("Score:", displayWidth/2-35, displayHeight/2+100);
    textAlign(LEFT);
    text(pongScore, displayWidth/2+55, displayHeight/2+100);
    image(GameOverScreen, width/2-400, height/2-55, 800, 80);

    textFade();
    fill(0, 200, 0, textFade);
    textAlign(CENTER);
    text("Press any key to return to Menu.", displayWidth/2, displayHeight/2+200);
    if (mousePressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      pongScore=0;
    }
    if (keyPressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      pongScore=0;
    }
  }
  if (gameState==4) {
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(70);
    textAlign(CENTER);
    text("You Win!!!", displayWidth/2, displayHeight/2);
    textSize(50);
    text("Score:", displayWidth/2-35, displayHeight/2+100);
    textAlign(LEFT);
    text(pongScore, displayWidth/2+55, displayHeight/2+100);

    textFade();
    fill(0, 200, 0, textFade);
    textAlign(CENTER);
    text("Press any key to return to Menu.", displayWidth/2, displayHeight/2+200);
    if (mousePressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      pongScore=0;
    }
    if (keyPressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      pongScore=0;
    }
  }
}


void paddle1() {
  if ((mouseY<=yBoundaries+height/2-paddleSize/2) && (mouseY>=-yBoundaries+height/2+paddleSize/2)) {
    paddle1PosY=mouseY;
  } else {
    if (mouseY>yBoundaries+height/2-paddleSize/2) {
      paddle1PosY=yBoundaries+height/2-paddleSize/2;
    }
    if (mouseY<-yBoundaries+height/2+paddleSize/2) {
      paddle1PosY=-yBoundaries+height/2+paddleSize/2;
    }
  }
  pushMatrix();
  translate(width/2-xBoundaries, paddle1PosY, 0);
  box(20, paddleSize, 20);
  popMatrix();
}

void ball1() {
  noStroke();
  pushMatrix();
  translate(ball1PosX, ball1PosY, 0);
  sphere(ball1Size);
  popMatrix();
}

void ball1Move() {
  if ((ball1PosX+int(ball1Speed*cos(radians(ball1Angle)))<=width/2+xBoundaries-ball1Size)
    &&(ball1PosX+int(ball1Speed*cos(radians(ball1Angle)))>=width/2-xBoundaries+ball1Size) 
    &&(ball1PosY+int(ball1Speed*sin(radians(ball1Angle)))<=height/2+yBoundaries-ball1Size)
    &&(ball1PosY+int(ball1Speed*sin(radians(ball1Angle)))>=height/2-yBoundaries+ball1Size)) {

    ball1PosX=ball1PosX+int(ball1Speed*cos(radians(ball1Angle)));
    ball1PosY=ball1PosY+int(ball1Speed*sin(radians(ball1Angle)));
  } else {
    if (ball1PosX+int(ball1Speed*cos(radians(ball1Angle)))>width/2+xBoundaries-ball1Size) {
      ball1Angle=ball1Angle/abs(ball1Angle)*180-ball1Angle;
    }
    if (ball1PosX+int(ball1Speed*cos(radians(ball1Angle)))<width/2-xBoundaries+ball1Size) {
      if ((ball1PosY<=paddle1PosY+paddleSize/2)&&(ball1PosY>=paddle1PosY-paddleSize/2)) {
        ball1Angle=(0+ball1PosY-paddle1PosY)*0.8;
        pongScore=pongScore+1;
        ball1Speed=ball1Speed+1;
      } else {
        gameState=3;
      }
    }
    if (ball1PosY+int(ball1Speed*sin(radians(ball1Angle)))>height/2+yBoundaries-ball1Size) {
      ball1Angle=-ball1Angle;
    }
    if (ball1PosY+int(ball1Speed*sin(radians(ball1Angle)))<height/2-yBoundaries+ball1Size) {
      ball1Angle=-ball1Angle;
    }
    //ball1Move();
  }
}


void paddle2() {
  stroke(0, 200, 0);
  if ((ball1PosY<=yBoundaries+height/2-paddleSize/2) && (ball1PosY>=height/2-yBoundaries+paddleSize/2)) {
    paddle2PosY=ball1PosY;
  }
  if (ball1PosY>yBoundaries+height/2-paddleSize/2) {
    paddle2PosY=yBoundaries+height/2-paddleSize/2;
  }
  if (ball1PosY<height/2-yBoundaries+paddleSize/2) {
    paddle2PosY=-yBoundaries+height/2+paddleSize/2;
  }
  pushMatrix();
  translate(width/2+xBoundaries, paddle2PosY, 0);
  box(20, paddleSize, 20);
  popMatrix();
}
int snakeScore=0;
void snakeController() {
  textAlign(CENTER);
  textSize(40);
  fill(0, 200, 0);

  fill(0, 200, 0);
  strokeWeight(2);
  textSize(40);
  textAlign(CENTER);
  text("Coming Soon...", displayWidth/2, displayHeight/2+200);
  image(snakeBackground, width/2-500, height/2-75, 1000, 150);
  if(mousePressed==true){
  currentScreen=1;
  gameState=0;
  }
}
int tankScore=0;
float tankPosX=width/2;
float tankPosY=height/2;
float tankWheelRotation=0;
float tankAngle=0;
float tankSpeed=2;
float barrelAngle=0;
int tankLives=5;
int enemyTankNumber=1;
void tankDestroyerController() {

  if (gameState==1) {
    textAlign(CENTER);
    textSize(40);
    fill(0, 200, 0);
    text("Score:", 350, 175);
    text(tankScore, 450, 175);
    gameStartTimer();
    tank();
    bullet1.updatePos();
    bullet1.display();
    tankPosX=width/2;
    tankPosY=height/2;
    enemyTankNumber=1;
    tankScore=0;
    tankLives=5;
    for (int j = 0; j < enemyTankNumber; j=j+1) {
      myEnemyTank[j].newEnemyTank();
    }
    pushMatrix();
    translate(0, 0, -20);
    image(tankBackground, width/2-600, height/2-350, 1200, 700);
    popMatrix();
  }

  if (gameState==2) {
    textAlign(CENTER);
    textSize(40);
    fill(0, 200, 0);
    text("Score:", 350, 175);
    text(tankScore, 450, 175);
    text("Lives:", 350, 225);
    text(tankLives, 450, 225);
    tank();
    for (int j = 0; j < enemyTankNumber; j=j+1) {
      myEnemyTank[j].update();
      myEnemyTank[j].display();
    }
    bullet1.updatePos();
    bullet1.display();

    if (mousePressed==true) {
      bulletVisable=true;
      bullet1.targetPosX=mouseX;
      bullet1.targetPosY=mouseY;
      bullet1.bulletVersion=2;
      bullet1.bulletReturn();
    }

    if (tankLives==0) {
      gameState=3;
    }
    pushMatrix();
    translate(0, 0, -20);
    image(tankBackground, width/2-600, height/2-350, 1200, 700);
    popMatrix();
    if (myTimer.isFinished()) {
      myTimer.timerStart();
      if (enemyTankNumber<=9) {
        enemyTankNumber=enemyTankNumber+1;
      }
    }
  }

  if (gameState==3) { // This is the game over screen.
    fill(0, 200, 0);
    strokeWeight(2);
    textSize(70);
    textAlign(CENTER);
    text("Game Over", displayWidth/2, displayHeight/2);
    textSize(50);
    text("Score:", displayWidth/2-35, displayHeight/2+100);
    textAlign(LEFT);
    text(tankScore, displayWidth/2+55, displayHeight/2+100);
    image(GameOverScreen, width/2-400, height/2-55, 800, 80);

    textFade();
    fill(0, 200, 0, textFade);
    textAlign(CENTER);
    text("Press any key to return to Menu.", displayWidth/2, displayHeight/2+200);
    if (mousePressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
      tankScore=0;
      tankLives=5;
    }
    if (keyPressed==true) {
      currentScreen=1;
      gameMap=0;
      gameState=0;
    }
  }
}

void tank() {
  if (keyPressed==true) {
    if (keyCode==LEFT) {
      tankAngle=tankAngle-2;
    }
    if (keyCode==RIGHT) {
      tankAngle=tankAngle+2;
    }
    if (keyCode==UP) {
      if ((tankPosX+(tankSpeed*cos(radians(tankAngle)))>width/2-545)&&
        (tankPosX+(tankSpeed*cos(radians(tankAngle)))<width/2+545)&&
        (tankPosY+(tankSpeed*sin(radians(tankAngle)))>height/2-320)&&
        (tankPosY+(tankSpeed*sin(radians(tankAngle)))<height/2+320)) {
        tankPosX=tankPosX+(tankSpeed*cos(radians(tankAngle)));
        tankPosY=tankPosY+(tankSpeed*sin(radians(tankAngle)));
      }
    }
    if (keyCode==DOWN) {
      if ((tankPosX-(tankSpeed*cos(radians(tankAngle)))>width/2-545)&&
        (tankPosX-(tankSpeed*cos(radians(tankAngle)))<width/2+545)&&
        (tankPosY-(tankSpeed*sin(radians(tankAngle)))>height/2-320)&&
        (tankPosY-(tankSpeed*sin(radians(tankAngle)))<height/2+320)) {
        tankPosX=tankPosX-(tankSpeed*cos(radians(tankAngle)));
        tankPosY=tankPosY-(tankSpeed*sin(radians(tankAngle)));
      }
    }
  }

  fill(100, 150, 100);
  stroke(100, 100, 100);
  tankWheelRotation=tankWheelRotation+5;
  if (tankWheelRotation>360) {
    tankWheelRotation=tankWheelRotation-360;
  }
  pushMatrix();
  translate(tankPosX, tankPosY);
  rotateZ(radians(tankAngle));
  box(70, 40, 10);
  noStroke();
  translate(0, 0, -5);
  sphere(20);
  stroke(50);
  pushMatrix();
  if (mouseX!=tankPosX) {
    if (mouseY>=tankPosY) {
      //barrelAngle=degrees(atan((mouseY-tankPosY) / (mouseX - tankPosX)));
      barrelAngle=(acos((mouseX-tankPosX) / dist(mouseX, mouseY, tankPosX, tankPosY)));
    } else {
      barrelAngle=0-(acos((mouseX-tankPosX) / dist(mouseX, mouseY, tankPosX, tankPosY)));
      //barrelAngle=180+degrees(atan((mouseY-tankPosY) / (mouseX - tankPosX)));
    }
  }
  rotateZ(barrelAngle-radians(tankAngle));
  translate(10, 0, 15);
  box(10, 5, 5);
  popMatrix();
  translate(-20, 0, 0);
  pushMatrix();
  fill(50);
  stroke(50);
  rotateY(radians(tankWheelRotation));
  box(10, 50, 10);
  box(2, 54, 2);
  popMatrix();
  translate(20, 0, 0);
  pushMatrix();
  rotateY(radians(tankWheelRotation));
  box(10, 50, 10);
  box(2, 54, 2);
  popMatrix();
  box(55, 50, 12);
  translate(20, 0, 0);
  pushMatrix();
  rotateY(radians(tankWheelRotation));
  box(10, 50, 10);
  box(2, 54, 2);
  popMatrix();
  popMatrix();
}