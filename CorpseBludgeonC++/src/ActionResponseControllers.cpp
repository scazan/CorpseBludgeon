#include "ActionResponseControllers.h"
#include <ofFileUtils.h>


void ActionResponseController::draw() {
	vector<int> removals;

	for(unsigned int i=0; i < actionResponses.size(); i++) {
		ActionResponse *response = actionResponses[i];

		if(response->display == false) {
			removals.push_back(i);
		}
		else {
			response->draw();
		}
	}

	for(unsigned int i=0; i < removals.size(); i++) {
		actionResponses.erase(actionResponses.begin() + removals[i]);
	}
}


void BloodSplatterController::init() {
	vector<string> sampleFiles;
	sampleFiles.push_back("coin.wav");
	sampleFiles.push_back("squash.wav");
	sampleFiles.push_back("squash2.wav");

	responseAudio = new AudioCollection();
	responseAudio->init(sampleFiles, false);

	ofDirectory splatterFiles("blood/");
	splatterFiles.listDir();

	for(int i=0; i<splatterFiles.numFiles(); i++) {
		splatterFrames.push_back(ofImage());
		splatterFrames.back().loadImage(splatterFiles.getPath(i));
	}
}

void BloodSplatterController::newResponse() {
	// TODO: Implement multiple splatters. On first conversion I had some NULL pointer issues
	//for(unsigned int i=0; i<4;i++) {
		BloodSplatter *splatter = new BloodSplatter();
		splatter->init(&splatterFrames, responseAudio);
		actionResponses.push_back( splatter );
	//}
}
