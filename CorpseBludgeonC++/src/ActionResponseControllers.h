#ifndef ACTIONRESPONSECONTROLLERS_H
#define ACTIONRESPONSECONTROLLERS_H

#include "ActionResponses.h"
#include <string>
#include <ofImage.h>
#include <vector>

class ActionResponseController {

	public:
		void draw();
		virtual void newResponse(int numHits) = 0;
		virtual void init() = 0;

		AudioCollection *responseAudio;
		vector<ActionResponse *> actionResponses;

};

class SpriteController: public ActionResponseController {
	public:
		ofImage sprite;
		std::string spriteFileName;
		int squareSize = 100;
		int numFrames = 1;

		void init();
		void newResponse(int numHits);

};

class BloodSplatterController: public ActionResponseController {
	std::string splatterFiles;

	public:
		vector<ofImage> splatterFrames;

		void init();
		void newResponse(int numHits);
};

class ComboBreakerController: public ActionResponseController {
	public:
		void init();
		void newResponse(int numHits);
};

class SpiderSpriteController: public SpriteController {
	public:
		std::string spriteFileName = "spider.png";
		int squareSize = 40;
		int numFrames = 3;
};

#endif
