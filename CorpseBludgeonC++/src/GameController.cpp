

GameController::GameController() {
	scorePerLevel = 200;

	currentLevel = 0;
	currentFrame = 0;
	scoreDeceleration = 800;
	//TYPE scoreFont;

	//Level mainMenu;
	//Level gameOver;
	bool mainMenuActive = true;
	bool gameOverMenuActive = false;
	//Level[] levels;
	score = 10;
	timePlayed = 0.0;
	largestScore = 0;
}

GameController::~GameController() {
    //scoreFont = loadFont("Cracked-64.vlw");

    //mainMenu = new MainMenu(controller);
    //gameOver  = new GameOver(controller);

    //ArrayList<Level> levelOrder = new ArrayList<Level>();

    //levelOrder.add(new ConcreteLevel(controller) );
    //levelOrder.add(new SkullLevel(controller) );
    //levelOrder.add(new WiresLevel(controller) );
    //levelOrder.add(new GlitchLevel(controller) );

    //levelOrder.add(new BlackLevel(controller) );
    //levelOrder.add(new FlashingLevel(controller) );
    //levelOrder.add(new FireLevel(controller) );

    //levelOrder.add(new BieberLevel(controller) );
    //levelOrder.add(new SpinningBatLevel(controller) );

    //levelOrder.add(new ZombieLevel(controller) );
    //levelOrder.add(new GraveYardLevel(controller) );

    //levelOrder.add(new FlashingLevel(controller) );


    ////Define the progression of levels and what objects handle them
    //levels = new Level[levelOrder.size()];

    //for(int i=0; i<levelOrder.size(); i++) {
      //levels[i] = levelOrder.get(i);
    //}

    ////default opening level and the next level initialized or fast loading
    //levels[0].init();
    //levels[1].init();

    timeStarted = ofGetElapsedTimef();
}

void GameController::draw() {

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

			int numExclamations = floor( (score/1050) )  * 2;

			for(int i=1; i<=numExclamations; i++) {
				text("|", 10 + (i*15), 50);
			}

			fill(100,0,255,220);
			numExclamations = floor((largestScore/1050)) * 2;
			text("|", 10 + (numExclamations*15), 50);

			largestScore = score > largestScore ? score : largestScore;
			textAlign(LEFT);
			text(largestScore, 30 + (numExclamations*15), 50 + scoreScaleJitter);

			scale(1/(1.5+scoreScaleJitter));

			fill(255, 0, 0, 220);

			float timeMillis = ofGetElapsedTimef();

			// TIME DISPLAY
			timePlayed = (timeMillis - timeStarted) / 1000.0;

			// CONVERT TO A TIME FORMAT
			//Date date = new Date((timeMillis - timeStarted));
			//DateFormat formatter = new SimpleDateFormat("mm:ss:SSS");
			//String twoPlaces = formatter.format(date);

			//text(twoPlaces, 35, 125);

		} 
		else {
			// Display score
			gameOverMenuActive = true;

			try{

				levels[currentLevel].destroy();

				for(int i=0; i<levels.length; i++) {
					levels[i].destroy();  
				}

				levels = null;

				currentLevel = 1; 
			} catch(Exception e) {
				println(e);
			}

			gameOver.draw(largestScore);

		}

		// Score slowly goes down if the player is not hitting
		if(currentLevel < 4) {
			scoreDeceleration = (int)Math.pow(timePlayed, 1.5);  
	} else {
		scoreDeceleration = (int)Math.pow(timePlayed, 1.75);  
	}

	score = (currentFrame%12) == 0 ? (score <= 0 ? 0 : score-scoreDeceleration) : score ;
	}

	currentFrame++;
}

void GameController::triggerAction(int numHits) {
}

void GameController::triggerMouseEvent() {
}
