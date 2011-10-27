// Import the interfaces
#import "GameScreenScene.h"
#import "WelcomeScreenScene.h"
#import "StatsScreenScene.h"
#import "ScoreScreenScene.h"

//#import "OpenFeint.h"
//#import "GopherPopOFDelegate.h"


// -- Mole Class --

@implementation Mole

@synthesize idnum;
@synthesize state;
@synthesize lastCheckTime;
@synthesize currentStateSetTime;
@synthesize nextStateSetTime;

-(id) init {
  if( (self=[super init] )) {

    // Constructor
    state = MS_HIDDEN;
    lastCheckTime = 0;
    currentStateSetTime = 0;
    nextStateSetTime = [(id)self.parent totalTime] + ((5 + arc4random() % 20) * 0.1);
    
    //[self schedule: @selector(action:) interval: CHECK_INTERVAL];
  }
  return self;
}

-(void) setCurrentState: (id)node data:(NSNumber *)newState {
  state = [newState intValue];
}

-(void) addMiss: (id)node {
  [(id)self.parent setMisses: [(id)self.parent misses] + 1]; // I can't do self.parent.misses += 1;

  CCLabelTTF *miss_count_label = (CCLabelTTF *)[self.parent getChildByTag:O_MISS_COUNT_LABEL];
  [miss_count_label setString:[NSString stringWithFormat:@"Misses: %d", [(id)self.parent misses]]];

  if([(id)self.parent misses] >= 10) {
    //[miss_count_label setColor:ccc3(255,0,0)];

    [(id)self.parent gameOver];
  }
}

-(void) pop {
	
	//NSLog(@"pop");

  //int stage = (int)[(id)self.parent totalTime] / (int)STAGE_INTERVAL;
  //stage = (stage > 11) ? 11 : stage;
  int stage = [(id)self.parent stage];
  if(SPEED_TABLE[stage][0] <= [(id)self.parent molesOnScreen]) {
    return;
  }

	//NSLog(@"tag=%i, stage=%i", self.tag, stage);
	if((self.tag - O_MOLE) >= HOLE_TABLE[stage])
		return;
	
  state = MS_ANIM_SHOW;
  [(id)self.parent setMolesOnScreen: [(id)self.parent molesOnScreen] + 1]; // I can't do self.parent.molesOnScreen++; Mindblowing..

  self.position = ccp( self.position.x, self.position.y - ( MOLE_OFFSET[1] - 5 ) );

  self.scale = 0.8;
  self.scaleY = 0.5;
  id action_scale = [CCSpawn actions: [CCScaleBy actionWithDuration:0.1f scale:1.2f], [CCScaleTo actionWithDuration:0.1f scaleX:1.0f scaleY:1.0f], nil];
  id action_scale_reverse = [[CCScaleBy actionWithDuration:0.1f scale:1.2f] reverse];
  id scale_sequence = [CCSequence actions: action_scale, action_scale_reverse, nil];

  id action_move = [CCMoveBy actionWithDuration:0.2f position:ccp( 0, MOLE_OFFSET[1] - 5 )];

  id spawn = [CCSpawn actions: scale_sequence, action_move, nil];

  id state_set_call = [CCCallFuncND actionWithTarget:self selector:@selector(setCurrentState:data:) data:[NSNumber numberWithInt:MS_SHOWN]];
  id full_sequence = [CCSequence actions: [CCShow action], spawn, state_set_call, nil];

  [self runAction:full_sequence];
}

-(void) hide {
  state = MS_ANIM_HIDE;
  [(id)self.parent setMolesOnScreen: [(id)self.parent molesOnScreen] - 1]; // I can't do self.parent.molesOnScreen--; Mindblowing..

  [[SimpleAudioEngine sharedEngine] playEffect:@"hide1.wav"];

  id action_scale = [CCSpawn actions: [CCScaleTo actionWithDuration:0.2f scaleX:0.8f scaleY:0.5f], [CCMoveBy actionWithDuration: 0.2f position:ccp( 0, -( MOLE_OFFSET[1] - 5 ))], nil];
  id action_move_back = [CCMoveBy actionWithDuration:0 position:ccp( 0, MOLE_OFFSET[1] - 5 )];

  id state_set_call = [CCCallFuncND actionWithTarget:self selector:@selector(setCurrentState:data:) data:[NSNumber numberWithInt:MS_HIDDEN]];
  id miss_add_count = [CCCallFuncN actionWithTarget:self selector:@selector(addMiss:)];

  id full_sequence = [CCSequence actions: action_scale, [CCHide action], action_move_back, state_set_call, miss_add_count,nil];

  [self runAction:full_sequence];
}

-(void) hit {
  state = MS_ANIM_HIT;
  [(id)self.parent setMolesOnScreen: [(id)self.parent molesOnScreen] - 1]; // I can't do self.parent.molesOnScreen--; Mindblowing..

  [(id)self.parent setHits: [(id)self.parent hits] + 1];

  [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"pop%d.wav", 1+ arc4random() % 6]]; //play a sound

  // Dust ripof
  CCSprite *dust = (CCSprite *)[self.parent getChildByTag:O_DUST + idnum];

  id rotation = [CCRotateBy actionWithDuration:0.5 angle: 90];
  id scale = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:0.5 scale:0.2] rate:2];
  id opacity = [CCEaseIn actionWithAction:[CCFadeOut actionWithDuration: 0.5] rate:2];
     
  id cw_action = [CCSpawn actions: rotation, scale, opacity, nil];
  id ccw_action = [CCSpawn actions: [rotation reverse], scale, opacity, nil];
  id restore = [CCSpawn actions: [CCRotateTo actionWithDuration:0 angle:0], [CCScaleTo actionWithDuration:0 scale:1], nil];

  if(arc4random() % 2) {
    [dust runAction: [CCSequence actions: [CCFadeIn actionWithDuration:0], [CCShow action], ccw_action, [CCHide action], restore, nil]];
  } else {
    [dust runAction: [CCSequence actions: [CCFadeIn actionWithDuration:0], [CCShow action], cw_action, [CCHide action], restore, nil]];
  }

  // Hide the Gopher
  id action = [CCSpawn actions: [CCFadeOut actionWithDuration:0.2f], [CCScaleTo actionWithDuration:0.2f scale:0.2f], nil];

  id state_set_call = [CCCallFuncND actionWithTarget:self selector:@selector(setCurrentState:data:) data:[NSNumber numberWithInt:MS_HIDDEN]];

  [self runAction: [CCSequence actions: action, [CCFadeIn actionWithDuration:0], [CCScaleTo actionWithDuration:0 scale:1.0f], [CCHide action], state_set_call, nil ]];
}

/*
-(void) action: (ccTime) dt {

  //int stage = (int)[(id)self.parent totalTime] / (int)STAGE_INTERVAL;
  //stage = (stage > 11) ? 11 : stage;
  int stage = [(id)self.parent stage];

  if( [(id)self.parent totalTime] > lastCheckTime + dt ) {
    lastCheckTime = [(id)self.parent totalTime];

    if( [(id)self.parent totalTime] > nextStateSetTime ) {
      if( state == MS_HIDDEN ) {
	[self pop];
      } else if( state == MS_SHOWN) {
	[self hide];
      }

      currentStateSetTime = [(id)self.parent totalTime];
      nextStateSetTime = [(id)self.parent totalTime] + ((float)(SPEED_TABLE[stage][1] + arc4random() % SPEED_TABLE[stage][2]) / 1000);
	
    }
  };
}
*/

-(void) tick {
	
	
	//NSLog(@"tick");
	
  id parent = (id)self.parent;
  int stage = [(id)self.parent stage];

  if( [parent totalTime] > lastCheckTime ) {
    lastCheckTime = [parent totalTime];

    if( [parent totalTime] > nextStateSetTime ) {
      if( state == MS_HIDDEN ) {
	[self pop];
      } else if( state == MS_SHOWN) {
	[self hide];
      }

      currentStateSetTime = [parent totalTime];
      nextStateSetTime = [parent totalTime] + ((float)(SPEED_TABLE[stage][1] + arc4random() % SPEED_TABLE[stage][2]) / 1000);
	
    }
  };
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc {
  // in case you have something to dealloc, do it in this method
  // in this particular example nothing needs to be released.
  // cocos2d will automatically release all the children (Label)
	
  // don't forget to call "super dealloc"
  [super dealloc];
}
@end


// -- Screen --


// GameScreen implementation
@implementation GameScreen

@synthesize molesOnScreen;

@synthesize score;
@synthesize hits;
@synthesize misses;
@synthesize stage;
@synthesize totalTime;
@synthesize isGameOver;
//@synthesize shouldBePaused;

+(id) scene
{
  // 'scene' is an autorelease object.
  CCScene *scene = [CCScene node];
	
  // 'layer' is an autorelease object.
  GameScreen *layer = [GameScreen node];
	
  // add layer as a child to scene
  [scene addChild: layer];
	
  // return the scene
  return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
  if( (self=[super init] )) {

    self.isTouchEnabled = YES;
    self.isAccelerometerEnabled = YES;

	  
	  
	  
	  
	  
	  
    // Stats reset
    lastGameStats.score = 0;
    lastGameStats.duration = 0;
    lastGameStats.gophers_hit = 0;

    // Clocks
    [self schedule:@selector(update:)];

    // set Game Over state to false
    isGameOver = NO;

    // Play music
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"game.mp3"];
 //   musicOn ? [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.6f] : NO;
		
    // Background
    CCSprite* sky = [CCSprite spriteWithFile:@"sky.png"];
    CCSprite* ground = [CCSprite spriteWithFile:@"green-bg-pause.png"];
    ground.anchorPoint = ccp(0, 0);
    sky.anchorPoint = ccp(0, 0);
    ground.position = ccp(0, 0);
    sky.position = ccp(0, 0);
		
    [self addChild:sky z:-1];
    [self addChild:ground z:0];
		
		
    // create and initialize Score label
    CCLabelTTF* score_label = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:16];
    score_label.anchorPoint = ccp(0, 1);
		
    // ask director the window size
    CGSize win_size = [[CCDirector sharedDirector] winSize];
		
    // position the label on the center of the screen
    score_label.position = ccp(12, win_size.height - 4);
		
    // add the label as a child to this Layer
    [self addChild: score_label z:12 tag:O_SCORE_LABEL];


    // Same for Miss count label
    CCLabelTTF* miss_count_label = [CCLabelTTF labelWithString:@"Misses: 0" fontName:@"Marker Felt" fontSize:16];
    miss_count_label.anchorPoint = ccp(1, 1);
    miss_count_label.position = ccp(win_size.width - 12, win_size.height - 4);
    [self addChild: miss_count_label z:12 tag:O_MISS_COUNT_LABEL];
		
    // Same for stage label
    CCLabelTTF* stage_label = [CCLabelTTF labelWithString:@"Stage: 1" fontName:@"Marker Felt" fontSize:16];
    stage_label.anchorPoint = ccp(0.5, 1);
    stage_label.position = ccp(win_size.width/2, win_size.height - 4);
    [self addChild: stage_label z:12 tag:O_STAGE_LABEL];
		
	  stage = -1;//v1
	  
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

    //
    // Sprites
    //
		
    // Sun with rays
    CCSprite* sun_rays = [CCSprite spriteWithFile:@"sun.png"];
    sun_rays.position = ccp(150, win_size.height - 56);

    [self addChild:sun_rays z:-1];

    // Sun rays animation
    id rays_repeat = [CCRepeatForever actionWithAction: [CCRotateBy actionWithDuration:15.0f angle:180]];
    [sun_rays runAction:rays_repeat];

    // Holes
    for( int i = 0; i < MOLES_TOTAL; i++ ) {
      CCSprite* hole = [CCSprite spriteWithFile:@"norr.png"];
      hole.position = ccp(HOLES_POSITIONS[i][0], HOLES_POSITIONS[i][1]);
		hole.visible = NO;//v1
      [self addChild:hole z:2 tag:O_HOLE + i];
    };

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

    // Gophers
    molesOnScreen = 0;
    for( int i = 0; i < MOLES_TOTAL; i++ ) {
      Mole* mole = [Mole spriteWithFile:@"bobrr.png"];

      mole.position = ccp(HOLES_POSITIONS[i][0] + MOLE_OFFSET[0], HOLES_POSITIONS[i][1] + MOLE_OFFSET[1]);
      //mole.opacity = 0;
      mole.idnum = i;
      [mole runAction:[CCHide action]];

      [self addChild:mole z:1 tag:O_MOLE + i];

      CCSprite* dust = [CCSprite spriteWithFile:@"shot-smoke-1.png"]; // 70x65
      dust.position = mole.position;
      //dust.scale = 0.6;
      dust.opacity = 192;
      [self addChild:dust z:10 tag:O_DUST + i];
     
      [dust runAction: [CCHide action]];

      /*
      CCNode* dust = [CCNode node];
      dust.position = mole.position;
      [self addChild:dust z:10 tag:O_DUST + i];

      CCSprite* cloud1 = [CCSprite spriteWithFile:@"shot-smoke-1.png"]; // 70x65
      cloud1.position = ccp(15,15);
      cloud1.scale = 0.6;
      cloud1.opacity = 128;
      [dust addChild:cloud1 z:0 tag:1];
      */
      
    };

  }
  return self;
}

-(void)update:(ccTime)deltaTime
{
	//NSLog(@"update");
  // Updating counters
  
	int vstage = (int)totalTime / (int)STAGE_INTERVAL;
	
	if(vstage != stage) {//v1
		//NSLog(@"vstage=%i",vstage);
		for( int i = 0; i < HOLE_TABLE[vstage]; i++ ) {
			CCSprite* hole = (CCSprite*)[self getChildByTag:O_HOLE + i];
			hole.visible = YES;//v1
		};
	}
  
	stage = (vstage > 19) ? 19 : vstage;

  // Updating HUD labels
  CCLabelTTF *stage_label = (CCLabelTTF *)[self getChildByTag:O_STAGE_LABEL];
  [stage_label setString:[NSString stringWithFormat:@"Stage: %d", stage + 1]];

  totalTime += deltaTime;

  // Ticking our gophers
  for(int i = 0; i < MOLES_TOTAL; i++) {
    Mole *targetMole = (Mole *)[self getChildByTag:O_MOLE + i];
    [targetMole tick];
  };
  
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  //int moleRadius;
  int fingerSpot = 40;
	
  if( touch ) {
    CGPoint location = [touch locationInView: [touch view]];
		
    // IMPORTANT:
    // The touches are always in "portrait" coordinates. You need to convert them to your current orientation
    CGPoint touchPoint = [[CCDirector sharedDirector] convertToGL:location];
      CGRect finger = CGRectMake(touchPoint.x - fingerSpot/2, touchPoint.y - fingerSpot/2, fingerSpot, fingerSpot);

    // Check for GameOver
    if( isGameOver ) {
      

		[[CCDirector sharedDirector] replaceScene: [StatsScreen scene]];
		[[CCDirector sharedDirector] resume];
    }

    // Music & Sound buttons
    CGRect music_off_bb = [[self getChildByTag:O_MUSIC_OFF] boundingBox];
    CGRect sound_off_bb = [[self getChildByTag:O_SOUND_OFF] boundingBox];

    if( !CGRectIsNull( CGRectIntersection(music_off_bb, finger) ) ) {
      if( musicOn ) {
	musicOn = NO;
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.0f];
	[[self getChildByTag:O_MUSIC_OFF] setVisible:YES];
      } else {
	musicOn = YES;
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.6f];
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

    // Check for pause
    CGSize win_size = [[CCDirector sharedDirector] winSize];
    CGRect pauseButton = CGRectMake(win_size.width - 60, 0, win_size.width, 60);

    //if( CGRectContainsPoint(pauseButton, touchPoint) && [[CCDirector sharedDirector] isPaused] ) {
    if( [[CCDirector sharedDirector] isPaused] && ! isGameOver ) {
      // Pause check place
      CGRect resume_box = [[[self getChildByTag:O_PAUSE_LAYER] getChildByTag:O_PAUSE_RESUME_LABEL] boundingBox];
      CGRect menu_box = [[[self getChildByTag:O_PAUSE_LAYER] getChildByTag:O_PAUSE_MENU_LABEL] boundingBox];

      //CGRect intersection = CGRectIntersection(moleBox, finger);
      //if( !CGRectIsNull(intersection) ) {

      if( !CGRectIsNull(CGRectIntersection(resume_box,finger)) ) {
	shouldBePaused = NO;
	[self removeChildByTag:O_PAUSE_LAYER cleanup:YES];
	[[CCDirector sharedDirector] resume];
	
	 //musicOn ? [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.6f] : NO;
	//[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.6f];
      } else if( !CGRectIsNull(CGRectIntersection(menu_box,finger)) ) {
	shouldBePaused = NO;
	[self removeChildByTag:O_PAUSE_LAYER cleanup:YES];
	[[CCDirector sharedDirector] resume];
	[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.6f];
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

	[[CCDirector sharedDirector] replaceScene: [WelcomeScreen scene]];
      };

      return;
    } else if(CGRectContainsPoint(pauseButton,touchPoint)) {
      shouldBePaused = YES;
      [[CCDirector sharedDirector] pause];
      CCLayerColor *pause_layer = [CCLayerColor layerWithColor:ccc4(0,0,0,127)];
      CCLabelTTF* pause_label = [CCLabelTTF labelWithString:@"Pause" fontName:@"Marker Felt" fontSize:40];
      pause_label.position = ccp(win_size.width/2, win_size.height/2 + 64);
      [pause_layer addChild:pause_label];
      CCLabelTTF* resume_label = [CCLabelTTF labelWithString:@"Resume" fontName:@"Marker Felt" fontSize:28];
      resume_label.position = ccp(win_size.width/2, win_size.height/2 - 12);
      [pause_layer addChild:resume_label z:0 tag:O_PAUSE_RESUME_LABEL];
      CCLabelTTF* menu_label = [CCLabelTTF labelWithString:@"To Main Menu" fontName:@"Marker Felt" fontSize:26];
      menu_label.position = ccp(win_size.width/2, win_size.height/2 - 64);
      [pause_layer addChild:menu_label z:0 tag:O_PAUSE_MENU_LABEL];
      [self addChild:pause_layer z:250 tag:O_PAUSE_LAYER];
//      musicOn ? [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.3f] : NO;
      return;
    };    

    for(int i = 0; i < MOLES_TOTAL; i++) {
      Mole *targetMole = (Mole *)[self getChildByTag:O_MOLE + i];
      CGRect moleBox = [targetMole boundingBox];

      //moleRadius = sqrt( moleSize.size.width * moleSize.size.width + moleSize.size.height * moleSize.size.height ) / 2;
      //float molePosition[2] = { HOLES_POSITIONS[i][0] + MOLE_OFFSET[0], HOLES_POSITIONS[i][1] + MOLE_OFFSET[1] };
      //printf("#%.2d - moleSize: %3dx%3d  moleRadius: %d\n", i, (int)moleSize.size.width, (int)moleSize.size.height, moleRadius);
      //distance = sqrt( (molePosition[0] + touchPoint.x) * (molePosition[0] + touchPoint.x) + (molePosition[1] + touchPoint.y) * (molePosition[1] + touchPoint.y) );
      
      //if((HOLES_POSITIONS[i][0] - moleSize.size.width/2 - fingerSpot/2 + MOLE_OFFSET[0] < touchPoint.x) && (HOLES_POSITIONS[i][0] + moleSize.size.width/2 + fingerSpot/2 + MOLE_OFFSET[0] > touchPoint.x)) {
      //if((HOLES_POSITIONS[i][1] - moleSize.size.height/2 - fingerSpot/2 + MOLE_OFFSET[1] < touchPoint.y) && (HOLES_POSITIONS[i][1] + moleSize.size.height/2 + fingerSpot/2 + MOLE_OFFSET[1] > touchPoint.y)) {
      CGRect intersection = CGRectIntersection(moleBox, finger);

      if( !CGRectIsNull(intersection) ) {

	/*
	printf("--------------------------------------\n");
	printf("MOLE: x: %d, y: %d, w: %d, h: %d\n", (int)moleBox.origin.x, (int)moleBox.origin.y, (int)moleBox.size.width, (int)moleBox.size.height);
	printf("FING: x: %d, y: %d, w: %d, h: %d\n", (int)finger.origin.x, (int)finger.origin.y, (int)finger.size.width, (int)finger.size.height);
	printf("INTR: x: %d, y: %d, w: %d, h: %d\n", (int)intersection.origin.x, (int)intersection.origin.y, (int)intersection.size.width, (int)intersection.size.height);
	*/

	  if(targetMole.state != MS_HIDDEN) {
	    [targetMole hit];

	    // This code must go to Mole class!!! :
	    double full_part = targetMole.nextStateSetTime - targetMole.currentStateSetTime;
	    double cur_part = totalTime - targetMole.currentStateSetTime;
	    int bonus = (int)(cur_part / (full_part / 100));
	    bonus = (bonus < 0) ? 0 : bonus;
	    bonus = (bonus > 100) ? 100 : bonus;

	    score += 50 + bonus;

	    CCLabelTTF *score_label = (CCLabelTTF *)[self getChildByTag:O_SCORE_LABEL];

	    [score_label setString:[NSString stringWithFormat:@"Score: %d", score]];
	  };
      }
	  //};
	  //};
    };
		
  }       
}

// Setting Game Over overlay
- (void) gameOver
{
  isGameOver = YES;
  [[SimpleAudioEngine sharedEngine] unloadEffect:@"hide1.wav"];
  [[CCDirector sharedDirector] pause];
  [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
  CGSize win_size = [[CCDirector sharedDirector] winSize];
  CCLayerColor *gameover_layer = [CCLayerColor layerWithColor:ccc4(0,0,0,127)];
  CCLabelTTF *gameover_label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:32*4];
  gameover_label.position = ccp(win_size.width/2, win_size.height/2 + 16*4);
  [gameover_layer addChild:gameover_label];
  CCLabelTTF* tap_label = [CCLabelTTF labelWithString:@"Tap to continue" fontName:@"Marker Felt" fontSize:24*4];
  tap_label.position = ccp(win_size.width/2, win_size.height/2 - 12*4);
  [gameover_layer addChild:tap_label];
  [self addChild:gameover_layer z:1000 tag:O_GAMEOVER_LAYER];

  lastGameStats.score = score;
  lastGameStats.duration = (double)totalTime;
  lastGameStats.gophers_hit = hits;
  nextScene = [ScoreScreen class];
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
