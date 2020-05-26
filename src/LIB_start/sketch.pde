
/*

 Starting point for the
 
 How to create a library out of your sketch
 using APDE
 
 A sketch with some subclasses that look useful
 Just as examples for the follwing step
 https://docs.oracle.com/javase/tutorial/deployment/jar/manifestindex.html
 JAR files support a wide range of functionality, including electronic signing, version control, package sealing, and others. What gives a JAR file this versatility? The answer is the JAR file's manifest.
 
 

In build
Th


 */


Indicator frate, frame, imousex;

void setup() {
  fullScreen(P3D);
  // create some indicators
  frate=new SquareIndicator()
    .box(100, 100, width-200, 100)
    .range(1, 90);
  frame=new BlobIndicator("smile.png")
    /// color(200, 223, 123))
    .box(100, 300, width-200, 1000)
    .range(0, 500);
  imousex=new SquareIndicator()
    .box(100, height-400, width-200, 100)
    .range(0, width);
  imousex.value=mouseX=width/3;
}


void draw() {
  background(frameCount%128);
  stroke(0);
  // set new values, draw them
  frate.set(frameRate).draw();
  frame.set(frameCount).draw();
  imousex.set(mouseX).draw();
}

/****** end of main sketch *******/

// here come the classes which will become a librsry
// overstructured, but as an example

interface FloatAdapter<T> {
  float get();
  //void setraw(float f);
  T set(float f);
}

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
    return map(value, mini, maxi, 0, 1.0);
  }

  abstract void draw();
}

// subclasses doing something useful

class SquareIndicator extends Indicator {
  SquareIndicator() {
  }; 
  void draw() {
    float part=u()*w; 
    fill(#ff7777);
    rect(x, y, part, h);
    fill(#00ff77);
    rect(x+part, y, w-part, h);
    // fill(1);
  }
}

class BlobIndicator extends Indicator {
  color blobcolor=color(20, 20, 20, 100);
  PImage pic;
  BlobIndicator() {
  };
  BlobIndicator(color blc) {
    blobcolor=blc;
  };
  BlobIndicator(String picname){
    pic=loadImage(picname);
  }
  void draw() {
    if (pic!=null) {
      image(pic, x, y, w, h);
    } else {
      fill(50);
      rect(x, y, w, h);
    }
    fill(blobcolor);
    rect( x, y, (u()*w)%w, constrain(u()*h, 0.0, h));
  }
}
