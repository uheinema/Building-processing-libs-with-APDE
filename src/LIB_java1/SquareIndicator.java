package my.cool.stuff;

class SquareIndicator extends Indicator {
  SquareIndicator() {
  }; 
  public void draw() {
    float part=u()*w; 
    fill(0xffff7777);
    rect(x, y, part, h);
    fill(0xff00ff77);
    rect(x+part, y, w-part, h);
    // fill(1);
  }
}

