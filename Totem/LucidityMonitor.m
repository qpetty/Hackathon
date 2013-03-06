//
//  LucidityMonitor.m
//  Totem
//
//  Created by Quinton Petty on 3/2/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import "LucidityMonitor.h"

#define motionPercentIncrease 100
#define timeWithoutMotionToDetectSleep 15

@implementation LucidityMonitor

@synthesize x,y,z, lastAverage;

-(id)initWithSampleRateForHighPassFilter:(double)rate cutoffFrequency:(double)freq{
    if (self = [super init]) {
        filter = [[HighpassFilter alloc] initWithSampleRate:rate cutoffFrequency:freq];
        filter.adaptive = YES;
        
        lastDataPoints = [[NSMutableArray alloc] init];
        awakeningNumber = 0;
        timeOfAwakenings = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble:20],[NSNumber numberWithDouble:15],[NSNumber numberWithDouble:20], [NSNumber numberWithDouble:15],[NSNumber numberWithDouble:10], nil];
        
        numbersToAverage = rate;
        userStatus = userIsAwake;
        return self;
    }
    else
        return nil;
}

-(id)initWithHighPassFilter:(HighpassFilter*)highPassFilter{
    if (self = [super init]) {
        filter = highPassFilter;
        
        lastDataPoints = [[NSMutableArray alloc] init];
        awakeningNumber = 0;
        timeOfAwakenings = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble:20],[NSNumber numberWithDouble:15],[NSNumber numberWithDouble:20], [NSNumber numberWithDouble:15],[NSNumber numberWithDouble:10], nil];
        
        numbersToAverage = filter.sampleRate;
        userStatus = userIsAwake;
        return self;
    }
    else
        return self;
}

-(void)startSleepCycle{
    timer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)timeWithoutMotionToDetectSleep target:self selector:@selector(userIsAsleep:) userInfo:nil repeats:NO];
}

-(void)userIsAsleep:(NSTimer*)theTimer{
    [timer invalidate];
    userStatus = userIsAsleep;
    NSLog(@"User is asleep");
    
    //Sets the timer for the next awakening
    if (awakeningNumber < timeOfAwakenings.count) {
        timer = [NSTimer scheduledTimerWithTimeInterval:[[timeOfAwakenings objectAtIndex:awakeningNumber] doubleValue] target:self selector:@selector(nextMovementWillAwakeUser:) userInfo:nil repeats:NO];
        awakeningNumber++;
    }
}

-(void)nextMovementWillAwakeUser:(NSTimer*)theTimer{
    NSLog(@"Next Movement should awkaen user");
    userStatus = userIsReadyToBeAwakened;
}

-(void)addAcceleration:(CMAcceleration)accel{
    [filter addAcceleration:accel];
    x = filter.x;
    y = filter.y;
    z = filter.z;
    [self addLastDataToArray];
}

//Add data point to the lastDataArray and averages all the numbers in the array if the array size reaches numbersToAverage
- (void)addLastDataToArray{
    double average = 0;
    
    [lastDataPoints addObject:[NSNumber numberWithDouble:Norm(x, y, z)]];

    if (lastDataPoints.count >= numbersToAverage) {
        for (NSNumber *num in lastDataPoints)
            average += [num doubleValue];
        average = average / lastDataPoints.count;
        [lastDataPoints removeAllObjects];
        //NSLog(@"Computed Average: %f", average);
        
        if ((average - lastAverage) / lastAverage >= motionPercentIncrease / 100)
            [self movementSensed];
        lastAverage = average;
    }
}

-(void)movementSensed{
    if (userStatus == userIsReadyToBeAwakened) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate userIsInHightenedAwarenessState:self];
            [self userIsAsleep:nil];
        });
    }
    else if (userStatus == userIsAwake){
        NSLog(@"Reset Timer");
        dispatch_async(dispatch_get_main_queue(), ^{
            [timer invalidate];
            timer = [NSTimer scheduledTimerWithTimeInterval:timeWithoutMotionToDetectSleep target:self selector:@selector(userIsAsleep:) userInfo:nil repeats:NO];
        });
    }
    else
        NSLog(@"User moved but we are not triggering yet");
}

@end
