#include "ofApp.h"
#include "ActionResponses.h"

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

		//unsigned char * pix = splatterImage->getPixels();
		//int numPix = splatterImage->width * splatterImage->height * 4;

		//for(int i = 0; i <numPix;  i+=4){
			//pix[i] = pix[i] - brightness;
			//pix[i+1] = pix[i+1] - brightness;
			//pix[i+2] = pix[i+2] - brightness;
			//pix[i+3] = ((fadeValue/fadeDuration) *255);
		//}
		//splatterImage->update();

		//splatterImage->draw( xPos, yPos, squareSize, squareSize);

		//for(int i = 0; i <numPix;  i+=4){
			//pix[i] = pix[i] + brightness;
			//pix[i+1] = pix[i+1] + brightness;
			//pix[i+2] = pix[i+2] + brightness;
		//}

		fadeValue--;
	}
	else {
		display = false;
	}
}

BloodSplatter::~BloodSplatter() {
}
