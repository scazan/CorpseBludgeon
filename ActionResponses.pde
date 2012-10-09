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
      responseAudio.play(0,false);
      if(random(0,3) < 1) {
        if(random(0,3) < 1) {
          responseAudio.play(1,false);
        }
        else {
          responseAudio.play(2,false);
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
    responseAudio = new AudioCollection(sampleFiles, false);

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