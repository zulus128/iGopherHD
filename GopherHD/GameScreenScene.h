// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "Constants.h"


//@class GopherPopOFDelegate;// Add for OpenFeint

// A simple define used a tag

@interface Mole : CCSprite {
  int state; // Mole state; enum
  int idnum; // Mole id
  ccTime lastCheckTime; // Unused

  ccTime currentStateSetTime; // Time when current state was set
  ccTime nextStateSetTime; // Time when new state will be set
}

-(void) pop; // When mole is poping out of the hole
-(void) hide; // When mole hides back to hole
-(void) hit; // When mole is hit

@property (nonatomic, assign) ccTime lastCheckTime;
@property (nonatomic, assign) ccTime currentStateSetTime;
@property (nonatomic, assign) ccTime nextStateSetTime;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int idnum;

@end

// GameScreen Layer
@interface GameScreen : CCLayer {
	
//	GopherPopOFDelegate* ofDelegate;// Add for OpenFeint
	
  int molesOnScreen;

  int score; // Game score
  int hits; // Hits count
  int misses; // Misses count
  int stage; // Current stage
  ccTime totalTime; // Total time elapsed
  bool isGameOver; // is Game Over?
  // bool shouldBePaused; // Should we be paused?
}

// returns a Scene that contains the GameScreen as the only child
+(id) scene;

-(void) update:(ccTime)deltaTime;
-(void) gameOver;

@property (nonatomic, assign) int molesOnScreen;

@property (nonatomic, assign) int score; // Game score
@property (nonatomic, assign) int hits; // Hits count
@property (nonatomic, assign) int misses; // Misses count
@property (nonatomic, assign) int stage; // Current stage
@property (nonatomic, assign) ccTime totalTime; // totalTime elapsed
@property (nonatomic, assign) bool isGameOver; // is Game Over?
//@property (nonatomic, assign) bool shouldBePaused; // Should we be paused?

@end
