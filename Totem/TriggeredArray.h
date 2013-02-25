//
//  TriggeredArray.h
//  Totem
//
//  Created by Quinton Petty on 2/22/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TriggeredArray;

//This method will be called on the delegate whenever the array reaches the trigger index and the array will be given to the delegate
//A new array will then be created for this class to use
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
