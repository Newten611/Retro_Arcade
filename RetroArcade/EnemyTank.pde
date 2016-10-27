class EnemyTank {
  float enemyTankPosX=random(width/2-320, width/2+320);
  float enemyTankPosY=height/2-350;
  int enemyTankSpeed=1;
  EnemyTank() {
    float enemyTankPosX=random(width/2-320, width/2+320);
    float enemyTankPosY=height/2-350;
    int enemyTankSpeed=1;
  }

  void display() {
    fill(150, 100, 100);
    pushMatrix();
    translate(enemyTankPosX, enemyTankPosY, 0);
    rotateZ(radians(90));
    box(70, 40, 10);
    noStroke();
    translate(0, 0, -5);
    sphere(20);
    box(10, 5, 5);
    translate(-20, 0, 0);
    fill(50);
    stroke(50);
    box(10, 50, 10);
    box(2, 54, 2);
    translate(20, 0, 0);
    box(10, 50, 10);
    box(2, 54, 2);
    box(55, 50, 12);
    translate(20, 0, 0);
    box(10, 50, 10);
    box(2, 54, 2);
    popMatrix();
  }

  void update() {
    enemyTankPosY=enemyTankPosY+enemyTankSpeed;
    if (enemyTankPosY>height/2+350) {
      tankLives=tankLives-1;
      newEnemyTank();
    }
  }
  void newEnemyTank() {
    enemyTankPosX=random(width/2-320, width/2+320);
    enemyTankPosY=height/2-350;
  }
}