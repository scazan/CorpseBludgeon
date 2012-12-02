

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
    bgImage = loadImage("openingScreen.jpg");
  }

  void draw(int currentFrame) {
    if(firstDraw) { backgroundMusic.play(0, true); firstDraw = false;}

    background(5);
    image(bgImage, 0, 0, width, height);
  } // end draw()

  
  void triggerAction(int numHits) {
    // println(gameController.mainMenuActive);
    gameController.mainMenuActive = false;
    backgroundMusic.destroy();
    firstDraw = true;
  } //end triggerAction()

  void destroy() {
    println("destroying");
  }

}

class GameOver extends Level {
  boolean firstDraw = true;
  int[] bgColor = {50,50,50};
  PImage bgImage;
  
  GameController gameController;
  PFont titleFont, subtitleFont;
  int red = 0;
  AudioCollection backgroundMusic;
  String[] musicFiles = {"Lascia.aiff"};

  GameOver(GameController controller) {
    //don't load anything until the time comes.
    gameController = controller;

    titleFont = loadFont("Lato.vlw");
    subtitleFont = loadFont("LatoSmall.vlw");

    backgroundMusic = new AudioCollection(musicFiles, true);
    bgImage = loadImage("gameover.gif");
  }

  void draw(int score) {
    if(firstDraw) { backgroundMusic.play(0, true); firstDraw = false;}

    background(5);
    image(bgImage, 0, 0, width, height);
  } // end draw()

  
  void triggerAction(int numHits) {
    // println(gameController.mainMenuActive);
    gameController.mainMenuActive = true;
    backgroundMusic.destroy();
    firstDraw = true;
    println("triggered");
  } //end triggerAction()

  void destroy() {
    println("destroying");
    backgroundMusic.destroy();
  }

}

class ConcreteLevel extends Level {
  boolean firstDraw = true;
  int strobeFrameRate = 3;
  int[] bgColor = {255,255,255};
  PImage bgImage;
  BloodSplatterController splatterController;
  ComboBreakerController comboController;
  AudioCollection backgroundMusic;
  String[] musicFiles = {"Reflex.aif"};

  ConcreteLevel() {
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
    score += 1000;
    comboController.newResponse(numHits) ;
  } //end triggerAction()

  void destroy() {
    println("destroying");
    backgroundMusic.destroy();
    backgroundMusic = null;
    bgImage = null;
    splatterController = null;
    comboController = null;
  }

}

class FlashingLevel extends Level {
  boolean firstDraw = true;
  int[] bgColor = {255,255,255};
  PImage bgImage;
  BloodSplatterController splatterController;
  ComboBreakerController comboController;
  AudioCollection backgroundMusic;
  String[] musicFiles = {"Reflex.aif"};

  FlashingLevel() {
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
    score += 1000;
    comboController.newResponse(numHits) ;
  } //end triggerAction()

  void destroy() {
    println("destroying");
    backgroundMusic.destroy();
    backgroundMusic = null;
    bgImage = null;
    splatterController = null;
    comboController = null;
  }
}

class GraveYardLevel extends Level {

  int strobeFrameRate = 3;
  int[] bgColor = {255,255,255};
  PImage bgImage;
  int bgScrollOffset = 0;
  int bgScrollSpeed = 15;
  BloodSplatterController splatterController;
  ComboBreakerController comboController;

  GraveYardLevel() {
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
    score += 1000;
    comboController.newResponse(numHits) ;
  } //end triggerAction()

  void destroy() {
    println("destroying");
    bgImage = null;
    splatterController = null;
    comboController = null;
  }

}

class ZombieLevel extends Level {
  boolean firstDraw = true;
  int strobeFrameRate = 3;
  int[] bgColor = {255,255,255};
  PImage bgImage;
  int bgScrollOffset = 0;
  int bgScrollSpeed = 15;
  BloodSplatterController splatterController;
  ComboBreakerController comboController;

  AudioCollection backgroundMusic;
  String[] musicFiles = {"Reflex.aif"};

  ZombieLevel() {
    //don't load anything until the time comes.
  }

  void init() {
    bgImage = loadImage("fetidzombie.jpg");
    backgroundMusic = new AudioCollection(musicFiles, true);
    splatterController = new BloodSplatterController();
    comboController = new ComboBreakerController();
  }

  void draw(int currentFrame) {
    if(firstDraw) { backgroundMusic.play(0,true); firstDraw = false;}
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
    score += 1000;
    comboController.newResponse(numHits) ;
  } //end triggerAction()

  void destroy() {
    println("destroying");
    backgroundMusic.destroy();
    backgroundMusic = null;
    bgImage = null;
    splatterController = null;
    comboController = null;
  }
}


class SpinningBatLevel extends Level {
  boolean firstDraw = true;
  int strobeFrameRate = 3;
  int[] bgColor = {255,255,255};
  PImage[] bgImage = new PImage[2];
  int bgScrollOffset = 0;
  int bgScrollSpeed = 15;

  AudioCollection backgroundMusic;
  String[] musicFiles = {"Reflex.aif"};

  BloodSplatterController splatterController;
  ComboBreakerController comboController;
  BabySpriteController babySpriteController;
  float rotation = 0;
  float currentImage = 0;

  SpinningBatLevel() {
    //don't load anything until the time comes.
  }

  void init() {
    backgroundMusic = new AudioCollection(musicFiles, true);
    bgImage[0] = loadImage("tvman.gif");
    bgImage[1] = loadImage("seabug.gif");
    // bgImage[2] = loadImage("velocity.jpg");
    
    splatterController = new BloodSplatterController();
    comboController = new ComboBreakerController();
    babySpriteController = new BabySpriteController();
  }

  void draw(int currentFrame) {
    if(firstDraw) { backgroundMusic.play(0,true); firstDraw = false;}

    tint(bgColor[0],bgColor[1],bgColor[2], 255);

    currentImage = (currentImage + 0.25) % (bgImage.length -1);
  
    int imageToShow = (int)Math.round(currentImage);
    image(bgImage[imageToShow], bgScrollOffset, random(0,10), bgImage[imageToShow].width, bgImage[imageToShow].height);
    image(bgImage[imageToShow], bgScrollOffset+bgImage[imageToShow].width, random(0,10), bgImage[imageToShow].width, bgImage[imageToShow].height);
      
    splatterController.draw();
    comboController.draw();
    babySpriteController.draw();

    bgScrollOffset = bgScrollOffset - bgScrollSpeed;
    if(bgScrollOffset <= (bgImage[imageToShow].width * -1)) {
      bgScrollOffset = 0;
    }
  } // end draw()

  void triggerAction(int numHits) {
    splatterController.newResponse();
    score += 1000;
    comboController.newResponse(numHits) ;
    babySpriteController.newResponse();
  } //end triggerAction()

  void destroy() {
    println("destroying");
    backgroundMusic.destroy();
    backgroundMusic = null;
    bgImage = null;
    splatterController = null;
    comboController = null;
  }
}
