#include "MainMenu.h"

MainMenu::MainMenu(GameController *controller) {
	gameController = controller;
	//titleFont = loadFont("Lato.vlw");
	//subtitleFont = loadFont("LatoSmall.vlw");

	//backgroundMusic = new AudioCollection(musicFiles, true);
	bgImage.loadImage("openingScreen.jpg");
}

MainMenu::~MainMenu() {
}

void MainMenu::draw(int currentFrame) {
	if(firstDraw) { 
		//backgroundMusic.play(0, true); 
		firstDraw = false;
	}

	ofBackground(5);
	bgImage.draw(0, 0);
}

void MainMenu::init() {
}

void MainMenu::triggerAction(int numHits) {
	//gameController->mainMenuActive = false;
	//backgroundMusic.destroy();
	firstDraw = true;
}

void MainMenu::destroy() {
}
