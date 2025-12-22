import java.util.HashMap;
import java.util.Map;
import processing.sound.*;

Player[] players = new Player[5];
Player holder;
Puck puck;
Goal goal;
Game game;
public PVector mousePos;
//controls
public boolean left = false, right = false, up = false, down = false;
//game states
float shotProgress = 0;
int lastHolderInd = 0;

void setup() {
  size(1080,720);
  translate(width/2, height/2);
  noStroke();
  game = new Game();
  Positions.putValuesInHash();
  for (int i = 0; i < players.length; i++) {
    players[i] = new Player(new PVector(width/(i+2), height/(i+2)), i == 0, Positions.positions[i]);
  }
  text("LOADING", width/2, height/2);
  puck = new Puck(new PVector(width/3, height/3));
  mousePos = new PVector(mouseX, mouseY);
  goal = new Goal(new PVector(width-50, height/2));
  game.goalSound = new SoundFile(this, "goal.mp3");
  game.goalSound.play();
  game.goalSound.pause();
  game.goalText = new TextAnim("GOOOOAAAAALLLL!", 4.6);
}

void draw(){
  background(220);
  rectMode(CENTER);
  noStroke();
  mousePos = new PVector(mouseX, mouseY);
  for (Player player: players) {
    player.update();
  }
  puck.update();
  collisionCheck();
  
  for (Player player : players) {
    player.render();
  }
  puck.render();
  goal.render();
  game.renderHUD();
  if (game.goalScored) {
    boolean done = game.goalText.run();
    if (done) {
      game.goalText.reset();
      game.goalScored = false;
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

void collisionCheck() {
  for (int i = 0; i < players.length; i++) {
    float distance = dist(players[i].pos.x, players[i].pos.y, puck.pos.x, puck.pos.y);
    players[i].hasPuck = distance <= 30;
  }
  
  if ((puck.pos.x + puck.hitbox > goal.pos.x - goal.w/2 && puck.pos.x - puck.hitbox < goal.pos.x + goal.w/2) && (puck.pos.y - puck.hitbox > goal.pos.y - goal.h/2 && puck.pos.y + puck.hitbox < goal.pos.y + goal.h/2) && puck.vel.x > 0) {
    game.goal();
  }

  if (puck.pos.x - puck.hitbox < 0) {
    puck.pos.x = puck.hitbox;
    puck.vel.x *= -1;
  }

  if (puck.pos.x + puck.hitbox > width) {
    puck.pos.x = width - puck.hitbox;
    puck.vel.x *= -1;
  }

  if (puck.pos.y - puck.hitbox < 0) {
    puck.pos.y = puck.hitbox;
    puck.vel.y *= -1;
  }

  if (puck.pos.y + puck.hitbox > height) {
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
