//
//  Common.m
//  TrackRoad
//
//  Created by вадим on 7/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

@implementation Common

@synthesize run;
@synthesize wscene;

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

	}
	return self;	
}


- (void) dealloc {
	
	[super dealloc];
}

@end
