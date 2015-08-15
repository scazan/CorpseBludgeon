#include "MainMenu.h"

MainMenu::MainMenu() {
	//titleFont = loadFont("Lato.vlw");
	//subtitleFont = loadFont("LatoSmall.vlw");

	musicFiles.push_back("Lascia.aiff");
	backgroundMusic.init(musicFiles, true);
	bgImage.loadImage("openingScreen.jpg");
}

MainMenu::~MainMenu() {
}

void MainMenu::draw(int currentFrame) {
	if(firstDraw) {
		backgroundMusic.play(0, true);
		firstDraw = false;
	}

	ofBackground(5);
	bgImage.draw( 0, 0, ofGetViewportWidth(), ofGetViewportHeight() );
}

void MainMenu::init() {
}

int MainMenu::triggerAction(int numHits) {
	cout << "trigger" << '\n';
	backgroundMusic.destroy();
	firstDraw = true;

	return 0;
}

void MainMenu::destroy() {
}
