
class SquareIndicator extends Indicator {
  SquareIndicator() {
  }; 
  public void draw() {
    float part=u()*w; 
    fill(#ff7777);
    rect(x, y, part, h);
    fill(#00ff77);
    rect(x+part, y, w-part, h);
    // fill(1);
  }
}

