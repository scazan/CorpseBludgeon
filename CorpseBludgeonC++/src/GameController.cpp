#include "GameController.h"
#include "ConcreteLevel.h"
#include "SkullLevel.h"

#include <iostream>
#include <math.h>


GameController::GameController() {

	scorePerLevel = 200;

	currentLevel = 0;
	currentFrame = 0;
	scoreDeceleration = 800;

	//Level gameOver;
	mainMenuActive = true;
	gameOverMenuActive = false;
	score = 10;
	timePlayed = 0.0;
	largestScore = 0;

	scoreFont.loadFont("digitaldreamnarrow.ttf", 64, true, false, true);
	//scoreFont.loadFont("Cracked-64.ttf");


	mainMenu = new MainMenu();
	gameOver = new GameOver();

	std::vector<Level *> levelOrder;

	levelOrder.push_back(new ConcreteLevel() );
	levelOrder.push_back(new SkullLevel() );
    //levelOrder.push_back(new WiresLevel(controller) );
    //levelOrder.push_back(new GlitchLevel(controller) );

    //levelOrder.push_back(new BlackLevel(controller) );
    //levelOrder.push_back(new FlashingLevel(controller) );
    //levelOrder.push_back(new FireLevel(controller) );

    //levelOrder.push_back(new BieberLevel(controller) );
    //levelOrder.push_back(new SpinningBatLevel(controller) );

    //levelOrder.push_back(new ZombieLevel(controller) );
    //levelOrder.push_back(new GraveYardLevel(controller) );

    //levelOrder.push_back(new FlashingLevel(controller) );



	for(unsigned int i=0; i < levelOrder.size(); i++) {
		levels.push_back( levelOrder.at(i) );
	}

    ////default opening level and the next level initialized or fast loading
	levels.at(0)->init();
	levels.at(1)->init();

    timeStarted = ofGetElapsedTimef();
}

GameController::~GameController() {
}

void GameController::draw() {

	if(mainMenuActive) {
		mainMenu->draw(currentFrame);
	} 
	else if(gameOverMenuActive){
		gameOver->draw(largestScore);
	}
	else {

		unsigned int previousLevel = currentLevel;
		unsigned int proposedLevel = score / scorePerLevel;

		currentLevel = proposedLevel > currentLevel ? (score / scorePerLevel) : currentLevel;

		if((currentLevel <= levels.size()-1) && score > 0) {
			levels[currentLevel]->draw(currentFrame);

			if(currentLevel > previousLevel) {
				if(currentLevel < levels.size()-1) {
					levels[currentLevel + 1]->init();
					if(currentLevel > 0) {
						levels[currentLevel-1]->destroy();
						//levels[currentLevel-1] = null;
					}
				}
			}

			//// Display score
			std::string scoreText = "";
			ofSetColor(225, 0, 0, 220);
			scoreFont.setLineHeight(50);
			float scoreScaleJitter = ((float)(random() % 100))/100 * 0.05;
			ofScale(1.5 + scoreScaleJitter, 1.5 + scoreScaleJitter);

			int numExclamations = std::floor( (score/1050) )  * 2;

			for(int i=1; i<=numExclamations; i++) {
				scoreFont.drawStringAsShapes("|", 10 + (i*15), 50);
			}

			ofSetColor(100,0,255,220);
			numExclamations = std::floor((largestScore/1050)) * 2;
			scoreFont.drawStringAsShapes("|", 10 + (numExclamations*15), 50);

			largestScore = score > largestScore ? score : largestScore;
			//textAlign(LEFT);
			std::string s_largestScore = static_cast<ostringstream*>( &(ostringstream() << largestScore) )->str();
			scoreFont.drawStringAsShapes(s_largestScore, 30 + (numExclamations*15), 50 + scoreScaleJitter);

			ofScale(1/(1.5+scoreScaleJitter), 1/(1.5+scoreScaleJitter));

			ofSetColor(255, 0, 0, 220);

			float timeMillis = ofGetElapsedTimef();

			//// TIME DISPLAY
			timePlayed = (timeMillis - timeStarted) / 1000.0;

			//// CONVERT TO A TIME FORMAT
			//Date date = new Date((timeMillis - timeStarted));
			//DateFormat formatter = new SimpleDateFormat("mm:ss:SSS");
			//String twoPlaces = formatter.format(date);

			//scoreFont.drawString(twoPlaces, 35, 125);
			scoreFont.drawStringAsShapes(static_cast<ostringstream*>( &(ostringstream() << timePlayed) )->str(), 35, 125);
			//text(twoPlaces, 35, 125);

		}
		else {
			//// Display score
			gameOverMenuActive = true;

			try {

				//levels[currentLevel].destroy();

				//for(unsigned int i=0; i<levels.size(); i++) {
					//levels[i].destroy();
				//}

				//levels = null;

				currentLevel = 1;
			}
			catch (int e) {
				cout << e << '\n';
			}

			gameOver->draw(largestScore);

		}

		// Score slowly goes down if the player is not hitting
		if(currentLevel < 4) {
			scoreDeceleration = (int)std::pow(timePlayed, 1.5);
		}
		else {
			scoreDeceleration = (int)std::pow(timePlayed, 1.75);
		}

		score = (currentFrame % 12) == 0 ? (score <= 0 ? 0 : score - scoreDeceleration) : score;
	}

	currentFrame++;
}

void GameController::triggerAction(int numHits) {

	cout << "trigger gamecontroller: " <<  levels.size()-1 << mainMenuActive << gameOverMenuActive << '\n';
	if(mainMenuActive) {
		mainMenu->triggerAction(numHits);
		mainMenuActive = false;
		timeStarted = ofGetElapsedTimef();
	}
	else if(currentLevel <= levels.size()-1 && !gameOverMenuActive && !mainMenuActive) {
		numHits += 2;
		score += scorePerLevel / levels[currentLevel]->triggerAction(numHits);
	}

}

void GameController::triggerMouseEvent() {
}

