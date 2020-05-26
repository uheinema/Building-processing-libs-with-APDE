
/*

 java_final for 
 
 How to create a library out of your sketch
 using APDE

 */
 
import my.cool.stuff.*;

Indicator frate, frame, imousex;

void setup() {
  fullScreen(P3D);
  // create some indicators
  frate=new SquareIndicator()
    .box(100, 100, width-200, 100)
    .range(1, 90);
  
  frame=new BlobIndicator(loadImage("smile.png"))
    .box(100, 300, width-200, 1000)
    .range(0, 500);
   
  imousex=new SquareIndicator()
    .box(100, height-400, width-200, 100)
    .range(0, width);
  imousex.set(mouseX=width/3);
}


void draw() {
  background(frameCount%128);
  stroke(0);
  // set new values, draw them
  frate.set(frameRate).draw(g);
  frame.set(frameCount).draw(g);
  imousex.set(mouseX).draw(g);
}

