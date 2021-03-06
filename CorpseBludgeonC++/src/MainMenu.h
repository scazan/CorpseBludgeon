#pragma once

#include "AudioCollection.h"
#include "Level.h"
#include <string>
#include <ofGraphics.h>
#include <ofImage.h>


class MainMenu: public Level {

	bool firstDraw = true;
	int bgColor[3] = {50,50,50};

	ofImage bgImage;
	//PFont titleFont, subtitleFont;
	int red = 0;
	AudioCollection backgroundMusic;
	std::vector<std::string> musicFiles;

	public:
		MainMenu();
		~MainMenu();

		void draw(int currentFrame);
		void init();
		int triggerAction(int numHits);
		void destroy();
};

