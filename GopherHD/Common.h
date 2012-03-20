//
//  Common.h 
//  TrackRoad
//
//  Created by вадим on 7/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "WelcomeScreenScene.h"
#import "GameCenterManager.h"
#import <GameKit/GameKit.h>
//
@class RootViewController;

@interface Common : NSObject <GameCenterManagerDelegate, GKLeaderboardViewControllerDelegate> {

}

+ (Common*) instance;

- (void) showLeaderboard;
- (void) submitScore;

@property (readwrite) BOOL run;
@property (nonatomic, retain) CCScene* wscene;

@property (nonatomic, retain) RootViewController* rootViewController;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (assign, readwrite) int finalscore;

@end

