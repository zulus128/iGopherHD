// Import the interfaces
#import "WelcomeScreenScene.h"
#import "GameScreenScene.h"
#import "StatsScreenScene.h"
//#import "OpenFeint.h"
//#import "OFHighScoreService.h"
//#import "OFAchievement.h"

// StatsScreen implementation
@implementation StatsScreen

@synthesize totalTime;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StatsScreen *layer = [StatsScreen node];
	
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

//		[OFHighScoreService setHighScore:lastGameStats.score   
//						  forLeaderboard:@"490563"    
//							   onSuccess:OFDelegate()    
//							   onFailure:OFDelegate()];
//
//		//[OFAchievementService unlockAchievement:DEXTEROUS_HUNTER];
//		
//		if(lastGameStats.score < 20000) {
//
//			double s = (double)lastGameStats.score / 20000 * 100;
//			NSLog(@"s=%f",s);
//			[[OFAchievement achievement:DEXTEROUS_HUNTER] updateProgressionComplete: s andShowNotification: YES];
//		
//		} else
//			if(lastGameStats.score < 40000) {
//				
//				double s = (double)(lastGameStats.score - 20000) / 20000 * 100;
//				[[OFAchievement achievement:DEXTEROUS_HUNTER] updateProgressionComplete: 100.0f andShowNotification: NO];
//				[[OFAchievement achievement:QUICK_HUNTER] updateProgressionComplete: s andShowNotification: YES];
//				
//			} else
//				{
//					
//					double s = (double)(lastGameStats.score - 40000)/ 20000 * 100;
//					if(s > 100.0f) s = 100.0f;
//					[[OFAchievement achievement:DEXTEROUS_HUNTER] updateProgressionComplete: 100.0f andShowNotification: NO];
//					[[OFAchievement achievement:QUICK_HUNTER] updateProgressionComplete: 100.0f andShowNotification: NO];
//					[[OFAchievement achievement:THE_BEST_HUNTER_AT_GOPHERS_] updateProgressionComplete: s andShowNotification: YES];
//					
//				}
//					
//		[OpenFeint launchDashboardWithHighscorePage:@"490563"]; 
	
	  // Clocks
	  [self schedule:@selector(update:)];

	  // Background
	  CCSprite* sky = [CCSprite spriteWithFile:@"sky.png"];
	  CCSprite* ground = [CCSprite spriteWithFile:@"green-bg.png"];
	  ground.anchorPoint = ccp(0, 0);
	  sky.anchorPoint = ccp(0, 0);
	  ground.position = ccp(0, 0);
	  sky.position = ccp(0, 0);
		
	  [self addChild:sky z:-2];
	  [self addChild:ground z:0];
		
	  // ask director the the window size
	  CGSize win_size = [[CCDirector sharedDirector] winSize];

	  //
	  // Sprites
	  //

	  // Sun rays
	  CCSprite* sun_rays = [CCSprite spriteWithFile:@"sun.png"];
	  sun_rays.position = ccp(150, win_size.height - 56);
		
	  [self addChild:sun_rays z:-1];
	  //id rays_repeat = [CCRepeatForever actionWithAction: [CCRotateBy actionWithDuration:15.0f angle:180]];
	  //[sun_rays runAction:rays_repeat];

	  // Black layer
	  CCLayerColor *black_layer = [CCLayerColor layerWithColor:ccc4(0,0,0,191)];
	  [self addChild:black_layer z:200];


	  // Text labels

	  CCLabelTTF* score_txt_label = [CCLabelTTF labelWithString:@"Score:" fontName:@"Marker Felt" fontSize:32];
	  score_txt_label.anchorPoint = ccp(0, 0.5);
	  score_txt_label.position = ccp(60, win_size.height - 90);
	  [self addChild: score_txt_label z:250];

	  CCLabelTTF* duration_txt_label = [CCLabelTTF labelWithString:@"Round duration:" fontName:@"Marker Felt" fontSize:32];
	  duration_txt_label.anchorPoint = ccp(0, 0.5);
	  duration_txt_label.position = ccp(60, win_size.height - 90 - 32 - 8);
	  [self addChild: duration_txt_label z:250];

	  CCLabelTTF* gophers_txt_label = [CCLabelTTF labelWithString:@"Gophers hit:" fontName:@"Marker Felt" fontSize:32];
	  gophers_txt_label.anchorPoint = ccp(0, 0.5);
	  gophers_txt_label.position = ccp(60, win_size.height - 90 - 32*2 - 8*2);
	  [self addChild: gophers_txt_label z:250];

	  // Num labels

	  CCLabelTTF* score_num_label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", lastGameStats.score] fontName:@"Marker Felt" fontSize:32];
	  score_num_label.anchorPoint = ccp(1, 0.5);
	  score_num_label.position = ccp(win_size.width - 60, win_size.height - 90);
	  [self addChild: score_num_label z:250];

	  CCLabelTTF* duration_num_label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d:%02d", (int)lastGameStats.duration / 60, (int)lastGameStats.duration % 60] fontName:@"Marker Felt" fontSize:32];
	  duration_num_label.anchorPoint = ccp(1, 0.5);
	  duration_num_label.position = ccp(win_size.width - 60, win_size.height - 90 - 32 - 8);
	  [self addChild: duration_num_label z:250];

	  CCLabelTTF* gophers_num_label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", lastGameStats.gophers_hit] fontName:@"Marker Felt" fontSize:32];
	  gophers_num_label.anchorPoint = ccp(1, 0.5);
	  gophers_num_label.position = ccp(win_size.width - 60, win_size.height - 90 - 32*2 - 8*2);
	  [self addChild: gophers_num_label z:250];

	  
	}
	return self;
}

-(void) update:(ccTime) dt {
  totalTime += dt;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if( touch ) {
	  if( totalTime < 0.5 ) {
	    return;
	  }

	  //CGPoint location = [touch locationInView: [touch view]];
		
	  // IMPORTANT:
	  // The touches are always in "portrait" coordinates. You need to convert them to your current orientation
	  //CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:location];
		
	  //CCNode *sprite = [self getChildByTag:kTagSprite];
		
	  // we stop the all running actions
	  //[sprite stopAllActions];
		
	  // and we run a new action
	  //[sprite runAction: [CCMoveTo actionWithDuration:1 position:convertedPoint]];
		
	  [[CCDirector sharedDirector] replaceScene: [nextScene scene]];
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
