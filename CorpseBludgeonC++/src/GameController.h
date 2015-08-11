#include <vector>

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
		//TYPE scoreFont;

		Level mainMenu; 
		Level gameOver;
		bool mainMenuActive;
		bool gameOverMenuActive;
		Level[] levels;

		int score;
		float timeStarted;
		float timePlayed;
		int largestScore;

}
