//
//  SleepViewController.h
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "DreamViewController.h"
#import "EvernoteSDK.h"

@interface SleepViewController : UIViewController{
    CMMotionManager *motionMangager;
}

@property (weak, nonatomic) IBOutlet UILabel *xAxis;
@property (weak, nonatomic) IBOutlet UILabel *yAxis;
@property (weak, nonatomic) IBOutlet UILabel *zAxis;

- (void)sensorStateChange:(NSNotificationCenter *)notification;

@end
