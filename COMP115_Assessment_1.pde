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

// mouse


// The statements in the setup() function 
// execute once when the program begins
void setup() {
  size(640, 480);  // Size must be the first statement
  frameRate(60);
}

void draw() { 
  
  // reset scenery
  background(scene_sky_color); // draw sky
  fill(scene_ground_color);
  rect(0, window_height - scene_ground_height, window_width, scene_ground_height); // draw grass
  
  // draw player
  fill(color(255,0,0));
  circle(mouseX, player_y, 30); // place player on mouseX and ground
} 
