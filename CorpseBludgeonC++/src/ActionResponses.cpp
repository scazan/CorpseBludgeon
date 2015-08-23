#include "ActionResponses.h"

void BloodSplatter::init(vector<ofImage> frames, AudioCollection *responseAudio) {
	//xPos = (int)random(width);
	//yPos = (int)random(height);
	fadeDuration = 120.f;
	fadeValue = fadeDuration;

	splatterFrames = frames;

	//randomFrame = (int) random(splatterFrames.length);
	//squareSize = (int)random(200,width/2);
	//brightness = (int)random(150,255);

	//// AUDIO HAPPENS IMMEDIATELY AND ONCE
	//// The use of index numbers here implies tight coupling with the Controller class :(
	responseAudio->play(0,false);
	//if(random(0,3) < 1) {
		//if(random(0,3) < 1) {
			//responseAudio->play(1,false);
		//}
		//else {
			//responseAudio->play(2,false);
		//}
	//}

}

void BloodSplatter::draw() {
	if(fadeValue > 0.f) {
		//tint(brightness, ((fadeValue/fadeDuration) *255));
		//ofImage(splatterFrames[randomFrame], xPos, yPos, squareSize, squareSize);

		fadeValue--;
	}
	else {
		display = false;
	}
}
