

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
