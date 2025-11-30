public class Puck {
  PVector pos = new PVector(0, 0);
  float r = 27.5;
  float hitbox = r/2;
  
  public Puck(PVector pos) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
  }
  
  public void update() {
  if (isPlayerHittingPuck) {
    pos.x = player.pos.x + cos(player.rotation) * player.hitbox;
    pos.y = player.pos.y + sin(player.rotation) * player.hitbox;
  }
}

  
  public void render() {
    noStroke();
    fill(0);
    circle(pos.x, pos.y, r);
  }
}
