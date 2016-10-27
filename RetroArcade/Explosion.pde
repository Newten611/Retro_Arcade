float explosionFadeTimer=0;
class ExplosionPoint {
  float trajectoryX;
  float trajectoryY;
  float trajectoryZ;
  float posX;
  float posY;
  float posZ;
  float pointColor;


  ExplosionPoint() {
    float trajectoryX = random(-3, 3);
    float trajectoryY = random(-3, 3);
    float trajectoryZ = random(0.1, 0.2);
    float posX = 0;
    float posY = 0;
    float posZ = 20;
    float pointColor = 0;
  }

  void display() {
    if (gameState==2) {
      if (explosionFadeTimer>0) {
        if (bullet1.bulletVersion==1) {
          fill(0, pointColor, 0, explosionFadeTimer);
        } else {
          fill(255, pointColor, 0, explosionFadeTimer);
        }
        noStroke();
        pushMatrix();
        translate(posX, posY, 0);
        box(posZ, posZ, posZ);
        popMatrix();
      }
    }
  }

  void newBoom(float bulletPosX, float bulletPosY) {
    posX = bulletPosX;
    posY = bulletPosY;
    posZ = 0;

    trajectoryX = random(-6, 6);
    trajectoryY = random(-6, 6);
    trajectoryZ = random(1, 2);

    pointColor = random(0, 255);
    explosionFadeTimer=255;
  }

  void update() {
    trajectoryX = trajectoryX*0.9;
    trajectoryY = trajectoryY*0.9;
    trajectoryZ = trajectoryZ*0.9;
    posX = posX+trajectoryX;
    posY = posY+trajectoryY;
    posZ = posZ+trajectoryZ;
  }

  void explosionFade() {
    if (  ( (trajectoryX<0.05)|| (trajectoryY<0.05) || (trajectoryZ<0.05)) && (explosionFadeTimer>=5) ) {
      explosionFadeTimer=explosionFadeTimer-5;
    }
  }
}