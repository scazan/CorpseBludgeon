#include "ActionResponses.h"
#include <string>
#include <ofImage.h>
#include <vector>

class ActionResponseController {

	public:
		void draw();
		virtual void newResponse() = 0;
		virtual void init() = 0;

		AudioCollection *responseAudio;
		vector<ActionResponse *> actionResponses;

};

class BloodSplatterController: public ActionResponseController {
	std::string splatterFiles;

	public:
		vector<ofImage> splatterFrames;

		void newResponse();
		void init();
};
