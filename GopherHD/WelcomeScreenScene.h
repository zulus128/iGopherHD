
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class GopherPopOFDelegate;// Add for OpenFeint

// A simple define used a tag
enum {
	kTagSprite = 1,
};

#define MAX_CLOUDS 6

// WelcomeScreen Layer
@interface WelcomeScreen : CCLayer {

	GopherPopOFDelegate* ofDelegate;// Add for OpenFeint

  NSMutableArray *clouds;
  ccTime totalTime; // Total time elapsed

}

@property (nonatomic, retain) NSMutableArray *clouds;
@property (nonatomic, assign) ccTime totalTime;;

// returns a Scene that contains the WelcomeScreen as the only child
+(id) scene;
-(void) update:(ccTime) dt;

@end
