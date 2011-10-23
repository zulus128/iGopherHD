// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// AboutScreen Layer
@interface AboutScreen : CCLayer {
	ccTime totalTime;
}

// returns a Scene that contains the AboutScreen as the only child
+(id) scene;

@property (nonatomic, assign) ccTime totalTime;

@end
