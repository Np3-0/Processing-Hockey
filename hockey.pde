import java.util.HashMap;
import java.util.Map;
import processing.sound.*;

Player[] players = new Player[5];
Player holder;
PImage rink;
Puck puck;
Goal goal;
Game game;
Timer timer;
public PVector mousePos;
//controls
public boolean left = false, right = false, up = false, down = false;
//game states
float shotProgress = 0;
int lastHolderInd = 0;

void setup() {
  size(1080,720);
  noStroke();
  rink = loadImage("rink.png");
  game = new Game();
  Positions.putValuesInHash();
  for (int i = 0; i < players.length; i++) {
    players[i] = new Player(new PVector(0, 0), i == 0, Positions.positions[i]);
  }
  players[1].pos.set(width/2, height/2);
  text("LOADING", width/2, height/2);
  puck = new Puck(new PVector(width/3, height/3));
  mousePos = new PVector(mouseX, mouseY);
  goal = new Goal(new PVector(width-50, height/2));
  game.goalSound = new SoundFile(this, "goal.mp3");
  game.goalSound.play();
  game.goalSound.pause();
  game.goalText = new TextAnim("GOOOOAAAAALLLL!", 4.6);
  timer = new Timer();
  timer.time = millis(); //<>//
}

void draw(){
  background(247);
  resetMatrix();
  
  rectMode(CENTER);
  noStroke();
  mousePos = new PVector(mouseX, mouseY);
  moveCamera();
  
  imageMode(CENTER);
  image(rink, width/2, height/2);
  //camera
  
  strokeWeight(5);
  stroke(0);
  line(0, height/2, width, height/2);
  
  for (Player player: players) {
    player.update();
    player.render();
  }

  puck.update();
  puck.render();
  goal.render();
  collisionCheck();
   
  resetMatrix();
  timer.update();
  game.renderHUD();
  
  if (game.goalScored) {
    boolean done = game.goalText.run();
    if (done) {
      game.goalText.reset();
      game.goalScored = false;
      timer.isPaused = false;
      puck.pos.set(width/2, height/2);
    }
  }

  holder = getPlayerWithPuck();
  if (holder != null && holder.shooting && holder.hasPuck) {
    stroke(0);
    strokeWeight(1);
    fill(255);
    rect(width/2, height-50, width*0.75, 100);
    fill(0,255,0);
    rectMode(CORNER);
    
    rect(135, height-100, shotProgress, 100);
    shotProgress = constrain(shotProgress+15, 1, 810);
  }
  
  if (holder != null && !holder.shooting) shotProgress = 0;
}

void moveCamera() {
  if (holder != null) translate(width/2 - holder.pos.x, height/2 - holder.pos.y);
}

void collisionCheck() {
  for (int i = 0; i < players.length; i++) {
    float distance = dist(players[i].pos.x, players[i].pos.y, puck.pos.x, puck.pos.y);
    players[i].hasPuck = distance <= 30;
  }
  
  if ((puck.pos.x + puck.hitbox > goal.pos.x - goal.w/2 && puck.pos.x - puck.hitbox < goal.pos.x + goal.w/2) && (puck.pos.y - puck.hitbox > goal.pos.y - goal.h/2 && puck.pos.y + puck.hitbox < goal.pos.y + goal.h/2) && puck.vel.x > 0) {
    game.goal();
  }

  if (puck.pos.x - puck.hitbox < -500) {
    puck.pos.x = puck.hitbox;
    puck.vel.x *= -1;
  }

  if (puck.pos.x + puck.hitbox > width + 250) {
    puck.pos.x = width - puck.hitbox;
    puck.vel.x *= -1;
  }

  if (puck.pos.y - puck.hitbox < -250) {
    puck.pos.y = puck.hitbox;
    puck.vel.y *= -1;
  }

  if (puck.pos.y + puck.hitbox > height + 500) {
    puck.pos.y = height - puck.hitbox;
    puck.vel.y *= -1;
  }
}

public Player getPlayerWithPuck() {
  for (Player p : players) {
    p.controlled = false;
  }

  for (int i = 0; i < players.length; i++) {
    if (players[i].hasPuck) {
      lastHolderInd = i;
      players[i].controlled = true;
      return players[i];
    }
  }

  players[lastHolderInd].controlled = true;
  return players[lastHolderInd];
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
    if (holder != null) {
      holder.shooting = true;
    }
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
    if (holder != null && holder.hasPuck) {
        holder.shoot();
    }
    if (holder != null) holder.shooting = false;
    shotProgress = 0;
  }
}
