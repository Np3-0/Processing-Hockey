public class TextAnim {
  String txt;
  float x;
  float speed;
  float durFrames;
  int frames = 0;

  public TextAnim(String txt, float speed) {
    this.txt = txt;
    this.speed = speed;
    this.durFrames = speed * 60;
    reset();
  }

  public void reset() {
    x = width + 200;
    frames = 0;
  }

  public boolean run() {
    puck.vel.set(0, 0);

    textAlign(CENTER);
    textSize(64);
    fill(0);

    text(txt, x, height / 2);

    x -= speed * 1.5;
    frames++;

    return frames > durFrames;
  }
}
