#include "ofApp.h"
#include "ActionResponses.h"

void Sprite::init(ofImage *passedSprite, int spriteSize, int spriteFrames) {
	int width = ofGetScreenWidth(),
		height = ofGetScreenHeight();

	xPos = (int)rand() % width;
	yPos = (int)rand() % height;
	fadeDuration = 50;
	fadeValue = fadeDuration;
	squareSize = spriteSize;
	numFrames = spriteFrames;

	sprite = passedSprite;
	brightness = ((int)rand() % (255-150)) + 150;
	imageScale = ((int)rand() % (3-1)) + 1;
}

void Sprite::draw() {
	//ofImage imageFrame;
	//sprite->drawSubSection(Math.round(currentFrame) * (squareSize - 1), 0, squareSize -1, squareSize-1);

	if(fadeValue > 0) {
		ofSetColor(brightness, brightness, brightness, ((fadeValue/fadeDuration) *255));
		ofScale(imageScale, imageScale);

		sprite->drawSubsection(xPos, yPos, squareSize-1, squareSize-1, currentFrame * (squareSize - 1), 0);

		ofScale(1/imageScale, 1/imageScale);

		fadeValue--;
	}
	else {
		display = false;
	}

	currentFrame = (int)(currentFrame + speed) % (numFrames - 1);
}

void BloodSplatter::init(vector<ofImage> *frames, AudioCollection *responseAudio) {
	// TODO: Constrain this properly to window
	int width = ofGetScreenWidth(),
		height = ofGetScreenHeight();

	xPos = (rand() % (int)(width));
	yPos = (rand() % (int)(height));
	fadeDuration = 120.f;
	fadeValue = fadeDuration;

	splatterFrames = frames;
	randomFrame = ( rand() % (int)(splatterFrames->size()-1) );
	squareSize = ( rand() % (width/2) ) + 200;
	//squareSize = (int)random(200,width/2);
	brightness = (rand() % (255 - 150));
	//brightness = (int)random(150,255);

	//// AUDIO HAPPENS IMMEDIATELY AND ONCE
	//// The use of index numbers here implies tight coupling with the Controller class :(
	responseAudio->play(0,false);
	if((rand() % 3) < 1) {
		if((rand() % 3) < 1) {
			responseAudio->play(1,false);
		}
		else {
			responseAudio->play(2,false);
		}
	}

	splatterImage = &(splatterFrames->at(randomFrame));
}

void BloodSplatter::draw() {
	if(fadeValue > 0.f) {
		ofEnableAlphaBlending();

		ofSetColor(255, 255, 255, ((fadeValue/fadeDuration) *255) );
		splatterImage->draw( xPos, yPos, squareSize, squareSize);

		ofDisableAlphaBlending();

		fadeValue--;
	}
	else {
		display = false;
	}
}

BloodSplatter::~BloodSplatter() {
}

void ComboBreaker::init(int numHits, AudioCollection *responseAudio) {
	// TODO: Constrain this properly to window
	int width = ofGetScreenWidth(),
		height = ofGetScreenHeight();

	xPos = (rand() % (int)(width));
	yPos = (rand() % (int)(height));
	fadeDuration = 25.f;
	fadeValue = fadeDuration;

	comboNumber = numHits;
	// TODO: Temporary font until I find new version of Cracked-64
	font.loadFont("digitaldreamnarrow.ttf", 64, true, false, true);

	responseAudio->play(0,false);
}

void ComboBreaker::draw() {
	std::string s_comboNumber = static_cast<ostringstream*>( &(ostringstream() << comboNumber) )->str();
	std::string message = s_comboNumber + " IN A ROW!!!";

	if(comboNumber > 3) {
		message += '\n';
	}

	if(comboNumber > 10) {
		message += "DOUBLE";
	}

	if(comboNumber > 3) {
		message += " SUPER";
	}

	if(comboNumber > 6) {
		message += " MEGA";
	}

	if(comboNumber > 10) {
		message += " ULTIMATE";
	}

	message += " COMBO";

	if(comboNumber > 3) {
		message += " BREAKER";
	}

	message += "!!!!!!!";

	if(fadeValue > 0) {
		ofImage backImage;
		backImage.loadImage("psycho2.png");

		ofEnableAlphaBlending();
		ofSetColor(comboNumber * 50 %255, (int)rand() % 200, comboNumber * 25, ((fadeValue/fadeDuration) *200) );
		backImage.draw(xPos+50, yPos-50);
		font.setLineHeight(50);
		ofSetColor(comboNumber * 50 %255, (int)rand() % 200, comboNumber * 25, ((fadeValue/fadeDuration) *255) );
		font.drawStringAsShapes(message, xPos, yPos);

		ofSetColor(255,255);
		fadeValue--;
	}
	else {
		display = false;
	}
}
