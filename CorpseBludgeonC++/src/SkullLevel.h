#include "AudioCollection.h"
#include "Level.h"
#include "ActionResponseControllers.h"

#include <string>
#include <vector>
#include <ofGraphics.h>
#include <ofImage.h>


class SkullLevel : public Level {
	bool firstDraw = true;
	int strobeFrameRate = 3;
	int bgColor[3] = {255,255,255};
	//ofImage bgImage[2];
	std::vector<ofImage *> bgImage;
	int bgScrollOffset = 0;
	int bgScrollSpeed = 0;

	float rotation = 0;
	float currentImage = 0;

	int alpha = 255;

	BloodSplatterController splatterController;
	ComboBreakerController comboController;
	std::vector<SpriteController *> spriteControllers;
	SpiderSpriteController spiderController;
	//SpriteController[] spriteControllers = new SpriteController[2];
	AudioCollection backgroundMusic;
	vector<std::string> musicFiles;

	public:
		SkullLevel();

		void init();
		void draw(int currentFrame);
		int triggerAction(int numHits);
		void destroy();
};

