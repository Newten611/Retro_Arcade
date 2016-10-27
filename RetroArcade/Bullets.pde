boolean bulletVisable=true;
class Bullets {

  float bulletSize;
  float bulletPosX=-500;
  float bulletPosY=-500;
  float bulletAngle;
  float bulletSpeed;
  float targetPosX;
  float targetPosY;
  int bulletVersion;

  Bullets() {
    float bulletSize=20;
    float bulletPosX=-500;
    float bulletPosY=-500;
    float bulletAngle=45;
    float bulletSpeed=10;
    float targetPosX;
    float targetPosY;
    int bulletVersion=1;
  }

  void display() {
    if (bulletVisable==true) {

      if (bulletVersion==1) {
        fill(0, 100, 0);
        noStroke();
        pushMatrix();
        translate(bulletPosX, bulletPosY, 0);
        rotateZ(radians(bulletAngle));
        sphere(bulletSize*0.5);
        popMatrix();
      }

      if (bulletVersion==2) {
        fill(100, 100, 100);
        noStroke();
        pushMatrix();
        translate(bulletPosX, bulletPosY, 0);
        rotateZ(radians(bulletAngle));
        for (int a=0; a<10; a=a+1) {
          rotateX(TAU/10);
          box(bulletSize*1.5, bulletSize, bulletSize);
        }
        translate(bulletSize*0.8, 0, 0);
        sphere(bulletSize*0.7);
        popMatrix();
      }
    }
  }

  void updatePos() {

    for (int i = 0; i < explosionPoints.length; i=i+1) {
      explosionPoints[i].update();
      explosionPoints[i].display();
    }
    explosionPoints[round(random(0, explosionPoints.length-1))].explosionFade();
    bullet1.detectCollision();
    if (bulletVisable==true) {
      if (bullet1.detectCollision()==254) {
        bulletPosX=bulletPosX+((targetPosX-bulletPosX)/10);
        bulletPosY=bulletPosY+((targetPosY-bulletPosY)/10);
      } else {
        if (bullet1.detectCollision()==255) {
          for (int i = 0; i < explosionPoints.length; i=i+1) {
            explosionPoints[i].newBoom(bulletPosX, bulletPosY);
          }
          bulletVisable=false;
        } else {
          for (int i = 0; i < explosionPoints.length; i=i+1) {
            explosionPoints[i].newBoom(bulletPosX, bulletPosY);
          }
          bulletVisable=false;
          if(gameMap==2){
          rock1[bullet1.detectCollision()].shrinkRock();
          }
          if(gameMap==4){
          myEnemyTank[bullet1.detectCollision()].newEnemyTank();
          tankScore=tankScore+1;
          }
        }
      }
    }

    if (mouseX!=width/2) {
      if (mouseX>=bulletPosX) {
        bulletAngle=degrees(atan((targetPosY-bulletPosY) / (targetPosX - bulletPosX)));
      } else {
        bulletAngle=degrees(atan((targetPosY-bulletPosY) / (targetPosX - bulletPosX)))+180;
      }
      bulletSize=20;
    }
  }

  int detectCollision() {
    if (gameMap==2) {
      for (int i = 0; i < asteroidNumber; i=i+1) {
        if ((dist(bulletPosX, bulletPosY, rock1[i].rockPosX, rock1[i].rockPosY)<=bulletSize+rock1[i].rockState*20)) {
          return i;
        }
      }
    }
    
    if (gameMap==4){
      for (int i = 0; i < enemyTankNumber; i=i+1) {
        if ((dist(bulletPosX, bulletPosY, myEnemyTank[i].enemyTankPosX, myEnemyTank[i].enemyTankPosY)<=bulletSize+30)) {
          return i;
        }
      }
    }

    if (dist(bulletPosX, bulletPosY, targetPosX, targetPosY)<=bulletSize) {
      return 255;
    }

    return 254;
  }

  void bulletReturn() {
    if (bullet1.bulletVersion==1) {
      bulletPosX=width/2;
      bulletPosY=height/2;
    }

    if (bullet1.bulletVersion==2) {
      bulletPosX=tankPosX;
      bulletPosY=tankPosY;
    }
  }
}