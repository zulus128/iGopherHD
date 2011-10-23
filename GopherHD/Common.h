//
//  Common.h 
//  TrackRoad
//
//  Created by вадим on 7/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "WelcomeScreenScene.h"

@interface Common : NSObject {

}

+ (Common*) instance;

@property (readwrite) BOOL run;
@property (nonatomic, retain) CCScene* wscene;

@end

