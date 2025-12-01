Player player;
Puck puck;
public PVector mousePos;
//controls
public boolean left = false, right = false, up = false, down = false;
//game states
public boolean isPlayerHittingPuck = false, shooting = false;
float shotProgress = 0;

void setup() {
  size(1080,720);
  translate(width/2, height/2);
  noStroke();
  player = new Player(new PVector(width/2, height/2));
  puck = new Puck(new PVector(width/3, height/3));
  mousePos = new PVector(mouseX, mouseY);
}

void draw(){
  background(220);
  rectMode(CENTER);
  noStroke();
  mousePos = new PVector(mouseX, mouseY);
  player.update();
  puck.update();
  collisionCheck();
  player.render();
  puck.render();
  
  if (isPlayerHittingPuck && shooting) {
    stroke(0);
    fill(255);
    rect(width/2,height-50, width*0.75, 100);
    fill(0,255,0);
    rectMode(CORNER);
    
    rect(135, height-100, shotProgress, 100);
    shotProgress = constrain(shotProgress+15, 1, 810);
  }
  
  if (!shooting) shotProgress = 0;
}

void collisionCheck() {
  float distance = dist(player.pos.x, player.pos.y, puck.pos.x, puck.pos.y);
  isPlayerHittingPuck = distance <= 30;
  
  if (puck.pos.x + puck.hitbox >= width || puck.pos.x - puck.hitbox <= 0) {
    puck.vel.x *= -1;
  } else if (puck.pos.y + puck.hitbox >= height || puck.pos.y - puck.hitbox <= 0) {
    puck.vel.y *= -1;
  }
  
}


void keyPressed(){
  if (key == 'w') {
    up = true;
  } if (key == 's') {
    down = true;
  } if (key == 'a') {
    left = true;
  } if (key == 'd') {
    right = true;
  } if (key == ' ') {
    shooting = true;
  }
}

void keyReleased(){
  if (key == 'w') {
    up = false;
  } if (key == 's') {
    down = false;
  } if (key == 'a') {
    left = false;
  } if (key == 'd') {
    right = false;
  } if (key == ' ') {
    if (isPlayerHittingPuck) player.shoot();
    shooting = false;
    shotProgress = 0;
  }
}
