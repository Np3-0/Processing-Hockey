/*
Name: Nathan O'Brien
Date: 1/21/26
Program: Portfolio Project - Hockey
*/
import java.util.HashMap;
import java.util.Map;
import processing.sound.*;

Player[] players = new Player[5];
Player[] enemies = new Player[5];
Player holder;
PImage rink;
PFont font;
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
  size(1080,720, P2D);
  frameRate(60);
  noStroke();
  game = new Game();
  
  font = loadFont("GillSansMT-BoldItalic-48.vlw");
  textFont(font);
  
  text("LOADING", width/2, height/2);
  game.setupObjects();
  // soundfile needs to be outside for it to work
  game.goalSound = new SoundFile(this, "goal.mp3");
  game.goalSound.play();
  game.goalSound.pause();
   //<>//
}

// runs neccesary code for each input.
void draw(){
  background(247);
  resetMatrix();
  
  rectMode(CENTER);
  noStroke();
  mousePos = new PVector(mouseX, mouseY);
  moveCamera();
  
  imageMode(CENTER);
  image(rink, width/2, height/2);  
  strokeWeight(5);
  stroke(0);
  
  game.reloadObjects();
   
  resetMatrix();
  timer.update();
  game.renderHUD();
  game.checkConditions();
  
}

void moveCamera() {
  if (holder != null) translate(width/2 - holder.pos.x, height/2 - holder.pos.y);
}

void collisionCheck() {
  //gets which player has the puck
  for (int i = 0; i < players.length; i++) {
    float distance = dist(players[i].pos.x, players[i].pos.y, puck.pos.x, puck.pos.y);
    players[i].hasPuck = distance <= 30;
  }
  
  //checks to see if a player shot the puck in the goal
  if ((puck.pos.x + puck.hitbox > goal.pos.x - goal.w/2 && puck.pos.x - puck.hitbox < goal.pos.x + goal.w/2) && (puck.pos.y - puck.hitbox > goal.pos.y - goal.h/2 && puck.pos.y + puck.hitbox < goal.pos.y + goal.h/2) && puck.vel.x > 0) {
    game.goal();
  }

  //gets 
  if (puck.pos.x - puck.hitbox < -500) {
    puck.vel.x *= -1;
  }

  if (puck.pos.x + puck.hitbox > width + 500) {
    puck.vel.x *= -1;
  }

  if (puck.pos.y - puck.hitbox < -95) {
    puck.vel.y *= -1;
  }

  if (puck.pos.y + puck.hitbox > height + 95) {
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
        holder.shoot(shotProgress);
    }
    if (holder != null) holder.shooting = false;
    shotProgress = 0;
  }
}
