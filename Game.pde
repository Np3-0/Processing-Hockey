public class Game {
  int[] score = {0,0};
  String[] periods = {"1st", "2nd", "3rd"};
  SoundFile goalSound;
  TextAnim goalText;
  boolean goalScored;
  int curPeriod = 0;
  
  public void goal() {
    if (!goalScored) {
      timer.isPaused = true;
      goalScored = true;
      goalSound.play();
      textSize(128);
      goalText.run();
      score[0]++;
    }
  }
  
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
    text(score[0], 225, 57.5/2+2.5);
    text(score[1], 225, 80);
    text(periods[curPeriod], 75, 111+16);
    
  }
}
