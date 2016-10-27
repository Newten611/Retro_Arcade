class Rock {
  float rockPosX=width/2+random(-300, 300);
  float rockPosY=height/2+random(-300, 300);
  float rockAngle=random(0, 360);
  float rockDirection=0;
  int rockState=3;
  int rockSpeed=2;
  Rock() {
    float rockPosX=width/2+random(-300, 300);
    float rockPosY=height/2+random(-300, 300);
    float rockAngle=random(0, 360);
    float rockDirection=0;
    int rockState=3;
    int rockSpeed=2;
  }

  void display() {
    if (rockState!=0) {
      pushMatrix();
      translate(rockPosX, rockPosY, 0);
      rotateX(radians(rockAngle));
      rotateZ(radians(rockAngle));
      rotateY(radians(2*rockAngle));
      sphereDetail(6);
      sphere(20*rockState);
      popMatrix();
    }
  }

  void update() {
    rockAngle=rockAngle+1;
    if (rockAngle>360) {
      rockAngle=rockAngle-360;
    }
    if (rockState==0) {
      newRock();
      asteroidScore=asteroidScore+1;
    }
    if (rockPosX!=width/2) {
      if (width/2>=rockPosX) {
        rockDirection=degrees(atan((height/2-rockPosY) / (width/2 - rockPosX)));
      } else {
        rockDirection=degrees(atan((height/2-rockPosY) / (width/2 - rockPosX)))+180;
      }
    }
    rockPosX=rockPosX+int(rockSpeed*cos(radians(rockDirection)));
    rockPosY=rockPosY+int(rockSpeed*sin(radians(rockDirection)));

    if (dist(rockPosX, rockPosY, width/2, height/2)<rockState*20) {
      asteroidLives=asteroidLives-1;
      newRock();
    }
  }

  //x = cx + r * cos(a)
  void newRock() {
    randomAsteroidAngle=random(0, 360);
    rockPosX=width/2+350*cos(randomAsteroidAngle);
    rockPosY=height/2+350*sin(randomAsteroidAngle);
    rockState=3;
  }

  void shrinkRock() {
    if (rockState>0) {
      rockState=rockState-1;
    }
  }
}