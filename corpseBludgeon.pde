//Graphics
import processing.opengl.*;
import processing.video.*;

GameController mainController;
HWInterface gameInterface;
PApplet root;
int score = 0;
long timeStarted = 0;
long timePlayed = 0;

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

// For using videos in Levels
void movieEvent(Movie m) {
    m.read();
}

// MAIN CONTROLLER ///////////////////////////////////////////////////////////////////////////////////////////
class GameController {
  int scorePerLevel = 10000;
  int currentLevel = 0;
  int currentFrame = 0;
  PFont scoreFont;
  int scoreDeceleration = 1;

  Level mainMenu;
  boolean mainMenuActive = true;
  Level[] levels;

  public GameController controller;

  GameController() {
    controller = this;
    scoreFont = loadFont("Cracked-64.vlw");

    mainMenu = new MainMenu(controller);
    //not elegant but efficient
    //Define the progression of levels and what objects handle them
    levels = new Level[6];
    levels[0] = new ZombieLevel();
    levels[1] = new SpinningBatLevel();
    levels[2] = new ConcreteLevel();
    levels[3] = new FlashingLevel();
    levels[4] = new GraveYardLevel();
    levels[5] = new ZombieLevel();

    //default opening level and the next level initialized or fast loading
    levels[0].init();
    levels[1].init();

    timeStarted = System.currentTimeMillis();
  }
  
  void draw() {

    if(mainMenuActive) {
      mainMenu.draw(currentFrame);
    } else {

      int previousLevel = currentLevel;
      
      int proposedLevel = score / scorePerLevel;

      currentLevel = proposedLevel > currentLevel ? (score / scorePerLevel) : currentLevel;

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
        timePlayed = (System.currentTimeMillis() - timeStarted) / 1000;
        DecimalFormat twoPlaces = new DecimalFormat("0.00");

        text(twoPlaces.format(timePlayed), 50, 100);
        
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
      scoreDeceleration = currentLevel;
      score = (currentFrame%25) == 0 ? (score <= 0 ? 0 : score-scoreDeceleration) : score ;
    }

    currentFrame++;
  }
  
  void triggerAction(int numHits) {
    if(currentLevel <= levels.length-1) {
      if(mainMenuActive) {
        mainMenu.triggerAction(numHits);
      } else {
        levels[currentLevel].triggerAction(numHits);
      }
    }
  }
  
}






