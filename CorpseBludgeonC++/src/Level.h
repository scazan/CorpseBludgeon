
class Level {
	int numHitsThisLevel = 8;

	public:
		Level();
		~Level();
		virtual void draw(int currentFrame) = 0;
		virtual void init() = 0;
		virtual void triggerAction(int numHits) = 0;
		virtual void destroy() = 0;
};

