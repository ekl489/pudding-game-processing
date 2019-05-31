class CowboySprite{
  
  private int 
  x, 
  y, 
  prev_x;
  
  private boolean isRunning; // decides if the legs should shake i.e. play the 'running' animation
  
  CowboySprite(int X, int Y){
    x = X;
    y = Y;
  }
  
  public void setX(int X){
    x = X;
  }
  
  public int getX(){
   return x; 
  }
  
  public void update(){
    
    // check isRunning
    isRunning = (prev_x != x);
    
    // setup stroke
    noStroke();
    
    // head
    fill(255,224,189);
    ellipse(x, y - 60, 15, 30);
    
    // mouth
    noFill();
    stroke(0);
    arc(x, y - 52, 6, 5, radians(0), radians(180));
    noStroke();
    
    // right eye
    stroke(0);
    fill(255);
    circle(x + 3, y - 59, 4);
    noStroke();
    
    // left eye
    stroke(0);
    fill(255);
    circle(x - 3, y - 59, 4);
    noStroke();
    
    // hat
    rectMode(CENTER);
    fill(137, 58, 37);
    rect(x, y - 65, 40, 5); // hat base
    fill(163, 69, 44);
    rect(x, y - 70, 15, 10); // hat top
    
    // right leg
    pushMatrix();
    fill(0);
    translate(x + 6, y - 10); 
    rotate(radians(isRunning ? random(-60,60)/2 : -10));
    rect(0, 0, 6, 20, 7);
    popMatrix();
    
    //left leg
    pushMatrix();
    fill(0);
    translate(x - 6, y - 10); 
    rotate(radians(isRunning ? random(-60,60)/2 : 10));
    rect(0, 0, 6, 20, 7);
    popMatrix();

    // right arm
    pushMatrix();
    fill(196, 193, 192);
    translate(x + 12, y - 30); 
    rotate(radians(isRunning ? random(150, 180) : -15));
    rect(0, 0, 6, 20, 7);
    popMatrix();
    
    // left arm
    pushMatrix();
    fill(196, 193, 192);
    translate(x - 12, y - 30); 
    rotate(radians(isRunning ? random(0, 30) : 15));
    rect(0, 0, 6, 20, 7);
    popMatrix();

    // body
    fill(221, 219, 215);
    rect(x,y - 30, 20, 25, 7); // torso
    
    // jacket - left
    fill(150, 61, 3);
    pushMatrix();
    translate(x - 5, y - 30);
    rotate(radians(5));
    rect(0, 0, 5, 22, 2);
    popMatrix();

    // jacket - right
    fill(150, 61, 3);
    pushMatrix();
    translate(x + 5, y - 30);
    rotate(radians(-5));
    rect(0, 0, 5, 22, 2);
    popMatrix();
   
    translate(0, 0);
   
    // set previous x
    prev_x = x;

  }
}
