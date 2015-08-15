#ifndef GAMECONTROLLER_H
#define GAMECONTROLLER_H

#include "MainMenu.h"
#include "GameOver.h"
#include <vector>
#include <ofTrueTypeFont.h>

class Level;

class GameController {
	public:
		GameController();
		~GameController();

		int score;
		int scorePerLevel;

		bool mainMenuActive;
		bool gameOverMenuActive;

		void draw();
		void triggerAction(int numHits);
		void triggerMouseEvent();

	private:
		unsigned int currentLevel;
		int currentFrame;
		int scoreDeceleration;
		ofTrueTypeFont scoreFont;

		MainMenu *mainMenu;
		GameOver *gameOver;

		//Define the progression of levels and what objects handle them
		std::vector<Level *> levels;

		float timeStarted;
		float timePlayed;
		int largestScore;

};

#endif
