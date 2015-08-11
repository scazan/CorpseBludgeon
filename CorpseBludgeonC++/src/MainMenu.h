#pragma once

#include "Level.h"

class MainMenu: public Level {

	public:
		MainMenu();
		~MainMenu();
		void draw(int currentFrame);
		void init();
		void triggerAction(int numHits);
		void destroy();
};

