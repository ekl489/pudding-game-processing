class Modal {
  
  private color backgroundColor;
  private String title;
  
  public Modal(color backgroundColor, String title){
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
