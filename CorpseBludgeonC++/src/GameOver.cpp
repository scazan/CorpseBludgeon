#include "GameOver.h"

GameOver::GameOver(GameController *controller) {
	gameController = controller;
	//titleFont = loadFont("Lato.vlw");
	//subtitleFont = loadFont("LatoSmall.vlw");

	musicFiles.push_back("Lascia.aiff");
	backgroundMusic.init(musicFiles, true);
	bgImage.loadImage("openingScreen.jpg");
}

GameOver::~GameOver() {
}

void GameOver::draw(int currentFrame) {
	if(firstDraw) {
		backgroundMusic.play(0, true);
		firstDraw = false;
	}

	ofBackground(255,0,0);
	//bgImage.draw(0, 0);

	//if(firstDraw) {
		//backgroundMusic.play(0, true); 
		//firstDraw = false;
		//currentFade = 255;
	//}

	//int endScore = largestScore;

	//ofBackground(5);
	//tint(currentFade,255);

	//bgImage.draw( 0, 0, width, height);
	//textFont(titleFont);
	//tint(255,255);
	//fill(150, 0, 0, -(currentFade - 255) );
	//textLeading(50);
	//textAlign(CENTER);
	//// scale(2);
	//text(largestScore, width/2, (height/2));

	//// Long timeMillis = new Long(System.currentTimeMillis());
	//Date date = new Date((long)timePlayed * 1000);
	//DateFormat formatter = new SimpleDateFormat("mm:ss:SSS");
	//String twoPlaces = formatter.format(date);

	//text(twoPlaces, width/2, (height/3) * 2);
	//// scale(1/2);
	//textAlign(LEFT);
	//currentFade--;

	//currentFade = currentFade <= 0 ? 0: currentFade; 


}

void GameOver::init() {
}

void GameOver::triggerAction(int numHits) {
	//gameController->mainMenuActive = false;
	backgroundMusic.destroy();
	firstDraw = true;
}

void GameOver::destroy() {
}
