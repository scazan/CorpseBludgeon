#include "AudioCollection.h"
#include <vector>
#include <ofImage.h>

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
