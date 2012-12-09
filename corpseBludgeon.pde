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
Long timeStarted;
float timePlayed = 0.0;
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

void mouseClicked() {
    gameInterface.trigger(frameCount);
    // mainController.triggerMouseEvent();
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
  int scoreDeceleration = 800;

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

    ArrayList<Level> levelOrder = new ArrayList<Level>();
    
    levelOrder.add(new ConcreteLevel(controller) );
    levelOrder.add(new SkullLevel(controller) );
    levelOrder.add(new WiresLevel(controller) );
    levelOrder.add(new GlitchLevel(controller) );
    
    levelOrder.add(new BlackLevel(controller) );
    levelOrder.add(new FlashingLevel(controller) );
    levelOrder.add(new FireLevel(controller) );
    
    levelOrder.add(new BieberLevel(controller) );
    levelOrder.add(new SpinningBatLevel(controller) );

    levelOrder.add(new ZombieLevel(controller) );
    levelOrder.add(new GraveYardLevel(controller) );

    levelOrder.add(new FlashingLevel(controller) );


    //Define the progression of levels and what objects handle them
    levels = new Level[levelOrder.size()];

    for(int i=0; i<levelOrder.size(); i++) {
      levels[i] = levelOrder.get(i);
    }

    //default opening level and the next level initialized or fast loading
    levels[0].init();
    levels[1].init();


    timeStarted = new Long(System.currentTimeMillis());
  }
  
  void draw() {

    if(mainMenuActive) {
      mainMenu.draw(currentFrame);
    } else if(gameOverMenuActive){
      gameOver.draw(largestScore);
    } else {

      int previousLevel = currentLevel;
      
      int proposedLevel = score / scorePerLevel;

      currentLevel = proposedLevel > currentLevel ? (score / scorePerLevel) : currentLevel;

      if((currentLevel <= levels.length-1) && score > 0) {
        levels[currentLevel].draw(currentFrame);   

        if(currentLevel > previousLevel) {
          if(currentLevel < levels.length-1) {
            levels[currentLevel + 1].init();
            if(currentLevel > 0) {
              // println("destroying: " + currentLevel);
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
        
        // float scaledScore = score / (scorePerLevel * 10) * 2; // scaled to two
        // scaledScore = log(scaledScore) / log(10); // Set to a log10 curve
        
        // if(scaledScore < 2) {
        //   scaledScore = 0;
        // }
        
        // scaledScore += 2; // get into the positive range
        // scaledScore = scaledScore / 3; // scale to one

        // println(scaledScore);

        int numExclamations = floor( (score/1050) )  * 2;
        
        for(int i=1; i<=numExclamations; i++) {
          // println(i);
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

        Long timeMillis = new Long(System.currentTimeMillis());

        // TIME DISPLAY
        timePlayed = (timeMillis.intValue() - timeStarted.intValue()) / 1000.0;
        
        Date date = new Date((timeMillis.intValue() - timeStarted.intValue()));
        DateFormat formatter = new SimpleDateFormat("mm:ss:SSS");
        String twoPlaces = formatter.format(date);

        text(twoPlaces, 35, 125);
        
      } 
      else {
        // Display score
        // background(0);
        gameOverMenuActive = true;
        
        try{
          
          levels[currentLevel].destroy();

          for(int i=0; i<levels.length; i++) {
            levels[i].destroy();  
          }

          levels = null;
          
          // levels[levels.length-1] = null;
          // levels[currentLevel].destroy();
          // levels[currentLevel+1].destroy();
          currentLevel = 1; 
        } catch(Exception e) {
          println(e);
        }
        
        gameOver.draw(largestScore);
        
        // println("displaying");
        // textFont(scoreFont);
        // fill(0, 0, 0, 220);
        // textLeading(50);
        // text(largestScore, 20, (height/3)*1);
      }
      
      // Score slowly goes down if the player is not hitting
      if(currentLevel < 4) {
        scoreDeceleration = (int)Math.pow(timePlayed, 1.5);  
      } else if(currentLevel < 8) {
        scoreDeceleration = (int)Math.pow(timePlayed, 1.75);  
      } else {
        scoreDeceleration = (int)Math.pow(timePlayed, 2);  
      }
      
      score = (currentFrame%12) == 0 ? (score <= 0 ? 0 : score-scoreDeceleration) : score ;
    }

    currentFrame++;
  }
  
  void triggerAction(int numHits) {
    
    if(currentLevel <= levels.length-1 && !gameOverMenuActive ) {
      // && !mainMenuActive) {
      if(mainMenuActive) {
        mainMenu.triggerAction(numHits);
        timeStarted = new Long(System.currentTimeMillis());
      }
      else {
        levels[currentLevel].triggerAction(numHits);
      }
    }
    else if(gameOverMenuActive) {
      // println(gameOverMenuActive + ", " + mainMenuActive);
      // mainMenu = new MainMenu(controller);
      score = 0;
      gameOver.destroy();
      // gameOver.triggerAction(0);
      gameOverMenuActive = false;
      score = 0;
      timeStarted = new Long(0L);
      timePlayed = 0;
      score = 10;
      largestScore = 0;

      mainController = new GameController();
    }
     
  }

  void triggerMouseEvent() {
    // if(currentLevel <= levels.length-1 && !gameOverMenuActive) {
    // println(mainMenuActive);

      if(mainMenuActive) {
        mainMenu.triggerAction(0);
        timeStarted = new Long(System.currentTimeMillis());
      }
      else if(gameOverMenuActive) {
        score = 0;
        gameOver.destroy();
        // gameOver.triggerAction(0);
        gameOverMenuActive = false;
        score = 0;
        timeStarted = new Long(0L);
        timePlayed = 0;
        score = 10;
        largestScore = 0;

        mainController = new GameController();
      }
      else {
        gameOverMenuActive = true;
        
        try{

          levels[currentLevel].destroy();

          for(int i=0; i<levels.length; i++) {
            levels[i].destroy();  
          }

          levels = null;
          
          // levels[levels.length-1] = null;
          // levels[currentLevel].destroy();
          // levels[currentLevel+1].destroy();
          currentLevel = 1; 
        } catch(Exception e) {
          // println(e);
          levels = null;
        }
        tint(255,255);

        gameOver.draw(largestScore);
        // println("hello");
        
      }

  }
  
}





