#pragma once

#include "Level.h"
#include <string>
#include <ofGraphics.h>
#include <ofImage.h>

class GameController;
class MainMenu: public Level {

	bool firstDraw = true;
	int bgColor[3] = {50,50,50};

	GameController *gameController;
	ofImage bgImage;
	//PFont titleFont, subtitleFont;
	int red = 0;
	//AudioCollection backgroundMusic;
	//string[] musicFiles = {"Lascia.aiff"};
	std::string musicFiles[1] = {"Lascia.aiff"};

	public:
		MainMenu(GameController *controller);
		~MainMenu();
		void draw(int currentFrame);
		void init();
		void triggerAction(int numHits);
		void destroy();
};

