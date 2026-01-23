public class Timer {
  int wait = 1000, mins = 3, secs = 0;
  int time = 0;
  boolean isPaused = false;
  
  public void update() {
    if (!isPaused && millis() - time >= wait) {
      secs -= 1;
      if (mins == 0 && secs <= 0) {
        isPaused = true;
        print("PERIOD OVER");
      } else if (secs < 0) {
        mins -=1;
        secs = 59;
      }
      time = millis();
    }
  }
  
  public String display() {
    
    return str(mins) + ":" + (secs == 0 ? str(secs) + "0" : str(secs));
  }
}
