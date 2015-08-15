#include "ConcreteLevel.h"


ConcreteLevel::ConcreteLevel() {
	musicFiles.push_back("Reflex.aif");
}

void ConcreteLevel::init() {
	backgroundMusic.init(musicFiles, true);
	bgImage.loadImage("grunge.jpg");

	//splatterController = new BloodSplatterController();
	//comboController = new ComboBreakerController();
}

void ConcreteLevel::draw(int currentFrame) {

	if(firstDraw) {
		backgroundMusic.play(0, true);
		firstDraw = false;
	}

	//tint(bgColor[0],bgColor[1],bgColor[2], 255);
	bgImage.draw( 0, 0, ofGetViewportWidth(), ofGetViewportHeight() );

	if(currentFrame % strobeFrameRate == 0) {
		//bgColor[0] = (int)random(150);
		//bgColor[1] = (int)random(255);
		//bgColor[2] = (int)random(255);
	}

	//splatterController.draw();
	//comboController.draw();

  }

int ConcreteLevel::triggerAction(int numHits) {
	//splatterController.newResponse();
	//comboController.newResponse(numHits) ;
	return numHitsThisLevel;
}

void ConcreteLevel::destroy() {
	backgroundMusic.destroy();
}

