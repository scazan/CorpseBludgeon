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
int largestScore = 0;

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
  public int scorePerLevel = 2000;
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
    
    // levels[0] = new ZombieLevel();
    // levels[0] = new FireLevel();

    ArrayList<Level> levelOrder = new ArrayList<Level>();
    levelOrder.add(new GlitchLevel(controller) );
    levelOrder.add(new ConcreteLevel(controller) );
    levelOrder.add(new SkullLevel(controller) );
    levelOrder.add(new WiresLevel(controller) );
    levelOrder.add(new BlackLevel(controller) );
    levelOrder.add(new FlashingLevel(controller) );
    levelOrder.add(new BieberLevel(controller) );
    levelOrder.add(new SpinningBatLevel(controller) );
    levelOrder.add(new FlashingLevel(controller) );
    levelOrder.add(new GraveYardLevel(controller) );
    levelOrder.add(new ZombieLevel(controller) );


    //Define the progression of levels and what objects handle them
    levels = new Level[levelOrder.size()];

    for(int i=0; i<levelOrder.size(); i++) {
      levels[i] = levelOrder.get(i);
    }

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

      if((currentLevel <= levels.length-1) ) {
       // && score > 0) {
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
        scale(1.5 + scoreScaleJitter);
        

        int numExclamations = floor((score/1050)) * 2;
        
        for(int i=1; i<=numExclamations; i++) {
          println(i);
          text("|", 10 + (i*15), 50);
          // text("!", 10, 50);
        }

        fill(100,0,255,220);
        numExclamations = floor((largestScore/1050)) * 2;
        text("|", 10 + (numExclamations*15), 50);

        largestScore = score > largestScore ? score : largestScore;
        textAlign(LEFT);
        text(largestScore, 30 + (numExclamations*15), 50 + scoreScaleJitter);
        
        scale(1/(1.5+scoreScaleJitter));

        fill(255, 0, 0, 220);

        // TIME DISPLAY
        timePlayed = (System.currentTimeMillis() - timeStarted) / 1000;
        
        println(  String.valueOf( (System.currentTimeMillis() - timeStarted) / 1000L ) );
        
        DecimalFormat twoPlaces = new DecimalFormat("0.00");

        text(twoPlaces.format(timePlayed), width - 100, height-50);
        
      } 
      else {
        // Display score
        // background(0);
        
        gameOverMenuActive = true;
        
        try{
          levels[levels.length-1].destroy();
          levels[levels.length-1] = null;
          currentLevel = 1; 
        } catch(Exception e) {

        }
        
        gameOver.draw(score);
        textFont(scoreFont);
        fill(0, 0, 0, 220);
        textLeading(50);
        text(score, width/2, (height/3)*2);
      }
      
      // Score slowly goes down if the player is not hitting
      scoreDeceleration = (int)Math.pow(timePlayed, 1.75);
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






