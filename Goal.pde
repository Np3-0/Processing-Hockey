public class Goal {
  public PVector pos = new PVector(0,0);
  float w = 50, h = 100;
  float postWidth = 5;
  PImage img;
  int team;
  
  public Goal(PVector pos, int team) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    this.team = team;
    img = loadImage(team == 0 ? "goal.png" : "goal_reverse.png");
  }

  // renders to screen
  public void render() {
    imageMode(CORNER);
    noStroke();
    fill(0, 255, 0);
    image(img, pos.x-w*2, pos.y-h, 192, 192);
  }
}
