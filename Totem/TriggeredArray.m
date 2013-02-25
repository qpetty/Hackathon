//
//  TriggeredArray.m
//  Totem
//
//  Created by Quinton Petty on 2/22/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import "TriggeredArray.h"

@implementation TriggeredArray

-(id)init{
    self = [super init];
    if (self) {
        triggeredArray = [[NSMutableArray alloc] init];
        triggerIndex = 0;
    }
    return self;
}

-(id)initWithTriggerIndex:(int)index{
    self = [super init];
    if (self)
        triggeredArray = [[NSMutableArray alloc] init];
        triggerIndex = index;
    return self;
}

- (void)addObject:(id)anObject{
    [triggeredArray addObject:anObject];
    if (triggeredArray.count % 10 == 0)
        NSLog(@"Added Object, Size is %d", triggeredArray.count);
    if (triggerIndex != 0 && triggeredArray.count >= triggerIndex){
        NSLog(@"Triggered");
        [self.delegate arrayHasBeenTriggered:self hitTriggerIndex:triggeredArray];
        triggeredArray = [[NSMutableArray alloc] init];
    }
}

@end
