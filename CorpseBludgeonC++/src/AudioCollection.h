#include "ofSoundPlayer.h"

class AudioCollection {
	std::vector<ofSoundPlayer *> samples;
	
	public:
		~AudioCollection();

		void init(std::vector<std::string> sampleVector, bool looping);
		void play(int sampleNumber, bool loop);
		void stop();
		void destroy();
};
