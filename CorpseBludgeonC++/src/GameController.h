#include <vector>
#include "Level.h"
#include <ofTrueTypeFont.h>

class GameController {
	public:
		GameController();
		~GameController();

		int scorePerLevel;
		void draw();
		void triggerAction(int numHits);
		void triggerMouseEvent();

	private:
		int currentLevel;
		int currentFrame;
		int scoreDeceleration;
		ofTrueTypeFont scoreFont;

		Level mainMenu;
		//Level gameOver;
		bool mainMenuActive;
		bool gameOverMenuActive;
		std::vector<Level> levels;

		int score;
		float timeStarted;
		float timePlayed;
		int largestScore;

};

