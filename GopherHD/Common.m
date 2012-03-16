//
//  Common.m
//  TrackRoad
//
//  Created by вадим on 7/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Common.h"
#import "AppSpecificValues.h"
//#import <GameKit/GameKit.h>

@implementation Common

@synthesize run;
@synthesize wscene;
@synthesize currentLeaderBoard;
@synthesize gameCenterManager;
@synthesize rootViewController = _rootViewController;
@synthesize finalscore;

+ (Common*) instance  {
	static Common* instance;
	@synchronized(self) {
		if(!instance) {

			instance = [[Common alloc] init];
		}
	}
	return instance;
}

- (id) init {	
	
	self = [super init];
	if(self !=nil) {

        
        self.currentLeaderBoard = kLeaderboardHighScores;
        
        if ([GameCenterManager isGameCenterAvailable]) {
            
            self.gameCenterManager = [[[GameCenterManager alloc] init] autorelease];
            [self.gameCenterManager setDelegate:self];
            [self.gameCenterManager authenticateLocalUser];
            // [self.gameCenterManager resetAchievements];
            
            /*GKLocalPlayer *localplayer = [GKLocalPlayer localPlayer];
             [localplayer authenticateWithCompletionHandler:^(NSError *error) {
             if (error) {
             NSLog(@"DISABLE GAME CENTER FEATURES / SINGLEPLAYER");
             }
             else {
             NSLog(@"ENABLE GAME CENTER FEATURES / MULTIPLAYER");
             }
             }];*/
            
        } else {
            
            NSLog(@"The current device does not support Game Center.");
            
        }

	}
	return self;	
}

- (void) processGameCenterAuth: (NSError*) error {
    
    if (error == nil) {
        
        NSLog(@"processGameCenterAuth OK");
    }
    else
        NSLog(@"processGameCenterAuth Error: %@", [error localizedDescription]);
}

- (void) registerForAuthenticationNotification {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector:@selector(authenticationChanged)
               name:GKPlayerAuthenticationDidChangeNotificationName
             object:nil];
}

- (void) authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        
        NSLog(@"Player is authenticated");
    }
    else {
        
        NSLog(@"Player is not authenticated");
    }
}

- (void) submitScore {
    
    if(self.finalscore > 0) {
        
        [self.gameCenterManager reportScore: self.finalscore forCategory: self.currentLeaderBoard];
        
        NSLog(@"Game Center submit %d score", self.finalscore);
        
    }
}

- (void) scoreReported:(NSError *)error {
    
    if(error == NULL) {

        NSLog(@"Score reported!");
    }
    else {
        
        NSLog(@"Score report failed. Reason: %@", [error localizedDescription]);
    }
}

- (void) showLeaderboard {
    
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL) {
        
        leaderboardController.category = self.currentLeaderBoard;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        [self.rootViewController presentModalViewController:leaderboardController animated:YES];
    }
    
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    
    NSLog(@"leaderboardViewControllerDidFinish");
    [viewController dismissModalViewControllerAnimated:YES];
    [[CCDirector sharedDirector] replaceScene: [WelcomeScreen scene]];

}

- (void) dealloc {
	
    self.gameCenterManager = nil;
    self.currentLeaderBoard = nil;

    [_rootViewController release];
    
	[super dealloc];
}

@end
