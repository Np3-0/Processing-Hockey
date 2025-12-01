public class Player {
  PVector pos = new PVector(0,0), vel = new PVector(0, 0);
  float r = 50;
  float hitbox = r/2;
  float rotation = 0;
  float accelStrength = 0.6;
  float friction = 0.94;

  public Player(PVector pos){
    this.pos.x = pos.x;
    this.pos.y = pos.y;
  }
    
  public void shoot() {
    float shotStrength = map(shotProgress, 0, 810, 5, 50);
    puck.vel.x = shotStrength * cos(rotation);
    puck.vel.y = shotStrength * sin(rotation);
    isPlayerHittingPuck = false;
  }


  public void update() {
    PVector accel = new PVector(0, 0);

    if (up)    accel.y -= 1;
    if (down)  accel.y += 1;
    if (left)  accel.x -= 1;
    if (right) accel.x += 1;

    if (accel.mag() != 0) {
      accel.normalize();
      accel.mult(accelStrength);
    }

    vel.add(accel);
    vel.mult(friction);

    pos.x += vel.x;
    pos.y += vel.y;
    
     PVector dir = PVector.sub(mousePos, pos);
     rotation = atan2(dir.y, dir.x);
     
  }

  public void render() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    noStroke();
    fill(255, 0, 0);
    circle(0, 0, r);
    popMatrix();
  }
}
