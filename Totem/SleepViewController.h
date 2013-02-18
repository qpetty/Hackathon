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

FOUNDATION_EXPORT int const queue_size;
FOUNDATION_EXPORT int const seconds_to_average;
FOUNDATION_EXPORT double const measurements_per_sec;

@interface SleepViewController : UIViewController <UIAlertViewDelegate> {
    CMMotionManager *motionMangager;
    NSMutableArray *averageAccel;
    NSMutableArray *queue;
    
    NSMutableArray *timeStamps;
    
    int timer;
    
    double threshold;
    AVAudioPlayer *player;
}

@property (weak, nonatomic) IBOutlet UISlider *slide;
@property (weak, nonatomic) IBOutlet UILabel *xAxis;
@property (weak, nonatomic) IBOutlet UILabel *yAxis;
@property (weak, nonatomic) IBOutlet UILabel *zAxis;
@property (weak, nonatomic) IBOutlet UILabel *rootSumSquare;
@property (weak, nonatomic) IBOutlet UILabel *queueSize;

- (void)sensorStateChange:(NSNotificationCenter *)notification;

- (IBAction)wakeUp;

@end
