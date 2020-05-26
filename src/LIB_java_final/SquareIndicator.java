package my.cool.stuff;

import processing.core.PGraphics;

public class SquareIndicator extends Indicator {
  public SquareIndicator() {
  }; 
  public void draw(PGraphics g) {
    float part=u()*w; 
    g.fill(0xffff7777);
    g.rect(x, y, part, h);
    g.fill(0xff00ff77);
    g.rect(x+part, y, w-part, h);
  }
}

