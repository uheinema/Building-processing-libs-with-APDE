package my.cool.stuff;

import processing.core.*; 

public class BlobIndicator extends Indicator {
  int blobcolor=0x64141414;
  //PApplet.color(20, 20, 20, 100);
  PImage pic;
  public BlobIndicator() {
  };
  public BlobIndicator(int blc) {
    blobcolor=blc;
  };
  public BlobIndicator(PImage _pic){
    pic=_pic;
  }
  public void draw(PGraphics g) {
    if (pic!=null) {
      g.image(pic, x, y, w, h);
    } else {
      g.fill(50);
      g.rect(x, y, w, h);
    }
    g.fill(blobcolor);
    g.rect( x, y, (u()*w)%w, PApplet.constrain(u()*h, 0.0f, h));
  }
}
