//
//  LucidityMonitor.h
//  Totem
//
//  Created by Quinton Petty on 3/2/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccelerometerFilter.h"

@class LucidityMonitor;

@protocol LucidityMonitorDelegate
- (void)userIsInHightenedAwarenessState:(LucidityMonitor *)monitor;
@end

typedef enum {
    userIsAwake,
    userIsAsleep,
    userIsReadyToBeAwakened
}userState;

@interface LucidityMonitor : NSObject {
    HighpassFilter *filter;
    NSTimer *timer;
    NSMutableArray *lastDataPoints;
    
    int awakeningNumber;
    NSMutableArray *timeOfAwakenings;
    
    userState userStatus;
    double x,y,z, lastAverage, numbersToAverage;
}

@property(nonatomic,readonly)double x;
@property(nonatomic,readonly)double y;
@property(nonatomic,readonly)double z;
@property(nonatomic,readonly)double lastAverage;

@property (weak, nonatomic) id <LucidityMonitorDelegate> delegate;

-(id)initWithSampleRateForHighPassFilter:(double)rate cutoffFrequency:(double)freq;
-(id)initWithHighPassFilter:(HighpassFilter*)highPassFilter;

-(void)startSleepCycle;
-(void)addAcceleration:(CMAcceleration)accel;

@end
