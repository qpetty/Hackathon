//
//  SleepViewController.m
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import "SleepViewController.h"

@interface SleepViewController ()

@end

@implementation SleepViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Enabled monitoring of the sensor
    //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];

    // Set up an observer for proximity changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    motionMangager = [[CMMotionManager alloc] init];
    
    motionMangager.accelerometerUpdateInterval = 0.5;
    
    _xAxis.text = @"x = ";
    _yAxis.text = @"y = ";
    _zAxis.text = @"z = ";
    
    [motionMangager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        _xAxis.text = [NSString stringWithFormat:@"%@%f", _xAxis, accelerometerData.acceleration.x ];
        _yAxis.text = [NSString stringWithFormat:@"%@%f", _yAxis, accelerometerData.acceleration.y ];
        _zAxis.text = [NSString stringWithFormat:@"%@%f", _zAxis, accelerometerData.acceleration.z ];
    }];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)sensorStateChange:(NSNotificationCenter *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES)
        NSLog(@"Device is close to user.");
    else
        NSLog(@"Device is ~not~ closer to user.");
}

@end
