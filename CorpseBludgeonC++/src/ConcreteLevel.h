#include "AudioCollection.h"
#include "Level.h"
#include "ActionResponseControllers.h"

#include <string>
#include <vector>
#include <ofGraphics.h>
#include <ofImage.h>


class ConcreteLevel : public Level {
	bool firstDraw = true;
	int strobeFrameRate = 3;
	int bgColor[3] = {255,255,255};
	ofImage bgImage;
	BloodSplatterController splatterController;
	//ComboBreakerController comboController;
	AudioCollection backgroundMusic;
	vector<std::string> musicFiles;

	public:
		ConcreteLevel();

		void init();
		void draw(int currentFrame);
		int triggerAction(int numHits);
		void destroy();
};

