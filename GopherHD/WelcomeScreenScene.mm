// Import the interfaces
#import "WelcomeScreenScene.h"
#import "GameScreenScene.h"
#import "StatsScreenScene.h"
#import "ScoreScreenScene.h"
#import "AboutScreenScene.h"
//#import "OpenFeint.h"
//#import "GopherPopOFDelegate.h"
#import "Common.h"

// WelcomeScreen implementation
@implementation WelcomeScreen

@synthesize clouds;
@synthesize totalTime;

+(id) scene
{

//	static CCScene* sce;
//	@synchronized(self) {
//		if(!sce) {
			
			CCScene* sce = [CCScene node];
			
			// 'layer' is an autorelease object.
			WelcomeScreen *layer = [WelcomeScreen node];
			
			// add layer as a child to scene
			[sce addChild: layer];
//		}
//	}
  return sce;
}

// on "init" you need to initialize your instance
-(id) init
{
  // always call "super" init
  // Apple recommends to re-assign "self" with the "super" return value
  if( (self=[super init] )) {

	//  NSLog(@"INIT");
	  
	  if(![Common instance].run) {
		  
		  [Common instance].run = YES;
          
//	  NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight], OpenFeintSettingDashboardOrientation, [NSNumber numberWithBool:YES],
//								
//								OpenFeintSettingDisableUserGeneratedContent, nil];
//	  
//	  ofDelegate = [GopherPopOFDelegate new];
//	  
//	  OFDelegatesContainer* delegates = [OFDelegatesContainer containerWithOpenFeintDelegate:ofDelegate];
//	  
//	  [OpenFeint initializeWithProductKey:@"2U7aO5t89BuLl6OkM6P4Rw"
//	   
//								andSecret:@"uFUwvEHA89F3aO7FbINaeySOXkQeVhi5M2AsHjCb5XI"
//	   
//						   andDisplayName:@"GopherPop"
//	   
//							  andSettings:settings    // see OpenFeintSettings.h
//	   
//							 andDelegates:delegates]; // see OFDelegatesContainer.h
	  
	  }
	  
    // Prevent flicker
    /*
    CCSprite *sprite = [[CCSprite spriteWithFile:@"Default.png"] retain];
    sprite.rotation = 90;
    sprite.anchorPoint = CGPointZero;
    sprite.position = CGPointZero;
    [self addChild:sprite z:500];
    [sprite runAction:[CCFadeOut actionWithDuration:0.5]];
    */

    self.clouds = [NSMutableArray arrayWithCapacity:MAX_CLOUDS];
	  
    self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;

    // Reseting scores
    lastGameStats.score = 0;
    lastGameStats.duration = (double)0.0f;
    lastGameStats.gophers_hit = 0;

    // Preload sound
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"pop1.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"pop2.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"pop3.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"pop4.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"pop5.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"pop6.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"hide1.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"show1.wav"];

    // Preload music
    //[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"title.mp3"];
    //[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"game.mp3"];

    if( [[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] ) {
      NSLog(@"It is playing");
    } else {
      NSLog(@"It is not playing");
      [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"title.mp3"];
    };
	  
    // Background
    CCSprite* sky = [CCSprite spriteWithFile:@"sky.png"];
    CCSprite* ground = [CCSprite spriteWithFile:@"green-bg.png"];
    ground.anchorPoint = ccp(0, 0);
    sky.anchorPoint = ccp(0, 0);
    ground.position = ccp(0, 0);
    sky.position = ccp(0, 0);
		
    [self addChild:sky z:-5];
    [self addChild:ground z:0];

    // ask director the the window size
    CGSize win_size = [[CCDirector sharedDirector] winSize];
	
    // Text logo
    CCSprite* text_logo = [CCSprite spriteWithFile:@"logo.png"];
    text_logo.position = ccp(512, 550);
    [self addChild:text_logo z:100];

    // create and initialize "Tap to Start" label
    //CCLabel* tap_label = [CCLabel labelWithString:@"Tap to Start" fontName:@"Marker Felt" fontSize:48];
    //tap_label.position =  ccp( win_size.width /2 , win_size.height/2 - 64 );
    //[self addChild: tap_label];
    CCSprite* start_label = [CCSprite spriteWithFile:@"but-start.png"];
    start_label.position = ccp( 512, 250 );
    [self addChild:start_label z:100 tag:O_WEL_START_LABEL];

    CCSprite* score_label = [CCSprite spriteWithFile:@"but-score.png"];
    score_label.position = ccp( 512, 150 );
    [self addChild:score_label z:100 tag:O_WEL_SCORE_LABEL];

    CCSprite* about_label = [CCSprite spriteWithFile:@"but-about.png"];
    about_label.position = ccp( 512, 60 );
    [self addChild:about_label z:100 tag:O_WEL_ABOUT_LABEL];

    // Music & Sound buttons
    CCSprite* music_icon = [CCSprite spriteWithFile:@"music-on.png"];
    music_icon.position = MUSIC_POS;
    [self addChild:music_icon z:900];

    CCSprite* sound_icon = [CCSprite spriteWithFile:@"sound-on.png"];
    sound_icon.position = SOUND_POS;
    [self addChild:sound_icon z:900];

    CCSprite* music_off = [CCSprite spriteWithFile:@"toggler.png"];
    music_off.position = MUSIC_POS;
    music_off.visible = musicOn ? NO : YES;
    [self addChild:music_off z:900 tag:O_MUSIC_OFF];

    CCSprite* sound_off = [CCSprite spriteWithFile:@"toggler.png"];
    sound_off.position = SOUND_POS;
    sound_off.visible = soundOn ? NO : YES;
    [self addChild:sound_off z:900 tag:O_SOUND_OFF];

    //CCLabel* random_label = [CCLabel labelWithString:[NSString stringWithFormat:@"%d", 1 + random() % 3] fontName:@"Marker Felt" fontSize:16];
    //random_label.position = ccp( win_size.width / 2, win_size.height/2 - 82 );
    //[self addChild: random_label];

    /*
    id blink = [CCFadeOut actionWithDuration:0.8];
    id sequence = [CCSequence actions: blink, [blink reverse], nil];
    id repeat = [CCRepeatForever actionWithAction: sequence];
    */
    /*
      id action_scale = [CCScaleBy actionWithDuration:3.0f scale:2.5f];
      id action_scale_reverse = [action_scale reverse];
      id sequence = [CCSequence actions: action_scale, action_scale_reverse, nil];
      id repeat = [CCRepeat actionWithAction: sequence times:3];
    */

    //[start_label runAction:repeat];

    //
    // Sprites
    //

    // Sun
    //CCSprite* sun = [CCSprite spriteWithFile:@"sun-body.png"];
    //sun.position = ccp(80, win_size.height - 30);

    //[self addChild:sun z:-1];

    // Sun rays
    CCSprite* sun_rays = [CCSprite spriteWithFile:@"sun.png"];
    sun_rays.position = ccp(150, win_size.height - 56);

    [self addChild:sun_rays z:-3];

    // Sun rays animation
    id rays_repeat = [CCRepeatForever actionWithAction: [CCRotateBy actionWithDuration:15.0f angle:180]];
    [sun_rays runAction:rays_repeat];

    // Clouds
    int start_position = -50;
    int end_position = win_size.width + 50;
    int length = abs(start_position) + abs(end_position);

    for(int i = 1; i <= 2; i++) {
      float flight_duration = 64 + pow(-1,i)*16;
      flight_duration = 64;

      for(int j = 1; j <= MAX_CLOUDS; j++) {
	int height = win_size.height - 70 + (40 * (i - 1)) + (arc4random() % 16);

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

    // mainLoop
    [self schedule:@selector(update:)];

  }
  return self;
}

-(void) cloudRepeat:(CCNode *)aNode {
  
}

-(void) update:(ccTime) dt {
  totalTime += dt;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

  UITouch *touch = [touches anyObject];

  int fingerSpot = 20;

  if( touch ) {
    /* if( totalTime < 1 ) {
      return;
      } */
    CGPoint location = [touch locationInView: [touch view]];
 
    // IMPORTANT:
    // The touches are always in "portrait" coordinates. You need to convert them to your current orientation
    CGPoint touchPoint = [[CCDirector sharedDirector] convertToGL:location];
 
    //CCNode *start_label = [self getChildByTag:O_WEL_START_LABEL];
    //CCNode *score_label = [self getChildByTag:O_WEL_SCORE_LABEL];
    //CCNode *about_label = [self getChildByTag:O_WEL_ABOUT_LABEL];

    CGRect start_label_bb = [[self getChildByTag:O_WEL_START_LABEL] boundingBox];
    CGRect score_label_bb = [[self getChildByTag:O_WEL_SCORE_LABEL] boundingBox];
    CGRect about_label_bb = [[self getChildByTag:O_WEL_ABOUT_LABEL] boundingBox];

    // Music & Sound buttons
    CGRect music_off_bb = [[self getChildByTag:O_MUSIC_OFF] boundingBox];
    CGRect sound_off_bb = [[self getChildByTag:O_SOUND_OFF] boundingBox];

    CGRect finger = CGRectMake(touchPoint.x - fingerSpot/2, touchPoint.y - fingerSpot/2, fingerSpot, fingerSpot);

    if( !CGRectIsNull( CGRectIntersection(start_label_bb, finger) ) ) {
      [[CCDirector sharedDirector] replaceScene: [GameScreen scene]];
    };
    if( !CGRectIsNull( CGRectIntersection(score_label_bb, finger) ) ) {
      [[CCDirector sharedDirector] replaceScene: [ScoreScreen scene]];
//		if (ofDelegate)
//			[OpenFeint launchDashboard];
    };
    if( !CGRectIsNull( CGRectIntersection(about_label_bb, finger) ) ) {
      [[CCDirector sharedDirector] replaceScene: [AboutScreen scene]];
    };

    // Music & Sound
    if( !CGRectIsNull( CGRectIntersection(music_off_bb, finger) ) ) {
      if( musicOn ) {
	musicOn = NO;
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
	[[self getChildByTag:O_MUSIC_OFF] setVisible:YES];
      } else {
	musicOn = YES;
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:1.0f];
	[[self getChildByTag:O_MUSIC_OFF] setVisible:NO];
      }
    };
    if( !CGRectIsNull( CGRectIntersection(sound_off_bb, finger) ) ) {
      if( soundOn ) {
	soundOn = NO;
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0f];
	[[self getChildByTag:O_SOUND_OFF] setVisible:YES];
      } else {
	soundOn = YES;
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0f];
	[[self getChildByTag:O_SOUND_OFF] setVisible:NO];
      }
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
