// Import the interfaces
#import "WelcomeScreenScene.h"
#import "GameScreenScene.h"
#import "AboutScreenScene.h"
#import "Common.h"

// AboutScreen implementation
@implementation AboutScreen

@synthesize totalTime;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AboutScreen *layer = [AboutScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
		// Clocks
		[self schedule:@selector(update:)];
		
		// Background
		CCSprite* background = [CCSprite spriteWithFile:@"about-screen.png"];
//		background.anchorPoint = ccp(0, 0);
//		background.position = ccp(0, 0);
		
		[self addChild:background z:0];
		
		// ask director the the window size
		CGSize win_size = [[CCDirector sharedDirector] winSize];
        
        background.position = ccp(win_size.width/2, win_size.height/2);

		
	}
	return self;
}

-(void) update:(ccTime) dt {
	totalTime += dt;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	int fingerSpot = 20;

	if( touch ) {
	  CGPoint location = [touch locationInView: [touch view]];
		
	  // IMPORTANT:
	  // The touches are always in "portrait" coordinates. You need to convert them to your current orientation
	  CGPoint touchPoint = [[CCDirector sharedDirector] convertToGL:location];

//        NSLog(@"x=%f, y=%f", touchPoint.x, touchPoint.y);
        
	  CGRect url_box = CGRectMake(370, 80, 300, 40);

	  CGRect finger = CGRectMake(touchPoint.x - fingerSpot/2, touchPoint.y - fingerSpot/2, fingerSpot, fingerSpot);

	  if( !CGRectIsNull( CGRectIntersection(url_box, finger) ) ) {
	    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.moslight.com"]];
	  } else {
//	    [[CCDirector sharedDirector] replaceScene: [WelcomeScreen scene]];
		  [[CCDirector sharedDirector] replaceScene: [Common instance].wscene];
	  };

	}       
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
