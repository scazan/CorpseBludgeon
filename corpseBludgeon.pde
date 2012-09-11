//Audio
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
//Graphics
import processing.opengl.*;

GameController mainController;
HWInterface gameInterface;
PApplet root;
int score = 0;


// MAIN GAME LOOP ///////////////////////////////////////////////////////////////////////////////////////////
void setup() {

  root = this;

  size(1440, 900, OPENGL);
  if (frame != null) {
    frame.setResizable(true);
  }
  frameRate(30);
  
  mainController = new GameController();
  gameInterface = new HWInterface();
  
}

void draw() {  
  mainController.draw();
}

// For Testing
void mouseClicked() {
    gameInterface.trigger(frameCount);
}




// HW INTERFACE ///////////////////////////////////////////////////////////////////////////////////////////
class HWInterface {
  int lastSystemFrameCount = 0;
  int numClicks = 0;

  HWInterface() {
    
  }
  
  void trigger(int systemFrameCount) {
    println(numClicks);
    
    if(systemFrameCount - lastSystemFrameCount < 5) {
        mainController.triggerAction(numClicks);
        numClicks++;
    }
    else {
      numClicks = 1;
      mainController.triggerAction(numClicks);
        
    }
    
    lastSystemFrameCount = systemFrameCount;
    
  }
}

// MAIN CONTROLLER ///////////////////////////////////////////////////////////////////////////////////////////
class GameController {
  int scorePerLevel = 3000;
  int currentLevel = 0;
  int currentFrame = 0;
  PFont scoreFont;

  Level[] levels;

  GameController() {
    scoreFont = loadFont("Cracked-64.vlw");

    //not elegant but efficient
    //Define the progression of levels and what objects handle them
    levels = new Level[3];
    levels[0] = new Opening();
    levels[1] = new LevelTwo();
    levels[2] = new LevelThree();

    //default opening level and the next level initialized
    levels[0].init();
    levels[1].init();
  }
  
  void draw() {
    int previousLevel = currentLevel;
    currentLevel = (score / scorePerLevel);

    if(currentLevel <= levels.length-1) {
      levels[currentLevel].draw(currentFrame);  

      if(currentLevel > previousLevel) {
        if(currentLevel < levels.length-1) {
          levels[currentLevel + 1].init();
        }
      }
      
      // Display score
      textFont(scoreFont);
      fill(80, 80, 80, 220);
      textLeading(50);
      text(score, 50, 50);
    } 
    else {
      // Display score
      background(0);
      textFont(scoreFont);
      fill(80, 80, 80, 220);
      textLeading(50);
      text("GAME OVER", width/2, height/2);
    }
    
    // Score slowly goes down if the player is not hitting
    score = (currentFrame%25) == 0 ? (score <= 0 ? 0 : score-1) : score ;
    currentFrame++;
  }
  
  void triggerAction(int numHits) {
    if(currentLevel <= levels.length-1) {
      levels[currentLevel].triggerAction(numHits);
    }
  }
  
}

// ACTIONRESPONSE CLASSES ///////////////////////////////////////////////////////////////////////////////////////////
// Various effects displayed in the game. Basically ViewControllers. 
// Instantiated and aggregated from the ActionResponseController factories.
abstract class ActionResponse {
  int currentFrame = 0;
  int xPos, yPos;
  float fadeDuration = 0;
  float fadeValue = 0;
  int brightness = 255;
  
  boolean display = true;
  
  void draw() {
    // Must be overridden
  }
}

class BloodSplatter extends ActionResponse {
    PImage[] splatterFrames; 
    int randomFrame = 0;
    int squareSize = 100;
   
   BloodSplatter(PImage[] frames, AudioCollection responseAudio) {
      xPos = (int)random(width);
      yPos = (int)random(height);
      fadeDuration = 120;
      fadeValue = fadeDuration;
      
      splatterFrames = frames; 
      
      randomFrame = (int) random(splatterFrames.length);
      squareSize = (int)random(200,width/2);
      brightness = (int)random(150,255);
      
      // AUDIO HAPPENS IMMEDIATELY AND ONCE
      // The use of index numbers here implies tight coupling with the Controller class :(
      responseAudio.play(0);
      if(random(0,3) < 1) {
        if(random(0,3) < 1) {
          responseAudio.play(1);
        }
        else {
          responseAudio.play(2);
        }
      }

   } 
   
   void draw() {
       if(fadeValue > 0) {
         tint(brightness, ((fadeValue/fadeDuration) *255));
         image(splatterFrames[randomFrame], xPos, yPos, squareSize, squareSize);
         
         fadeValue--;
       }
       else {
         display = false;
       }
   }
 
}

class ComboBreaker extends ActionResponse {
  PFont font;
  int comboNumber = 0;
 
  ComboBreaker(int numHits) {  
    xPos = (int)random(10,width/2);
    yPos = (int)random(50, height/2);
     
    font = loadFont("Cracked-64.vlw"); 
    textFont(font); 
      
    fadeDuration = 25;
    fadeValue = fadeDuration;
      
    comboNumber = numHits;
  }
 
  void draw() {

    String message = comboNumber + " IN A ROW!!!";
    
    if(comboNumber > 3) {
      message += "\n";
    }

    if(comboNumber > 10) {
      message += "DOUBLE";
    }

    if(comboNumber > 3) {
      message += " SUPER";
    }

    if(comboNumber > 6) {
      message += " MEGA";
    }

    if(comboNumber > 10) {
      message += " ULTIMATE";
    }
    
    message += " COMBO";

    if(comboNumber > 3) {
      message += " BREAKER";
    }
    message += "!!!!!!!";
    
    if(fadeValue > 0) {
      PImage backImage = loadImage(sketchPath + "/data/psycho.gif");
      tint(comboNumber * 50 %255, random(0,200), comboNumber * 25, ((fadeValue/fadeDuration) *200) );
      image(backImage, xPos+50, yPos-50);
      tint(255,255);
      
      fill(comboNumber * 50 %255, random(0,200), comboNumber * 25, ((fadeValue/fadeDuration) *255) );
      textLeading(50);
      text(message, xPos, yPos);

      fadeValue--;
    }
    else {
      display = false;
    }
  }
}

// ActionResponse Controllers 
abstract class ActionResponseController {
  ArrayList actionResponses;
  AudioCollection responseAudio;


  ActionResponseController() {
    actionResponses = new ArrayList();
  }

  void draw() {
    for(int i = 0; i<actionResponses.size(); i++) {
      ActionResponse response = (ActionResponse) actionResponses.get(i);
      
      if(response.display == false) {
        actionResponses.remove(i);
      }
      else {
        response.draw(); 
      }
    }
  }

  void newResponse() {

  }
}

class BloodSplatterController extends ActionResponseController {

  String[] splatterFiles;
  PImage[] splatterFrames;

  BloodSplatterController() {
    super();

    String[] sampleFiles = {"coin.wav", "squash.wav", "squash2.wav"};
    responseAudio = new AudioCollection(sampleFiles);

    File dataDir = new File(sketchPath + "/data/blood/");
    splatterFiles = dataDir.list();
    splatterFrames = new PImage[splatterFiles.length];
      
    for(int i=0; i<splatterFiles.length; i++) {
      splatterFrames[i] = loadImage(sketchPath + "/data/blood/" + splatterFiles[i]);
    }
  }

  void newResponse() {
    for(int i=0; i<3;i++)
    {
      actionResponses.add( new BloodSplatter(splatterFrames, responseAudio) );
    }
  }
}

class ComboBreakerController extends ActionResponseController {

  ComboBreakerController() {
    super();
  }

  void newResponse(int numHits) {
    if(numHits >2)
    { 
      actionResponses.add( new ComboBreaker(numHits) );
    }
  }
}

// LEVELS ///////////////////////////////////////////////////////////////////////////////////////////
abstract class Level {
  void draw(int currentFrame) {
  }

  void triggerAction(int numHits) {
  }

  void init() {
  }
}

class Opening extends Level {
  int strobeFrameRate = 3;
  int[] bgColor = {255,255,255};
  PImage bgImage;
  BloodSplatterController splatterController;
  ComboBreakerController comboController;

  Opening() {
    //don't load anything until the time comes.
  }

  void init() {
    bgImage = loadImage("grunge.jpg");
    splatterController = new BloodSplatterController();
    comboController = new ComboBreakerController();
  }

  void draw(int currentFrame) {
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
    score += 100;
    comboController.newResponse(numHits) ;
  } //end triggerAction()

}

class LevelTwo extends Level {
  int[] bgColor = {255,255,255};
  PImage bgImage;
  BloodSplatterController splatterController;
  ComboBreakerController comboController;

  LevelTwo() {
    //don't load anything until the time comes.
  }

  void init() {
    bgImage = loadImage("clouds.jpg");
    splatterController = new BloodSplatterController();
    comboController = new ComboBreakerController();
  }

  void draw(int currentFrame) {
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
}

class LevelThree extends Level {

  int strobeFrameRate = 3;
  int[] bgColor = {255,255,255};
  PImage bgImage;
  int bgScrollOffset = 0;
  int bgScrollSpeed = 5;
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

// SOUND ///////////////////////////////////////////////////////////////////////////////////////////
class AudioCollection {
  Minim minim;
  AudioSample[] samples;
  
  AudioCollection(String sampleArray[]) {
    minim = new  Minim ( root );
    samples = new AudioSample[sampleArray.length];

    for(int i=0;i<sampleArray.length;i++){
      samples[i] = minim.loadSample(sketchPath + "/data/sound/" + sampleArray[i] );
    }
  }

  void play(int sampleNumber) {
    // if(player != null) {
    //   player.close();
    // }
    samples[sampleNumber].trigger();
  }
}
