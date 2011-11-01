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
		CCSprite* background = [CCSprite spriteWithFile:@"green-bg.png"];
//		background.anchorPoint = ccp(0, 0);
//		background.position = ccp(0, 0);
		
		[self addChild:background z:0];
		
		// ask director the the window size
		CGSize win_size = [[CCDirector sharedDirector] winSize];
        
        background.position = ccp(win_size.width/2, win_size.height/2);

        CCSprite* background1 = [CCSprite spriteWithFile:@"about-screen.png"];
        background1.position = ccp(win_size.width/2, win_size.height/2);
        background1.scale = 0.87f;

		[self addChild:background1 z:10];

        // Clouds
        int start_position = -50;
        int end_position = win_size.width + 50;
        int length = abs(start_position) + abs(end_position);

        for(int i = 1; i <= 2; i++) {
            float flight_duration = 64 + pow(-1,i)*16;
            flight_duration = 64;
      
        for(int j = 1; j <= MAX_CLOUDS; j++) {
            int height = win_size.height - 140 + (80 * (i - 1)) + (arc4random() % 16);
            
            CCSprite *cloud = [CCSprite spriteWithFile:[NSString stringWithFormat:@"cloud%d.png", 1 + arc4random() % 4]];
            float path = 1.0/MAX_CLOUDS * j;
            int offset = i % 2 ? 0 : 40;
            cloud.position = ccp(start_position + offset + length * path, height);
            cloud.opacity = 192;
            
            id first_transition = [CCMoveTo actionWithDuration:(flight_duration - flight_duration * path - (flight_duration/(float)length * offset)) position:ccp(end_position, height)];
            id rest_transition = [CCMoveTo actionWithDuration:(flight_duration) position:ccp(end_position, height)];
            id reset_position = [CCPlace actionWithPosition: ccp(start_position, height)];
            
            id repeater = [CCRepeat actionWithAction: [CCSequence actions: reset_position, rest_transition, nil] times: 65536];
            
            [self addChild:cloud z:-1];
            [cloud runAction:[CCSequence actions: first_transition, repeater, nil]];
        }
    }

		
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

       NSLog(@"x=%f, y=%f", touchPoint.x, touchPoint.y);
        
	  CGRect url_box = CGRectMake(370, 120, 300, 40);

	  CGRect finger = CGRectMake(touchPoint.x - fingerSpot/2, touchPoint.y - fingerSpot/2, fingerSpot, fingerSpot);

	  if( !CGRectIsNull( CGRectIntersection(url_box, finger) ) ) {
	    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.moslight.com"]];
	  } else {
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
