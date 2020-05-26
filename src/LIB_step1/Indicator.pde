





// here come the classes which will become a librsry
// overstructured, but as an example


abstract
  class Indicator implements FloatAdapter<Indicator> { // almost an interface
  float value=0;
  
  Indicator set(float f) {
    setraw(f);
    return this;
  }

  private void setraw(float f) {
    value=f;
  }

  float get() {
    return value;
  }

  int x=10, y=10;
  float w=500, h=100;
  float mini=0, maxi=1;

  Indicator box(float xx, float yy, float ww, float hh) {
    x=int(xx);
    y=int(yy);
    w=ww;
    h=hh;
    return this;
  }

  Indicator range(float mi, float ma) {
    mini=mi;
    maxi=ma;
    return this;
  }

  protected float u() {
    return map(value, 1.0*mini, maxi, 0, 1.0);
  }

  abstract void draw();
}


