public class Game {
  int[] score = {0,0};
  String[] periods = {"1st", "2nd", "3rd"};
  SoundFile goalSound;
  TextAnim goalText;
  boolean goalScored;
  int curPeriod = 0;
  
  /**
   * Initializes and sets up all core game objects.
   * This includes loading assets, creating players and the puck,
   * positioning goals, initializing UI text animations, and
   * starting the game timer.
   * Uses goal, rink, players array, puck, and more.
  */
  public void setupObjects() {
    rink = loadImage("rink.png");
    Positions.putValuesInHash();
    for (int i = 0; i < players.length; i++) {
      players[i] = new Player(new PVector(0, 0), i == 0, Positions.positions[i], color(255, 0, 0));
      //enemies[i] = new Player(new PVector(-50 * i, 50 * i), false, Positions.positions[i], color(0, 0, 255));
    }
    players[1].pos.set(width/2, height/2);
    puck = new Puck(new PVector(width/3, height/3));
    mousePos = new PVector(mouseX, mouseY);
    goal = new Goal(new PVector(width+435, height/2), 0);
    goal2 = new Goal(new PVector(-428, height/2), 1);
    game.goalText = new TextAnim("GOOOOAAAAALLLL!", 4.6);
    timer = new Timer();
    timer.time = millis();
    timer.endPeriod = new TextAnim("END PERIOD", 4.6);
  }
  
  /**
    * Handles scoring logic when a goal is made.
    * This method pauses the game timer, plays the goal sound,
    * displays the goal animation, and increments the score
    * for the specified team. A goal can only be counted once
    * until the game state is reset.
  */
  public void goal(int team) {
    // goal logic
    if (!goalScored) {
      timer.isPaused = true;
      goalScored = true;
      goalSound.play();
      textSize(128);
      goalText.run();
      score[team]++;
    }
  }
  
  public void showEnd() {
    background(0);
    text("GAME OVER! Press Esc to Quit", width/2, height/2);
  }
  
  /**
   * Returns the player currently in possession of the puck.
   * All players are first marked as uncontrolled, then the player
   * with the puck (if any) is set as controlled and returned.
   * If no player currently has the puck, the last player who held it
   * regains control.
   */
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
  
  /**
   * Updates and renders all active game objects for the current frame.
   * This includes players, the puck, and goals, and also performs
   * collision checks after object updates.
  */
   public void reloadObjects() {
      for (Player player: players) {
      player.update();
      player.render();
    }
  
    //for (Player enemy: enemies) {
      //enemy.update();
      //enemy.render();
    //}

    puck.update();
    puck.render();
    goal.render();
    goal2.render();
    collisionCheck();
  }
  
  
  public void checkConditions () {
    if (game.goalScored) {
      boolean done = game.goalText.run();
      if (done) {
        game.goalText.reset();
        game.goalScored = false;
        timer.isPaused = false;
        puck.pos.set(width/2, height/2);
      }
    }
  
    if (timer.mins <= 0 && timer.secs <= 0) {
      boolean done = timer.endPeriod.run();
      if (done) {
        game.showEnd();
        timer.endPeriod.reset();
      }
    }
    
    //shot power logic
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
  
  // renders to screen
  public void renderHUD() {
    noStroke();
    strokeCap(MITER);
    //scorebug
    fill(25);
    quad(130, 111, 255, 111, 213.97, 175, 88.97, 175);
    stroke(204, 176, 16);
    strokeWeight(7.5);
    rect(140, 57.5, 300, 100);
    noStroke();
    fill(204, 176, 16);
    quad(190, 57.5/2-25, 290, 57.5/2-25, 290, 57.5/2+25, 155, 57.5/2+25);
    quad(190, 55, 290, 55, 290, 105, 155, 105);
    quad(40, 111, 130, 111, 105, 150, 15, 150);
    rect(240, 80, 100, 50);
    triangle(190, 8+50, 190, 28.75+76, 155, 28.75+76);
    stroke(255, 0, 0);
    line(0, 57.5, 293, 57.5);
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(24);
    text("NJ", 25, 57.5/2+2.5);
    text("NY", 25, 80);
    textSize(32);
    textAlign(CENTER, CENTER);
    text(timer.display(), 170, 143);
    fill(0);
    //text updates when a goal/timer updates
    text(score[0], 225, 57.5/2+2.5);
    text(score[1], 225, 80);
    text(periods[curPeriod], 75, 111+16);
    
  }
}
