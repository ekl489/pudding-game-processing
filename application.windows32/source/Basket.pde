class Basket{
  public Basket(){
    
  }
  
  public void update(){
    int basketWidth = 55;
    
    // draw basket
    
    stroke(0);
    fill(139,69,19);
    rect(width - 59, height - 80 - 60, basketWidth, 60); // body of basket
    arc(width - 32, height - 81, basketWidth, 10, 0, PI, OPEN); // bottom arc to create cylinder shape
    
    // fill an ellipse at the top with the sky color to create cylinder shape
    noStroke();
    fill(80, 80, 150 + 88);
    ellipse(width - 32, height - 81 - 60, basketWidth, 10);
    
    // create woven basket texture
    stroke(119,49,0);
    for(int y = height - 80 - 56; y < height - 80; y++){
      for(int x = width - 59; x < width - 59 + basketWidth; x++){
        if(x % 3 != 0 && y % 3 != 0) point(x, y); // this creates a gap every 3rd pixel
      }
  }
  }
  
  public boolean isInBasket(int x, int y){ return x > width - 59 && y > height - 80 - 60 && y < height - 80; }
 
}
