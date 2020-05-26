
/*

 java1 for the
 
 How to create a library out of your sketch
 using APDE
 
 A sketch with some subclasses that look useful
 Now separated onyo indibifusl
 

 */


/* for now, commented out, we will have a LOT of
 other problems * /

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
