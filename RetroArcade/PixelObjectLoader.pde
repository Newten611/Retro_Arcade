int[] alien1={ 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
  1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 
  1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 
  1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 
  0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 
  0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
  0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0};
float pixelAlien1Rotation=0;

class PixelObjectLoader {

  int objectSize;
  float centerPosX;
  float centerPosY;

  PixelObjectLoader() {
    int objectSize=100;
    float centerPosX=400;
    float centerPosY=400;
  }

  void updatePos() {
    //centerPosX=mouseX-(6*25);
    //centerPosY=mouseY-(6*25);
    centerPosX=width/2;
    centerPosY=height/2;
  }

  void display() {
    fill(0, 150, 0);
    stroke(0, 100, 0);
    strokeWeight(0.5);
    pushMatrix();
    translate(centerPosX, centerPosY, 0);
    rotateY(pixelAlien1Rotation);
    pixelAlien1Rotation=pixelAlien1Rotation+0.01;
    if (pixelAlien1Rotation>360) {
      pixelAlien1Rotation=pixelAlien1Rotation-360;
    }
    for (int y=0; y<8; y=y+1) {
      for (int x=0; x<12; x=x+1) {
        pushMatrix();
        if (alien1[x+(y*12)]==1) {
          translate(-(5*25)+x*25, -(5*25)+y*25, 0);
          box(22, 22, 22);
        }
        popMatrix();
      }
    }
    popMatrix();
  }
}