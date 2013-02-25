//
//  SleepViewController.h
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import "DreamViewController.h"
#import "EvernoteSDK.h"
#import "TriggeredArray.h"

#import "CorePlot-CocoaTouch.h"

FOUNDATION_EXPORT int const queue_size;
FOUNDATION_EXPORT int const seconds_to_average;
FOUNDATION_EXPORT double const measurements_per_sec;

@interface SleepViewController : UIViewController <UIAlertViewDelegate, TriggeredArrayDelegate, CPTPlotDataSource> {
    CMMotionManager *motionMangager;
    TriggeredArray *averageAccel;
    TriggeredArray *queue;
    
    NSMutableArray *allPoints;
    
    
    NSTimer *timer;
    NSMutableArray *timeStamps;
    
    double threshold;
    AVAudioPlayer *player;
}

@property (weak, nonatomic) IBOutlet UILabel *xAxis;
@property (weak, nonatomic) IBOutlet UILabel *yAxis;
@property (weak, nonatomic) IBOutlet UILabel *zAxis;
@property (weak, nonatomic) IBOutlet UILabel *rootSumSquare;
@property (weak, nonatomic) IBOutlet UILabel *queueSize;

@property (weak, nonatomic) IBOutlet CPTGraphHostingView *graphView;

- (void)initalizeGraph;
- (void)reloadGraph;

- (void)sensorStateChange:(NSNotificationCenter *)notification;

- (IBAction)wakeUp;

- (void)listenForMovement:(SleepViewController*)view;

@end
