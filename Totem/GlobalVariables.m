//
//  GlobalVariables.m
//  Totem
//
//  Created by Quinton Petty on 2/19/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables

static GlobalVariables *sharedInstance = nil;

+ (GlobalVariables *)sharedInstance {
    if(sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

- (id) init{
    self = [super init];
    
    if(self){
        _PUBLISH_TO_EVERNOTE = NO;
    }
    
    return self;
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
