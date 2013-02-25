//
//  TriggeredArray.h
//  Totem
//
//  Created by Quinton Petty on 2/22/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TriggeredArray;

@protocol TriggeredArrayDelegate
-(void)arrayHasBeenTriggered:(TriggeredArray*)triggerEmptyArray hitTriggerIndex:(NSMutableArray*)array;
@end

@interface TriggeredArray : NSObject {
    NSMutableArray *triggeredArray;
    int triggerIndex;
}

@property (weak, nonatomic) id <TriggeredArrayDelegate> delegate;

- (id)initWithTriggerIndex:(int)index;
- (void)addObject:(id)anObject;
@end
