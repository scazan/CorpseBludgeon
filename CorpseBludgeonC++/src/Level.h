#ifndef LEVEL_H
#define LEVEL_H

class Level {

	public:
		Level() {};
		~Level() {};
		virtual void draw(int currentFrame) = 0;
		virtual void init() = 0;
		virtual int triggerAction(int numHits) = 0;
		virtual void destroy() = 0;

		int numHitsThisLevel = 8;
};

#endif
