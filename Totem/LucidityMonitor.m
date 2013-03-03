//
//  LucidityMonitor.m
//  Totem
//
//  Created by Quinton Petty on 3/2/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import "LucidityMonitor.h"

#define motionPercentIncrease 100

@implementation LucidityMonitor

@synthesize x,y,z, lastAverage;

-(id)initWithSampleRateForHighPassFilter:(double)rate cutoffFrequency:(double)freq{
    if (self = [super init]) {
        filter = [[HighpassFilter alloc] initWithSampleRate:rate cutoffFrequency:freq];
        filter.adaptive = YES;
        
        lastDataPoints = [[NSMutableArray alloc] init];
        numbersToAverage = rate;
        return self;
    }
    else
        return nil;
}

-(id)initWithHighPassFilter:(HighpassFilter*)highPassFilter{
    if (self = [super init]) {
        filter = highPassFilter;
        
        lastDataPoints = [[NSMutableArray alloc] init];
        numbersToAverage = filter.sampleRate;
        return self;
    }
    else
        return self;
}

-(void)addAcceleration:(CMAcceleration)accel{
    [filter addAcceleration:accel];
    x = filter.x;
    y = filter.y;
    z = filter.z;
    [self addLastDataToArray];
}

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
            [self.delegate userIsInHightenedAwarenessState:self];
        lastAverage = average;
    }
}

@end
