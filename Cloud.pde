class Cloud{
  
  private int y, x, w, h;
  float xv;
  
  public int getX(){
    return x;
  }
  
  public Cloud(){
    
    // random height
    y = int(random(5, 150));
    
    // random side & velocity
    x = width;
    xv = -1 * random(2, 10);
    
    // random shape
    w = int(random(50, 100));
    h = int(random(20, 45));
  }
  
  public void update(){
    // apply velocity
    x = x + int(xv);
    
    // draw
    ellipseMode(CENTER);
    translate(0,0);
    stroke(0);
    strokeWeight(1.5);
    fill(226, 226, 226);
    ellipse(x,y,w,h);
  }
  
}
