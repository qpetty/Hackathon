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

int const queue_size = 30;
int const seconds_to_average = 15;
double const measurements_per_sec = 4;

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
    
    averageAccel = [[NSMutableArray alloc] init];
    motionMangager = [[CMMotionManager alloc] init];
    queue = [[NSMutableArray alloc] init];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Non, Je Ne Regrette Rien" ofType:@"mp3"];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL: newURL error: nil];
    
    threshold = 0.01;
    // Enabled monitoring of the sensor
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];

    // Set up an observer for proximity changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"sleep-586@2x.png"]];
    
    
    motionMangager.deviceMotionUpdateInterval = 1.0f / measurements_per_sec;
    NSLog(@"%lf", motionMangager.deviceMotionUpdateInterval);
    timer = 0;
    [motionMangager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        
        timer++;
        
        //if(timer > measurements_per_sec * 60 * 60){
        if(timer > 0){
            double scale = 1000;
            double xsqr = motion.userAcceleration.x * motion.userAcceleration.x * scale;
            double ysqr = motion.userAcceleration.y * motion.userAcceleration.y * scale;
            double zsqr = motion.userAcceleration.z * motion.userAcceleration.z * scale;
            
            double xyz = sqrt(xsqr * ysqr * zsqr);
            
            [averageAccel addObject:[NSNumber numberWithDouble:xyz]];
            if (averageAccel.count >= seconds_to_average / motionMangager.deviceMotionUpdateInterval){
                double average = 0;
                
                for (NSNumber *num in averageAccel)
                    average += [num doubleValue];
            
                //[queue addObject:[NSNumber numberWithDouble:average / averageAccel.count]];
                average = average / averageAccel.count;
                if(average > threshold){
                    [timeStamps addObject:[NSNumber numberWithFloat:timer]];
                    if (timeStamps.count < 3)
                        timer = 0;
                    else
                        [self wakeUp];
                }
                averageAccel = [[NSMutableArray alloc] init];
            }
            
            //if (queue.count > queue_size){
                //[queue removeObjectAtIndex:0];
                
                //Full queue
            
            //}
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _xAxis.text = [NSString stringWithFormat:@"%@%f", @"x= ", motion.userAcceleration.x ];
                _yAxis.text = [NSString stringWithFormat:@"%@%f", @"y= ", motion.userAcceleration.y ];
                _zAxis.text = [NSString stringWithFormat:@"%@%f", @"z= ", motion.userAcceleration.z ];

                _rootSumSquare.text = [NSString stringWithFormat:@"%@%f", @"root sum square= ", xyz];
                _queueSize.text = [NSString stringWithFormat:@"%d", averageAccel.count];
                NSLog(@"%@", _yAxis.text);
            });
            
        }
    }];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    if([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Power" message:@"Please keep the charger connected at night." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [motionMangager stopDeviceMotionUpdates];
    [player stop];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sensorStateChange:(NSNotificationCenter *)notification
{
    if ([[UIDevice currentDevice] proximityState] == YES)
        NSLog(@"Device is close to user.");
    else
        NSLog(@"Device is ~not~ closer to user.");
}


- (IBAction)wakeUp{
    [player prepareToPlay];
    [player setVolume: 1.0];
    //[player setDelegate: self];
    [player play];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Trigger" message:@"Attempting to Trigger Lucidity" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    [player stop];
    player.currentTime = 0;
}

@end
