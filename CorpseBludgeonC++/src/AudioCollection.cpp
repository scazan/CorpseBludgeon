#include "AudioCollection.h"

AudioCollection::~AudioCollection() {
	destroy();
}

void AudioCollection::init(std::vector<std::string> sampleVector, bool looping) {

	for(unsigned int i=0; i < sampleVector.size(); i++) {
		samples.push_back( new ofSoundPlayer() );
		samples[i]->loadSound("sound/" + sampleVector[i] );
		samples[i]->setMultiPlay(looping);
	}
}

void AudioCollection::play(int sampleNumber, bool loop) {
	if(loop) {
		samples[sampleNumber]->setLoop(loop);
	}

	samples[sampleNumber]->play();
}

void AudioCollection::stop() {
}

void AudioCollection::destroy() {
	for(unsigned int i=0; i < samples.size(); i++) {
		cout << "stoppin sound" << '\n';
		samples[i]->stop();
		samples[i]->unloadSound();
	}

	delete &samples;

}
