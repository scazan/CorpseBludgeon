#pragma once

#include "AudioCollection.h"
#include "Level.h"
#include <string>
#include <ofGraphics.h>
#include <ofImage.h>

// Need to resolve the circular reference. Here is a stopgap.
class GameController;

class GameOver: public Level {

	bool firstDraw = true;
	int bgColor[3] = {50,50,50};

	GameController *gameController;
	ofImage bgImage;
	//PFont titleFont, subtitleFont;
	int red = 0;
	AudioCollection backgroundMusic;
	std::vector<std::string> musicFiles;

	public:
		GameOver(GameController *controller);
		~GameOver();
		void draw(int currentFrame);
		void init();
		void triggerAction(int numHits);
		void destroy();
};

