public class Goal {
  public PVector pos = new PVector(0,0);
  float w = 50, h = 100;
  float postWidth = 5;
  PImage img;
  
  public Goal(PVector pos) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    img = loadImage("goal.png");
  }
  public void update() {
    
  }
  
  public void render() {
    noStroke();
    fill(0, 255, 0);
    image(img, pos.x-w*2, pos.y-h, 192, 192);
  }
}
