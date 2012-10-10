

// LEVELS ///////////////////////////////////////////////////////////////////////////////////////////
abstract class Level {
  void draw(int currentFrame) {
  }

  void triggerAction(int numHits) {
  }

  void init() {
  }

  void destroy() {

  }
}

class MainMenu extends Level {
  boolean firstDraw = true;
  int[] bgColor = {50,50,50};
  PImage bgImage;
  
  GameController gameController;
  PFont titleFont, subtitleFont;
  int red = 0;
  AudioCollection backgroundMusic;
  String[] musicFiles = {"Lascia.aiff"};

  MainMenu(GameController controller) {
    //don't load anything until the time comes.
    gameController = controller;

    titleFont = loadFont("Lato.vlw");
    subtitleFont = loadFont("LatoSmall.vlw");

    backgroundMusic = new AudioCollection(musicFiles, true);
  }

  void draw(int currentFrame) {
    if(firstDraw) { backgroundMusic.play(0, true); firstDraw = false;}

    background(5);
    textFont(titleFont);
    textLeading(50);
    fill(red + 80, 80, 80, 220);
    text("CORPSE BLUDGEON", 48, (height/2)+2 );
    fill(5);
    text("CORPSE BLUDGEON", 50, height/2);
    
    textFont(subtitleFont);
    fill(red + 80, 80, 80, 220);
    text("GET READY...", (width/2) -2, ((height/3) *2) + 2);
    fill(5);
    text("GET READY...", width/2, (height/3) *2);

    red = (red + 1) % 255;
  } // end draw()

  
  void triggerAction(int numHits) {
    println(gameController.mainMenuActive);
    gameController.mainMenuActive = false;
    backgroundMusic.destroy();
    firstDraw = true;
  } //end triggerAction()

  void destroy() {
    
  }

}

class Opening extends Level {
  boolean firstDraw = true;
  int strobeFrameRate = 3;
  int[] bgColor = {255,255,255};
  PImage bgImage;
  BloodSplatterController splatterController;
  ComboBreakerController comboController;
  AudioCollection backgroundMusic;
  String[] musicFiles = {"Reflex.aif"};

  Opening() {
    //don't load anything until the time comes.
  }

  void init() {
    backgroundMusic = new AudioCollection(musicFiles, true);
    bgImage = loadImage("grunge.jpg");
    splatterController = new BloodSplatterController();
    comboController = new ComboBreakerController();

    
  }

  void draw(int currentFrame) {
    
    if(firstDraw) { backgroundMusic.play(0,true); firstDraw = false;}

    tint(bgColor[0],bgColor[1],bgColor[2], 255);
    image(bgImage, 0, 0, width, height);
    
    if(currentFrame%strobeFrameRate == 0) {
      bgColor[0] = (int)random(150);
      bgColor[1] = (int)random(255);
      bgColor[2] = (int)random(255);
    }
    
    splatterController.draw();
    comboController.draw();

  } // end draw()

  void triggerAction(int numHits) {
    splatterController.newResponse();
    score += 1459;
    comboController.newResponse(numHits) ;
  } //end triggerAction()

  void destroy() {
    backgroundMusic.destroy();
  }

}

class LevelTwo extends Level {
  boolean firstDraw = true;
  int[] bgColor = {255,255,255};
  PImage bgImage;
  BloodSplatterController splatterController;
  ComboBreakerController comboController;
  AudioCollection backgroundMusic;
  String[] musicFiles = {"Reflex.aif"};

  LevelTwo() {
    //don't load anything until the time comes.
  }

  void init() {
    backgroundMusic = new AudioCollection(musicFiles, true);

    bgImage = loadImage("clouds.jpg");
    splatterController = new BloodSplatterController();
    comboController = new ComboBreakerController();
  }

  void draw(int currentFrame) {
    if(firstDraw) { backgroundMusic.play(0, true); firstDraw = false;}
    // background(currentFrame%1 * 255);
    background(200 * (currentFrame%2));
    // tint(currentFrame%1, currentFrame%1, currentFrame%1, 255);
    // image(bgImage, 0, 0, width, height);

    splatterController.draw();
    comboController.draw();
  } // end draw()

  void triggerAction(int numHits) {
    splatterController.newResponse();
    score += 100;
    comboController.newResponse(numHits) ;
  } //end triggerAction()

  void destroy() {
    println("destroying");
    backgroundMusic.destroy();
  }
}

class LevelThree extends Level {

  int strobeFrameRate = 3;
  int[] bgColor = {255,255,255};
  PImage bgImage;
  int bgScrollOffset = 0;
  int bgScrollSpeed = 15;
  BloodSplatterController splatterController;
  ComboBreakerController comboController;

  LevelThree() {
    //don't load anything until the time comes.
  }

  void init() {
    bgImage = loadImage("warishell.jpg");
    // bgImage = loadImage("hell.jpg");
    splatterController = new BloodSplatterController();
    comboController = new ComboBreakerController();
  }

  void draw(int currentFrame) {
    tint(bgColor[0],bgColor[1],bgColor[2], 255);
    image(bgImage, bgScrollOffset, 0, width, height);
    image(bgImage, width+bgScrollOffset, 0, width, height);
    
    
    if(currentFrame%strobeFrameRate == 0) {
      bgColor[0] = (int)random(150);
      bgColor[1] = (int)random(255);
      bgColor[2] = (int)random(255);
    }
    
    splatterController.draw();
    comboController.draw();
    bgScrollOffset = bgScrollOffset - bgScrollSpeed;
    if(bgScrollOffset <= (width * -1)) {
      bgScrollOffset = 0;
    }
  } // end draw()

  void triggerAction(int numHits) {
    splatterController.newResponse();
    score += 100;
    comboController.newResponse(numHits) ;
  } //end triggerAction()

}