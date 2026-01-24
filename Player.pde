public class Player {
  PVector pos = new PVector(0,0), vel = new PVector(0, 0);
  float r = 50;
  float hitbox = r/2;
  float rotation = 0;
  float accelStrength = 1.2;
  color c = color(0, 0, 0);
  float friction = 0.93;
  boolean hasPuck = false, shooting = false, controlled = false;   
  String position = new String("");
  
  //defines a player
  public Player(PVector pos, boolean controlled, String position, color c){
    this.pos.x = pos.x;
    this.pos.y = pos.y;
    this.controlled = controlled;
    this.position = position;
    this.c = c;
  }
  
  //gets the index of the closest player
  public int getClosestEnemyToPuckInd() {
    int best = -1;
    float bestDist = Float.MAX_VALUE;

    for (int i = 0; i < enemies.length; i++) {
      float d = dist(enemies[i].pos.x, enemies[i].pos.y, puck.pos.x, puck.pos.y);
      if (d < bestDist) {
        bestDist = d;
        best = i;
      }
    }
    return best;
  }

  //shooting, passing in the power as an float.
  public void shoot(float shotPower) {
    float shotStrength = map(shotPower, 0, 810, 5, 50);
    puck.vel.x = shotStrength * cos(rotation);
    puck.vel.y = shotStrength * sin(rotation);
    hasPuck = false;
  }
  /**
     * Updates the player's state each frame.
     * For controlled players, applies acceleration based on input keys
     * and updates velocity and position with friction.
     * For uncontrolled players, runs AI movement.
     * Also calculates rotation to face the mouse position (or target)
     *Global Variables: movement (up/down/etc), controlled
   */
  public void update() {
    if (c == color(0,0,255)) {
     // enemyMovement();
      return;
    }
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
    
     PVector dir = PVector.sub(mousePos, new PVector(width/2, height/2));
     rotation = atan2(dir.y, dir.x);
     
  }
  
  // enemy movement script - not working, disabled for submission due to time constraints
  public void enemyMovement() {
    int closestInd = getClosestEnemyToPuckInd();
    boolean chaser = enemies[closestInd] == this;

    float aiAccel = accelStrength * 0.85;

    if (chaser) {
      PVector dir = PVector.sub(puck.pos, pos);
      if (dir.mag() > 10) {
        dir.normalize();
        dir.mult(aiAccel * 1.3);
        vel.add(dir);
      }
    } else {
    HashMap<String, PVector> rel = Positions.dists.get(position);
      if (rel == null) return;

      PVector target = new PVector();
      int count = 0;

      for (Player other : enemies) {
        PVector offset = rel.get(other.position);
        if (other == this || offset == null) continue;
        target.add(PVector.add(other.pos, offset));
        count++;
      } 
      
      if (count > 0) {
        target.div(count);
        PVector dir = PVector.sub(target, pos);
        if (dir.mag() > 8) {
          dir.normalize();
          dir.mult(aiAccel);
          vel.add(dir);
        }
      }
    }

    vel.mult(friction);
    pos.add(vel);
    rotation = atan2(puck.pos.y - pos.y, puck.pos.x - pos.x);
  }

  // ai movement script, mainly follows teammates around
  public void aiMovement() {
    //players move slightly slower
    float aiAccelStrength = accelStrength * 0.9;

    HashMap<String, PVector> rel = Positions.dists.get(this.position);
    if (rel == null) return;

    PVector target = new PVector(0, 0);
    int count = 0;

    for (Player other : players) {
     //gets distance to each other player 
       PVector offset = rel.get(other.position);
       if (other == this || offset == null) continue;
       
       // gets actual distance and adds
       PVector expected = PVector.add(other.pos, offset);
       target.add(expected);
       count++;
    }

    if (count == 0) return;
    target.div(count);

    // gets the actual distance and corrects
    PVector desiredDir = PVector.sub(target, this.pos);
    float distToTarget = desiredDir.mag();

    if (distToTarget > 5) {  
        desiredDir.normalize();
        desiredDir.mult(aiAccelStrength);
        vel.add(desiredDir);
    }

    pos.add(vel);
  }

  //renders players
  public void render() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(rotation);
    if (this.controlled) {
      strokeCap(ROUND);
      stroke(0, 0, 0);
      strokeWeight(5);
    } else {
      noStroke();
    }
    fill(c);
    circle(0, 0, r);
    noStroke();
    popMatrix();
  }
}
