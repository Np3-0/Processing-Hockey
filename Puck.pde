public class Puck {
  PVector pos = new PVector(0, 0), vel = new PVector(0,0);
  float r = 27.5;
  float hitbox = r/2;
  
  public Puck(PVector pos) {
    this.pos.x = pos.x;
    this.pos.y = pos.y;
  }
  
  public void update() {
    if (holder != null && holder.hasPuck) {
      pos.x = holder.pos.x + cos(holder.rotation) * holder.hitbox;
      pos.y = holder.pos.y + sin(holder.rotation) * holder.hitbox;
    } else {
      pos.add(vel);
      vel.mult(0.99);
      if (vel.mag() < 0.01) vel.set(0, 0);
    }
  }
  
  public void render() {
    noStroke();
    fill(0);
    circle(pos.x, pos.y, r);
  }
}
