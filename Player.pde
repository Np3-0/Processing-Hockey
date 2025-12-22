public class Player {
  PVector pos = new PVector(0,0), vel = new PVector(0, 0);
  float r = 50;
  float hitbox = r/2;
  float rotation = 0;
  float accelStrength = 0.75;
  float friction = 0.93;
  boolean hasPuck = false, shooting = false, controlled = false;   
  String position = new String("");
  

  public Player(PVector pos, boolean controlled, String position){
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    this.controlled = controlled;
    this.position = position;
  }
  
  public int getIndFromPosition(String position) {
    for (int i = 0; i < players.length; i++) {
      if (players[i].position == position) {
        return i;
      }
    } 
    return 99;
  }
    
  public void shoot() {
    float shotStrength = map(shotProgress, 0, 810, 5, 50);
    puck.vel.x = shotStrength * cos(rotation);
    puck.vel.y = shotStrength * sin(rotation);
    hasPuck = false;
  }

  public void update() {
    PVector accel = new PVector(0, 0);

    if (controlled && up)    accel.y -= 1;
    if (controlled && down)  accel.y += 1;
    if (controlled && left)  accel.x -= 1;
    if (controlled && right) accel.x += 1;

    if (accel.mag() != 0) {
      accel.normalize();
      accel.mult(accelStrength);
    }

    vel.add(accel);
    vel.mult(friction);

    pos.x += vel.x;
    pos.y += vel.y;
    
    if (!controlled) aiMovement();
    
     PVector dir = PVector.sub(mousePos, pos);
     rotation = atan2(dir.y, dir.x);
     
  }
  
public void aiMovement() {
    float aiAccelStrength = accelStrength * 0.9;

    HashMap<String, PVector> rel = Positions.dists.get(this.position);
    if (rel == null) return;

    PVector target = new PVector(0, 0);
    int count = 0;

    for (Player other : players) {
        if (other == this) continue;

        PVector offset = rel.get(other.position);
        if (offset == null) continue;

        PVector expected = PVector.add(other.pos, offset);
        target.add(expected);
        count++;
    }

    if (count == 0) return;
    target.div(count);

    PVector desiredDir = PVector.sub(target, this.pos);
    float distToTarget = desiredDir.mag();

    if (distToTarget > 5) {  
        desiredDir.normalize();
        desiredDir.mult(aiAccelStrength);
        vel.add(desiredDir);
    }

    vel.mult(friction);
    pos.add(vel);
}


  public void render() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    if (this.controlled) {
      stroke(0, 0, 0);
      strokeWeight(5);
    } else {
      noStroke();
    }
    fill(255, 0, 0);
    circle(0, 0, r);
    noStroke();
    popMatrix();
  }
}
