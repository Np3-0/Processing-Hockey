public static class Positions {
  static String[] positions = {"LW", "C", "RW", "RD", "LD", "G"};
  static HashMap<String, HashMap<String, PVector>> dists = new HashMap<>();

  public static void putValuesInHash() {
    HashMap<String, PVector> LW = new HashMap<>();
    LW.put("C",  new PVector(0, 240));
    LW.put("RW", new PVector(0, 480));
    LW.put("LD", new PVector(-360, 90));
    LW.put("RD", new PVector(-360, 390));
    dists.put("LW", LW);
    
    HashMap<String, PVector> RW = new HashMap<>();
    RW.put("C",  new PVector(0, -240));
    RW.put("LW", new PVector(0, -480));
    RW.put("LD", new PVector(-360, -390));
    RW.put("RD", new PVector(-360, -90));
    dists.put("RW", RW);
    
    HashMap<String, PVector> C = new HashMap<>();
    C.put("LW",  new PVector(0, -240));
    C.put("RW", new PVector(0, 240));
    C.put("LD", new PVector(-360, -150));
    C.put("RD", new PVector(-360, 150));
    dists.put("C", C);
    
    HashMap<String, PVector> LD = new HashMap<>();
    LD.put("LW",  new PVector(360, -90));
    LD.put("RW", new PVector(360, 390));
    LD.put("C", new PVector(360, 150));
    LD.put("RD", new PVector(0, 480));
    dists.put("LD", LD);
    
    HashMap<String, PVector> RD = new HashMap<>();
    RD.put("RW",  new PVector(360, 90));
    RD.put("LW", new PVector(360, -390));
    RD.put("C", new PVector(360, -150));
    RD.put("LD", new PVector(0, -480));
    dists.put("RD", RD);
  }
}
