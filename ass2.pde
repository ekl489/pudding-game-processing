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
void setup() {
  
  // Setup Processing Settings (Window Size, FPS)
  size(640, 480);
  frameRate(30); // fps
  
  // Configure Player Object
  player = new CowboySprite(width / 2, height - groundHeight);

  // Configure each pudding
  for(int i = 0; i < puddings.length; i++){
    
    // configure random projectile angle & height of launch
    puddings[i] = new Pudding(0, // start at left hand side of screen
                              (int)random(10, 150), // start at random height
                              random(1.15, .2), 
                              random(0.2, 1.2)
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
void draw() { 
  
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

void drawScenery(){
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
      rect(a,b,4 + (b/40 * a/40) * 0.01,4);
    }
  }
}

void drawCurrency(){
  String text = "$" + currency;
  
  fill(50,255,50); // dark green
  textSize(35);
  text(text, width - 70, 45); 
}
