// Import the interfaces
#import "WelcomeScreenScene.h"
#import "GameScreenScene.h"
#import "StatsScreenScene.h"
#import "ScoreScreenScene.h"

// ScoreScreen implementation
@implementation ScoreScreen

@synthesize totalTime;
@synthesize scores;
@synthesize playerNameEntry;
@synthesize rank;
@synthesize screenOffset;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ScoreScreen *layer = [ScoreScreen node];
	
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
        int a = 36;
		
		CCLabelTTF* score_label = [CCLabelTTF labelWithString:@"High score" fontName:@"Marker Felt" fontSize:44];
		//score_txt_label.anchorPoint = ccp(0, 0.5);
		score_label.position = ccp(win_size.width/2, win_size.height - a);
		[self addChild: score_label z:250];

		// Scores
		scores = [[NSMutableArray alloc] initWithCapacity:10];
		[self loadScores];

		if( scores.count == 0 ) {
		  [scores addObject:[NSArray arrayWithObjects: @"Mary", [NSNumber numberWithInt: 60000], nil]];
		  [scores addObject:[NSArray arrayWithObjects: @"John", [NSNumber numberWithInt: 55000], nil]];
		  [scores addObject:[NSArray arrayWithObjects: @"Kate", [NSNumber numberWithInt: 50000], nil]];
		  [scores addObject:[NSArray arrayWithObjects: @"Eva", [NSNumber numberWithInt: 45000], nil]];
		  [scores addObject:[NSArray arrayWithObjects: @"Kevin", [NSNumber numberWithInt: 40000], nil]];
		  [scores addObject:[NSArray arrayWithObjects: @"Jane", [NSNumber numberWithInt: 35000], nil]];
		  [scores addObject:[NSArray arrayWithObjects: @"Bob", [NSNumber numberWithInt: 30000], nil]];
		  [scores addObject:[NSArray arrayWithObjects: @"Henry", [NSNumber numberWithInt: 25000], nil]];
		  [scores addObject:[NSArray arrayWithObjects: @"Lora", [NSNumber numberWithInt: 20000], nil]];
		  [scores addObject:[NSArray arrayWithObjects: @"Tom", [NSNumber numberWithInt: 15000], nil]];

		  [self saveScores];
		}

//        lastGameStats.score = 1e10;
		// Inserting new score
		rank = 0;
		for( id item in scores ) {
		  if( [[item objectAtIndex:1] intValue] < lastGameStats.score ) {
		    break;
		  };
		  rank++;
		};

//		if( rank < 3 ) {
//		  screenOffset = 0;
//		} else if( rank < 7 ) {
//		  screenOffset = 60;
//		} else if( rank < 10 ) {
//		  screenOffset = 120;
//		};

		if( lastGameStats.score > 0 ) {
		  [scores insertObject:[NSArray arrayWithObjects: @"", [NSNumber numberWithInt: lastGameStats.score], nil] atIndex:rank];
		  [self cropScores];
		}

		for(int i = 0; i < [scores count]; i++) {
		  CCLabelTTF* num_label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%2d.", i + 1] fontName:@"Marker Felt" fontSize:a];
		  num_label.anchorPoint = ccp(1, 0.5);
		  num_label.position = ccp(120 - 10, win_size.height - 58 - i * a);
		  [self addChild: num_label z:250];

		  CCLabelTTF* name_label = [CCLabelTTF labelWithString:[[scores objectAtIndex:i] objectAtIndex:0] fontName:@"Marker Felt" fontSize:a];
		  name_label.anchorPoint = ccp(0, 0.5);
		  name_label.position = ccp(120, win_size.height - 58 - i * a);
		  [self addChild: name_label z:250];

		  CCLabelTTF* score_label = [CCLabelTTF labelWithString:[[[scores objectAtIndex:i] objectAtIndex:1] stringValue] fontName:@"Marker Felt" fontSize:a];
		  score_label.anchorPoint = ccp(1, 0.5);
		  score_label.position = ccp(win_size.width - 120, win_size.height - 58 - i * a);
		  [self addChild: score_label z:250];
		}

		// Input
		if( rank < 10 && lastGameStats.score > 0 ) {
		  CGRect frame = [[[CCDirector sharedDirector] openGLView] frame];
		  playerNameEntry = [[UITextField alloc] initWithFrame:frame]; 
//		  [playerNameEntry setTransform:CGAffineTransformMakeRotation(M_PI/2)];
		  playerNameEntry.clearsOnBeginEditing = YES;
		  playerNameEntry.font = [UIFont fontWithName:@"Marker Felt" size:a];
		  playerNameEntry.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

		  // Positioning
		  CGPoint convertedOrigin = [[CCDirector sharedDirector] convertToGL:ccp(120,win_size.height - 35 - a*rank)];
		  CGPoint convertedSize = [[CCDirector sharedDirector] convertToGL:ccp(160,a)];
		  playerNameEntry.frame = CGRectMake(convertedOrigin.x, convertedOrigin.y, convertedSize.x, convertedSize.y);

		  //playerNameEntry.borderStyle = UITextBorderStyleRoundedRect;
		  playerNameEntry.delegate = self;
	
		  [[[CCDirector sharedDirector] openGLView] addSubview:playerNameEntry];

		  [playerNameEntry becomeFirstResponder];

		}
	}
	return self;
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

-(void)setPosition:(CGPoint)point {

  // Moving UITextField
  CGRect frame = playerNameEntry.frame;
  frame.origin.x = frame.origin.x - ([self position].y - point.y);
  playerNameEntry.frame = frame;

  [super setPosition:point];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  //  playerNameEntry = CGAffineTransformTranslate(playerNameEntry, 320, 0);
  //  [UIView beginAnimations:nil context:NULL];
  //  [UIView setAnimationDuration:.25f];
  //  playerNameEntry = CGAffineTransformMakeRotation(M_PI/2);
  //  [UIView commitAnimations];
  [self runAction:[CCMoveBy actionWithDuration:0.25f position:ccp(0, screenOffset)]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    [self runAction:[CCMoveBy actionWithDuration:0.25f position:ccp(0, -screenOffset)]];
//    CGRect frame = playerNameEntry.frame;
//    frame.origin.y = frame.origin.y + screenOffset;
//    playerNameEntry.frame = frame;
}

-(void) textFieldShouldReturn:(UITextField *)textField {
  //CGPoint current_position = self.position;
  //self.position = ccp(current_position.x, current_position.y - 100);
  [textField resignFirstResponder];

  [scores replaceObjectAtIndex:rank withObject:[NSArray arrayWithObjects:textField.text, [NSNumber numberWithInt: lastGameStats.score], nil]];

  [self saveScores];
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
		nextScene = NULL;
		[[CCDirector sharedDirector] replaceScene: [WelcomeScreen scene]];
	}       
}

-(void) sortScores {
  [scores sortUsingFunction:compare_scores context:NULL];
  NSArray* new_scores = [NSArray arrayWithArray: [[scores reverseObjectEnumerator] allObjects]];
  [scores removeAllObjects];
  [scores addObjectsFromArray:new_scores];
};

-(void) cropScores {
  while( [scores count] > 10 ) {
    [scores removeLastObject];
  };
};

-(void) loadScores {
  NSString *score_filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent:@"scores.plist"];

  NSString *error;
  NSData *binData = [NSData dataWithContentsOfFile:score_filename];
  if(binData) {
    NSLog(@"No error creating binary data.");
  }
        
  NSPropertyListFormat format;
  NSArray* new_scores = [NSPropertyListSerialization propertyListFromData:binData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
  [scores removeAllObjects];
  [scores addObjectsFromArray:new_scores];

  [self sortScores];
  [self cropScores];
};

-(void) saveScores {

  /*
  NSMutableArray *score_table = [NSMutableArray new];
  int i;
  for (i = 0; i < 10; i++) {
    NSMutableDictionary *record = [NSArray arrayWithObjects: @"Player", [NSNumber numberWithInt: 10 + i], nil];
    [score_table addObject:record];
  }

  [score_table addObject:[NSArray arrayWithObjects: @"Player", [NSNumber numberWithInt: 12], nil]];
  [score_table addObject:[NSArray arrayWithObjects: @"Player", [NSNumber numberWithInt: 12], nil]];
  */
  NSString *score_filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0] stringByAppendingPathComponent:@"scores.plist"];

  BOOL success = [scores writeToFile:score_filename atomically:NO];
  if (success == NO) {
    NSLog(@"failed saving the XML plist file");
  }
};

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
  // in case you have something to dealloc, do it in this method
  // in this particular example nothing needs to be released.
  // cocos2d will automatically release all the children (Label)

  //[[[CCDirector sharedDirector] openGLView] addSubview:playerNameEntry];
  [playerNameEntry removeFromSuperview];
  [playerNameEntry dealloc];
	
  // don't forget to call "super dealloc"
  [super dealloc];
}

@end

//- (void)sortUsingFunction:(NSInteger (*)(id, id, void *))compare context:(void *)context
NSInteger compare_scores(id first, id second, void *ctx) {
  int first_score = [[first objectAtIndex:1] intValue];
  int second_score = [[second objectAtIndex:1] intValue];
  if( first_score > second_score ) {
    return NSOrderedDescending;
  } else if ( first_score == second_score ) {
    return NSOrderedSame;
  } else {
    return NSOrderedAscending;
  }
};

