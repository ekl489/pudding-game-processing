// window
int window_width = 640;
int window_height = 480;

// scene
color scene_sky_color = color(50,50,255); // sky
color scene_ground_color = color(50,255,50); // ground
int scene_ground_height = 80;

// player
int player_x = window_width / 2; // initially, center player along x
int player_y = window_height - scene_ground_height; // place player on ground

// setup
void setup() {
  size(640, 480);
  frameRate(60); // refresh rate
}

boolean ball_spawned = false;
Ball myBall;

// game loop
void draw() { 
  
  // reset scenery
  background(scene_sky_color); // draw sky
  fill(scene_ground_color);
  rect(0, window_height - scene_ground_height, window_width, scene_ground_height); // draw grass
  
  // draw player
  fill(color(255,0,255));
  circle(mouseX, player_y, 30); // place player on mouseX and ground
  
  if(!ball_spawned){
     ball_spawned = true;
     myBall = new Ball(0, 100, 2, 10);
  }
  
  myBall.update();
} 

class Ball{
  
  private boolean hasLaunched = false;
  
  // initial physics
  private int initial_x, initial_y;
  private float initial_x_velocity, initial_y_velocity;
  
  // physics
  private int x, y, angle = 0;
  private float xv, yv, velocity = 0;

  private float g = 9.8;
  
  Ball(int ix, int iy, float ixv, float iyv){
    initial_x = ix;
    initial_y = iy;
    initial_x_velocity = ixv;
    initial_y_velocity = iyv;
  }
  
  public void update(){
    
    // -- check if ball has been launched --
    if(!hasLaunched){
      launch();
      hasLaunched = true;
    }
    
    // -- draw --
    fill(color(255,0,0));
    circle(x, y, 20);
    
    // -- bounce physics --
    angle = int(atan2(yv,xv));
    if(y >= window_height - scene_ground_height - 30){ // --> ball is in contact with ground
      
      
      // angle of incidence = angle of reflection
      angle = angle * -1; 
      
      // we use trigonometry to calculate new vertical velocity
      // we must calculate the combined velocity
      // we shall assume horizontal velocity is preserved, i.e. no friction is applied
      // therfore: xv = xv
      
      // calculate velocity:
      // cos(theta) = xv/v
      velocity = xv * cos(angle);
      
      // calculate new vertical velocity
      // sin(theta) = yv/v
      yv = velocity * sin(angle);
    }
    
    // -- projectile/gravity physics --
    
    // check if the ball is above the ground
    if(y < window_height - scene_ground_height - 25){
      // 60 frames per second, therefore 9.8 m deducted every 60 frames
      // we assume 1 metre = 30 pixels, therefore: game g = (g * 30 pixels)
      yv = yv - (g * 30) / 60;
      
    }
    
    
    
    // -- apply velocity --
    x = x + int(xv);
    
    // check if the ball is above the ground
    if(y < window_height - scene_ground_height - 25){
      y = y - int(yv); // this must be negative because it is relative to top left corner of the screen. i.e. vertically flipped
    }
  }
  
  private void launch(){
    
    x = initial_x;
    y = initial_y;
    
    xv = initial_x_velocity;
    yv = initial_y_velocity;
    
    fill(color(255,0,0));
    circle(x, y, 40);
  }
}
