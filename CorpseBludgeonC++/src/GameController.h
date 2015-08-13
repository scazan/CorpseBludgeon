#pragma once

#include <vector>
#include "MainMenu.h"
#include "GameOver.h"
#include <ofTrueTypeFont.h>

class Level;

class GameController {
	public:
		GameController();
		~GameController();

		int scorePerLevel;
		bool mainMenuActive;
		bool gameOverMenuActive;

		void draw();
		void triggerAction(int numHits);
		void triggerMouseEvent();

	private:
		int currentLevel;
		int currentFrame;
		int scoreDeceleration;
		ofTrueTypeFont scoreFont;

		MainMenu *mainMenu;
		GameOver *gameOver;

		//Define the progression of levels and what objects handle them
		std::vector<Level *> levels;

		int score;
		float timeStarted;
		float timePlayed;
		int largestScore;

};

