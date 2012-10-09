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


// MAIN CONTROLLER ///////////////////////////////////////////////////////////////////////////////////////////
class GameController {
  int scorePerLevel = 10000;
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
          if(currentLevel > 0) {levels[currentLevel-1].destroy();}
        }
      }
      
      // Display score
      textFont(scoreFont);
      fill(225, 0, 0, 220);
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






