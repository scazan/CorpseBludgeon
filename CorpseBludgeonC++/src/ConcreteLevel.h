#include "AudioCollection.h"
#include "Level.h"
#include <string>
#include <ofGraphics.h>
#include <ofImage.h>


class ConcreteLevel : public Level {
	bool firstDraw = true;
	int strobeFrameRate = 3;
	int bgColor[3] = {255,255,255};
	ofImage bgImage;
	//BloodSplatterController splatterController;
	//ComboBreakerController comboController;
	AudioCollection backgroundMusic;
	std::vector<std::string> musicFiles;
	//String[] musicFiles = {"Reflex.aif"};

	public:
		ConcreteLevel();

		void init();
		void draw(int currentFrame);
		int triggerAction(int numHits);
		void destroy();
};

