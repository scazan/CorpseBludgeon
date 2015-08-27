#include "SkullLevel.h"


SkullLevel::SkullLevel() {
	musicFiles.push_back("Reflex.aif");
}

void SkullLevel::init() {
	backgroundMusic.init(musicFiles, true);

	bgImage.push_back(new ofImage() );
	bgImage.push_back(new ofImage() );

    bgImage[0]->loadImage("gorgab.jpg");
    bgImage[1]->loadImage("ghostbox.jpg");

	splatterController.init();
	comboController.init();
	spriteControllers[0] = new SpiderSpriteController();
	//spriteControllers[1] = new FlashingSkullSpriteController();
}

void SkullLevel::draw(int currentFrame) {

	if(firstDraw) {
		backgroundMusic.play(0, true);
		firstDraw = false;
	}

	ofSetColor(255, 255, 255, alpha);
    currentImage = (int)(currentImage + 0.15) % (bgImage.size() - 1);

    int imageToShow = currentImage;

    //bgImage[imageToShow]->draw( bgScrollOffset, (int)rand()%10, ofGetViewportWidth(), ofGetViewportHeight() );
	bgImage[imageToShow]->draw( bgScrollOffset, (int)rand()%10, bgImage[imageToShow]->width, bgImage[imageToShow]->height);
	bgImage[imageToShow]->draw( bgScrollOffset+bgImage[imageToShow]->width, (int)rand()%50, bgImage[imageToShow]->width, bgImage[imageToShow]->height);
	//bgImage.draw( 0, 0, ofGetViewportWidth(), ofGetViewportHeight() );

	ofSetColor(255, 255, 255, 255);

	splatterController.draw();
	comboController.draw();

	//for(int i=0; i<spriteControllers.length; i++) {
		//spriteControllers[i].draw();
	//}

	bgScrollOffset = bgScrollOffset - bgScrollSpeed;
	if(bgScrollOffset <= (bgImage[imageToShow]->width * - 1)) {
		bgScrollOffset = 0;
	}

  }

int SkullLevel::triggerAction(int numHits) {
	splatterController.newResponse(numHits);
	comboController.newResponse(numHits) ;

	return numHitsThisLevel;
}

void SkullLevel::destroy() {
	backgroundMusic.destroy();
}

