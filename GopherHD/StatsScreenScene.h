// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#define DEXTEROUS_HUNTER @"700552" 
#define QUICK_HUNTER @"702742" 
#define THE_BEST_HUNTER_AT_GOPHERS_ @"705402" 

// StatsScreen Layer
@interface StatsScreen : CCLayer {
  ccTime totalTime;
}

// returns a Scene that contains the StatsScreen as the only child
+(id) scene;

@property (nonatomic, assign) ccTime totalTime;

@end
