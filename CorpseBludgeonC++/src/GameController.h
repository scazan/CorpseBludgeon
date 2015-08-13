#pragma once

#include <vector>
#include "MainMenu.h"
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
		//Level gameOver;
		std::vector<Level *> levels;

		int score;
		float timeStarted;
		float timePlayed;
		int largestScore;

};

