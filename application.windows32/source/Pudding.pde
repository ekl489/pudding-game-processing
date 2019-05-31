enum PuddingState { 
  Ready, // the pudding hasn't been launched yet
  Released, // the pudding has been launched and is ready to be updated
  Destroyed, // the pudding has touched the ground --> game lost
  Finished // the pudding has landed in the basket
}

class Pudding {
  
  // Physics Variables
  public PVector coordinates;
  private PVector velocity;

  private final float g = 9.8 * 10; // assume 10 pixels = 1 metre, / 30 fps
  
  private PuddingState state;
  
  public Pudding(int ix, int iy, float ixv, float iyv){   
    coordinates = new PVector(ix,iy);
    velocity = new PVector(ixv,iyv);
    
    state = PuddingState.Ready;
  }
  
  public void setState(PuddingState s){ 
      this.state = s; 
  }
  public PuddingState getState() { return this.state; }
  
  public void update(){
    
    // --- Handle State ---
    if(state != PuddingState.Released) return; // there is no need for an update, return.
    if(coordinates.y + 10 > height - groundHeight) state = PuddingState.Destroyed;  // Check if touching ground --> End Game
    
    // REMOVE THIS LINE ONCE BASKET IS IMPLEMENTED
    //if((int)random(0,350) == 0) state = PuddingState.Finished;
    /*
      --- Check if landed in basket ---
    */
    if(basket.isInBasket((int)coordinates.x, (int)coordinates.y)){
      setState(PuddingState.Finished);
      println("YAY!");
    }
      
    
    // -- Draw --
    drawPudding();
    
    //  -- Apply gravity --
    //if(velocity.y > 0) 
    if(coordinates.y < height - 80) velocity.y += g / 30 / 5; // divided by 30 fps, divided by reduction factor 4(to make the game easier)
    else velocity.y = 0;
    
    if(isTouchingWall()) velocity.x *= -0.9; // apply horizontal bounce if touching wall
    
    // -- Limit velocity --
    // this will decrease realism but...
    // it is done to prevent the pudding moving too fast for the player
    if(velocity.y > 15) velocity.y = 15;
    else if(velocity.y < -23) velocity.y = -23;
    if(velocity.x > 25) velocity.x = 25;
    else if(velocity.x < -25) velocity.x = -25;
    
    // -- apply dynamic bounce physics based on player coordinates --
    // a configured rectangular 'hitbocoordinates.x' is used to define the player's coordinates using vertical and horizontal margins
    if(isTouchingPlayer()){
      
      velocity.y -= random(10, 15); // apply random vertical bounce
      
      if(mouseX < coordinates.x) velocity.x += 1; //player is left of the ball
      else velocity.x -= 1; // player is right if the ball   
    }
    
    // -- update coordinates --
    coordinates.x += int(velocity.x);
    coordinates.y += int(velocity.y);
  }
  
  private boolean isTouchingWall(){ 
    return ((coordinates.x <= 20 && velocity.x < 0) || (coordinates.x >= width - 20 && velocity.x > 0)) // touching left or right side walls
           ||(coordinates.x > width - 59 && coordinates.x < width - 51 && coordinates.y > height - 80 - 55); // touching basket side
  }
  private boolean isTouchingPlayer(){ return (coordinates.x > mouseX - 20 && coordinates.x < mouseX + 20) && coordinates.y > height - groundHeight - 80; }
  
  private void drawPudding(){
    // prevent the pudding being drawn below the ground incase of error
    int fixedY = (coordinates.y + 10 > height - groundHeight) ? height - groundHeight - 10 : (int)coordinates.y; 
    
    stroke(0);
    
    // Cream colored circles
    fill(255,221,208);
    circle(coordinates.x + 7, fixedY - 5, 5);
    circle(coordinates.x + 4, fixedY - 2, 7);
    circle(coordinates.x - 7, fixedY - 5, 4);
    circle(coordinates.x - 4, fixedY - 2, 5);
    circle(coordinates.x, fixedY - 5, 15);
    circle(coordinates.x, fixedY, 10);
    circle(coordinates.x - 10, fixedY, 10);
    circle(coordinates.x + 10, fixedY, 8);
    
    // Brown Bowl
    fill(100,30,30);
    ellipse(coordinates.x, fixedY + 8, 30, 10);
    noStroke(); // reset stroke
  }
}
