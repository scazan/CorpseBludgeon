#ifndef ACTIONRESPONSE_H
#define ACTIONRESPONSE_H

#include "AudioCollection.h"
#include <vector>
#include <ofImage.h>
#include <ofTrueTypeFont.h>

class ActionResponse {
	public:
		int currentFrame = 0;
		int xPos, yPos;
		float fadeDuration = 0;
		float fadeValue = 0;
		int brightness = 255;
		bool display = true;

		virtual void draw() = 0;
};

class Sprite: public ActionResponse {
	public:
		ofImage *sprite;
		int randomFrame = 0;
		int squareSize = 100;
		int numFrames = 4;
		int currentFrame = 1;
		float speed = 0.25;
		float imageScale = 1;

		void init(ofImage *passedSprite, int spriteSize, int spriteFrames);
		void draw();

};

class BloodSplatter: public ActionResponse {
	vector<ofImage> *splatterFrames;
	int randomFrame = 0;
	int squareSize = 100;
	ofImage *splatterImage;

	public:
		~BloodSplatter();
		void init(vector<ofImage> *frames, AudioCollection *responseAudio);
		void draw();
};

class ComboBreaker: public ActionResponse {
	ofTrueTypeFont font;
	int comboNumber;

	public:
		~ComboBreaker();
		void init(int numHits, AudioCollection *responseAudio);
		void draw();
};

#endif
