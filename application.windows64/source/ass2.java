import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ass2 extends PApplet {

/*
  --- Declare Required Objects & Variables ---
*/
CowboySprite player; // player object
Pudding[] puddings = new Pudding[5]; // array of puddings
Basket basket;
ArrayList<Cloud> clouds; // clouds
Modal gameLostModal; // game lost modal
Modal gameWonModal; // game won modal

// variables
int currency = 0;
final int groundHeight = 80; // ground height
GameState gameState = GameState.Running; // gamestate (Running, Lost, Won)

/*
  --- Setup ---
*/
Pudding p;
public void setup() {
  
  // Setup Processing Settings (Window Size, FPS)
  
  frameRate(30); // fps
  
  // Configure Player Object
  player = new CowboySprite(width / 2, height - groundHeight);

  // Configure each pudding
  for(int i = 0; i < puddings.length; i++){
    
    // configure random projectile angle & height of launch
    puddings[i] = new Pudding(0, // start at left hand side of screen
                              (int)random(10, 150), // start at random height
                              random(1.15f, .2f), 
                              random(0.2f, 1.2f)
                             );
                             
    // set the state of the pudding & release the first pudding
    puddings[i].setState(i == 0 ? PuddingState.Released : PuddingState.Ready);
  }
  
  // Initialise basket
  basket = new Basket();
  
  // Initialise the clouds object
  clouds = new ArrayList<Cloud>();
  
  // Initialise modals
  gameLostModal = new Modal(color(255,10,10), "You lost :(");
  gameWonModal = new Modal(color(10,255,10), "You win! :)");
  
}

/*
  --- Draw ---
*/
public void draw() { 
  
  gameWonModal.update();
  
  background(0); // Clear the screen
  
  drawScenery(); // draw sky & ground
  
  /*
    --- Cloud Generation & Updates ---
    - Clouds are added to the ArrayList "clouds"
    - Each cloud is updated and drawn to the screen
  */
  if((int)random(0,25) == 1){ // Randomly generate new clouds & add them to the ArrayList "clouds" //<>//
    clouds.add(new Cloud());
  }
  for(int c = 0; c < clouds.size(); c++){ // For each cloud, check if it needs to be removed, update coordinates, draw
    if(clouds.get(c).getX() > width + 20 || clouds.get(c).getX() < 20){
      // cloud is out of bounds
      clouds.remove(c);
    }
    else{
      clouds.get(c).update();
    }
  }
  
  /*
    --- Handle the basket ---
    - Draw the basket
  */
  basket.update();
  
  /*
    --- Currency Indicator ---
  */
  drawCurrency(); // draw the currency indicator
  
  /*
    -- Update Player ---
    - This is done outside the gameState check because it should always be drawn
  */
  player.update();
  
  /*
    --- Game State Handler ---
  */
  if(gameState == GameState.Lost){ // The game has been lost, initiate the game lost modal animation
    gameLostModal.update();
  } else if(gameState == GameState.Won){ // The game has been won, initiate the game won modal animation
    gameWonModal.update();
  } else { 
    /*
      The game is still running...
      - Set the player location
      - Handle puddings & their states
      - Update gamestate if required
    */

    // --- Set Player Location ---
    player.setX(mouseX);
    
    // --- Handle Puddings ---
    // track pudding states
    int readyPuddings = 0, 
        releasedPuddings = 0,
        destroyedPuddings = 0,
        finishedPuddings = 0;
        
    // loop through puddings and...
    // (A) update them
    // (B} add their state the the trackers
    // (C) update currency based on the finishedPuddings counter
    for(Pudding p : puddings){  
      
      // update each pudding
      p.update();
      
      // get pudding states trackers
      switch(p.getState()){
         case Ready:
           readyPuddings++;
           break;
         case Released:
         releasedPuddings++;
           break;
         case Destroyed:
           destroyedPuddings++;
           break;
         case Finished:
           finishedPuddings++;
           break;
      }
      
      // update currency
      currency = finishedPuddings * 6;
      
    }
      
    // update game state if required based on trackers
    if(destroyedPuddings > 0) gameState = GameState.Lost;
    else if(finishedPuddings == 5) gameState = GameState.Won;
      
    // check if another pudding needs to be released
    else if(releasedPuddings == 0){
      for(Pudding p : puddings){
         if(p.getState() == PuddingState.Ready){
           p.setState(PuddingState.Released); // release a pudding
           break; // prevent another pudding being released
         }     
      }
    }
  }
}

public void drawScenery(){
  /*
    --- Draw Scenery ---
    - Draw a sky gradient
    - Draw a pixelated ground
  */
  rectMode(CORNER);
  noStroke();
  // Sky gradient
  for(int b = 0; b < height; b += 50){
    fill(80, 80, 150 + b / 4);
    rect(0, b, width, 50);
  }
  // Ground pixelated effect
  fill(114, 111, 50);
  rect(0, height - groundHeight, width, groundHeight);
  for(int b = height - groundHeight ; b < height; b = b + 5){
    for(int a = 0; a < width; a = a + 5){
      fill(132, 226, 113);
      rect(a,b,4 + (b/40 * a/40) * 0.01f,4);
    }
  }
}

public void drawCurrency(){
  String text = "$" + currency;
  
  fill(50,255,50); // dark green
  textSize(35);
  text(text, width - 70, 45); 
}
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
class Cloud{
  
  private int y, x, w, h;
  float xv;
  
  public int getX(){
    return x;
  }
  
  public Cloud(){
    
    // random height
    y = PApplet.parseInt(random(5, 150));
    
    // random side & velocity
    x = width;
    xv = -1 * random(2, 10);
    
    // random shape
    w = PApplet.parseInt(random(50, 100));
    h = PApplet.parseInt(random(20, 45));
  }
  
  public void update(){
    // apply velocity
    x = x + PApplet.parseInt(xv);
    
    // draw
    ellipseMode(CENTER);
    translate(0,0);
    stroke(0);
    strokeWeight(1.5f);
    fill(226, 226, 226);
    ellipse(x,y,w,h);
  }
  
}
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
enum GameState{
  Running,
  Lost,
  Won
};
class Modal {
  
  private int backgroundColor;
  private String title;
  
  public Modal(int backgroundColor, String title){
    this.backgroundColor = backgroundColor;
    this.title = title;
    
    y = - height;
  }
  
  public void update(){
    // draw rectangle
    fill(backgroundColor);
    rectMode(CORNER);
    rect(0, y, width, y + height);
    
    // draw title
    fill(0);
    textSize(60);
    text(title, width/2 - 180, y + height/4); 
    
    // draw score
    textSize(30);
    text("Score: " + currency, width/2 - 80, y + height/2); 
    
    // increment y
    if(y + 10 <= 0) y += 10;
  }
  
  private int y;
}
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

  private final float g = 9.8f * 10; // assume 10 pixels = 1 metre, / 30 fps
  
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
    
    if(isTouchingWall()) velocity.x *= -0.9f; // apply horizontal bounce if touching wall
    
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
    coordinates.x += PApplet.parseInt(velocity.x);
    coordinates.y += PApplet.parseInt(velocity.y);
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
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ass2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
