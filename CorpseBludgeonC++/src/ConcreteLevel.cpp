#include "ConcreteLevel.h"


ConcreteLevel::ConcreteLevel() {
	musicFiles.push_back("Reflex.aif");
}

void ConcreteLevel::init() {
	backgroundMusic.init(musicFiles, true);
	bgImage.loadImage("grunge.jpg");

	splatterController.init();
	comboController.init();
}

void ConcreteLevel::draw(int currentFrame) {

	if(firstDraw) {
		backgroundMusic.play(0, true);
		firstDraw = false;
	}

	ofSetColor(bgColor[0],bgColor[1],bgColor[2], 255);
	bgImage.draw( 0, 0, ofGetViewportWidth(), ofGetViewportHeight() );

	ofSetColor(255, 255, 255, 255);

	if(currentFrame % strobeFrameRate == 0) {
		bgColor[0] = (int)rand() % 150;
		bgColor[1] = (int)rand() % 255;
		bgColor[2] = (int)rand() % 255;
	}

	splatterController.draw();
	comboController.draw();

  }

int ConcreteLevel::triggerAction(int numHits) {
	splatterController.newResponse(numHits);
	comboController.newResponse(numHits) ;

	return numHitsThisLevel;
}

void ConcreteLevel::destroy() {
	backgroundMusic.destroy();
}

