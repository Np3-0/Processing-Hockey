public class Game {
  int[] score = {0,0};
  SoundFile goalSound;
  TextAnim goalText;
  boolean goalScored;
  public void goal() {
    if (!goalScored) {
      goalScored = true;
      goalSound.play();
      textSize(128);
      goalText.run();
    }
  }
  
  public void renderHUD() {
    rect(100, 50, 200, 100);
  }
}
