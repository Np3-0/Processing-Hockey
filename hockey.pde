PImage img;
Player player;
Puck puck;
public PVector mousePos;
//controls
public boolean left = false, right = false, up = false, down = false;
//game states
public boolean isPlayerHittingPuck = false, shooting = false;

void setup() {
  size(1080,720);
  translate(width/2, height/2);
  img = loadImage("rink_test.png");
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
  }
}

void collisionCheck() {
  float distance = dist(player.pos.x, player.pos.y, puck.pos.x, puck.pos.y);
  if (distance <= 30) {
    isPlayerHittingPuck = true;
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
    shooting = false;
  }
}
