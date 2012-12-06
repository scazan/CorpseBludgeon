//for HWInterface
import oscP5.*;
import netP5.*;

//Graphics
import processing.opengl.*;
import processing.video.*;

GameController mainController;
XBeeInterface gameInterface;
PApplet root;
int score = 10;
long timeStarted = 0;
long timePlayed = 0;

// MAIN GAME LOOP ///////////////////////////////////////////////////////////////////////////////////////////
void setup() {

  root = this;

  size(1024, 768, OPENGL);
  if (frame != null) {
    frame.setResizable(true);
  }
  frameRate(30);
  
  mainController = new GameController();
  gameInterface = new XBeeInterface();

}

void draw() {  
  mainController.draw();
}

// For Testing
void mouseClicked() {
    gameInterface.trigger(frameCount);
}

void oscEvent(OscMessage theOscMessage) {
  gameInterface.oscEvent(theOscMessage);
}

// For using videos in Levels
void movieEvent(Movie m) {
    m.read();
}

// MAIN CONTROLLER ///////////////////////////////////////////////////////////////////////////////////////////
class GameController {
  int scorePerLevel = 5000000;
  int currentLevel = 0;
  int currentFrame = 0;
  PFont scoreFont;
  int scoreDeceleration = 1000;

  Level mainMenu, gameOver;
  boolean mainMenuActive = true,
    gameOverMenuActive = false;
  Level[] levels;

  public GameController controller;

  GameController() {
    controller = this;
    scoreFont = loadFont("Cracked-64.vlw");

    mainMenu = new MainMenu(controller);
    gameOver  = new GameOver(controller);
    //not elegant but efficient
    //Define the progression of levels and what objects handle them
    levels = new Level[10];
    // levels[0] = new ZombieLevel();
    // levels[0] = new FireLevel();
    levels[0] = new ConcreteLevel();
    levels[1] = new SkullLevel();
    levels[2] = new WiresLevel();
    levels[3] = new BlackLevel();
    levels[4] = new FlashingLevel();
    levels[5] = new BieberLevel();
    levels[6] = new SpinningBatLevel();
    levels[7] = new FlashingLevel();
    levels[8] = new GraveYardLevel();
    levels[9] = new ZombieLevel();

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

      if((currentLevel <= levels.length-1)) {
        levels[currentLevel].draw(currentFrame);   

        if(currentLevel > previousLevel) {
          if(currentLevel < levels.length-1) {
            levels[currentLevel + 1].init();
            if(currentLevel > 0) {
              println("destroying: " + currentLevel);
              levels[currentLevel-1].destroy();
              levels[currentLevel-1] = null;
            }
          }
        }
        
        // Display score
        textFont(scoreFont);
        fill(225, 0, 0, 220);
        textLeading(50);
        float scoreScaleJitter = random(0.05);
        scale(2.5 + scoreScaleJitter);
        text(score + "!!!!!!", 10, 50);
        scale(1/(2.5+scoreScaleJitter));
        timePlayed = (System.currentTimeMillis() - timeStarted) / 1000;
        
        println(  String.valueOf( (System.currentTimeMillis() - timeStarted) / 1000L ) );
        
        DecimalFormat twoPlaces = new DecimalFormat("0.00");

        text(twoPlaces.format(timePlayed), 50, height-50);
        
      } 
      else {
        // Display score
        // background(0);
        
        gameOverMenuActive = true;
        try{
          levels[levels.length-1].destroy();
          levels[levels.length-1] = null;
        } catch(Exception e) {

        }
        
        gameOver.draw(score);
        textFont(scoreFont);
        fill(0, 0, 0, 220);
        textLeading(50);
        text(score, width/2, (height/3)*2);
      }
      
      // Score slowly goes down if the player is not hitting
      scoreDeceleration = (int)Math.pow(currentLevel+1, 5);
      score = (currentFrame%12) == 0 ? (score <= 0 ? 0 : score-scoreDeceleration) : score ;
    }

    currentFrame++;
  }
  
  void triggerAction(int numHits) {
    
    if(currentLevel <= levels.length-1) {
      if(mainMenuActive) {
        mainMenu.triggerAction(numHits);
        timeStarted = System.currentTimeMillis();
      }

      else {
        levels[currentLevel].triggerAction(numHits);
      }
    }
    else if(gameOverMenuActive) {
        println(gameOverMenuActive + ", " + mainMenuActive);
        // mainMenu = new MainMenu(controller);
        score = 0;
        gameOver.destroy();
        // gameOver.triggerAction(0);
        gameOverMenuActive = false;
        score = 0;
        timeStarted = 0;
        timePlayed = 0;
        mainController = new GameController();
      }
     
  }
  
}






