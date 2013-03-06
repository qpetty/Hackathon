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
double const measurements_per_sec = 15.0;
//double const measurements_per_sec = 60.0;

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

    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"sleep-586@2x.png"]];
    
    //Initialize sound
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Non, Je Ne Regrette Rien" ofType:@"mp3"];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL: newURL error: nil];
    alert = nil;
    
    // Enabled monitoring of the proximity sensor
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];

    // Set up an observer for proximity changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    
    //Initialize Accelerometer
    double sampleRate = 1.0f / measurements_per_sec;
    motionMangager = [[CMMotionManager alloc] init];
    monitor = [[LucidityMonitor alloc] initWithSampleRateForHighPassFilter:measurements_per_sec cutoffFrequency:5.0];
    monitor.delegate = self;
    [monitor startSleepCycle];
    
    //TODO: move all accelerometer info to Lucidity Monitor
    motionMangager.deviceMotionUpdateInterval = sampleRate;
    NSLog(@"Motion Update Interval: %lf", motionMangager.deviceMotionUpdateInterval);
    
    counter = 0;
    allPoints = [[NSMutableArray alloc] init];
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(listenForMovement:) userInfo:nil repeats:NO];
    
    [self listenForMovement:self];
    [self initalizeGraph];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    if([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged){
        UIAlertView *batteryAlert = [[UIAlertView alloc] initWithTitle:@"Power" message:@"Please keep the charger connected at night." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [batteryAlert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [motionMangager stopDeviceMotionUpdates];
    [player stop];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)awake:(id)sender {
    
    if ([[GlobalVariables sharedInstance] PUBLISH_TO_EVERNOTE]) {
        DreamViewController *next = [[self storyboard] instantiateViewControllerWithIdentifier:@"DreamInput"];
        [next setGraphView:_graphView];
        [next setAccelData:allPoints];
        [[self navigationController] pushViewController:next animated:YES];
    }
    else
        [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)sensorStateChange:(NSNotificationCenter *)notification {
    if ([[UIDevice currentDevice] proximityState] == YES)
        NSLog(@"Device is close to user.");
    else
        NSLog(@"Device is ~not~ closer to user.");
}

- (void)userIsInHightenedAwarenessState:(LucidityMonitor *)monitor{
    NSLog(@"Felt something");
    [self wakeUp];
}

- (IBAction)wakeUp{
    [player prepareToPlay];
    [player setVolume: 1.0];
    [player setDelegate: self];
    [player play];

    alert = [[UIAlertView alloc] initWithTitle:@"Trigger" message:@"Attempting to Trigger Lucidity" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    [player stop];
    player.currentTime = 0;
    alert = nil;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)listenForMovement:(SleepViewController*)view {
    [motionMangager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        
        [monitor addAcceleration:motion.userAcceleration];
        
        //Everything below here is for graph and labels
        double scale = 1000;
        double xyz = Norm(monitor.x, monitor.y, monitor.z) * sqrt(scale);
        
        counter++;
        if (counter >= measurements_per_sec) {
            [allPoints addObject:[NSNumber numberWithDouble:monitor.lastAverage * scale]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reloadGraph];
                _queueSize.text = [NSString stringWithFormat:@"Last Average Computed: %f", monitor.lastAverage * 1000];
            });
            counter = 0;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _xAxis.text = [NSString stringWithFormat:@"%@%f", @"x= ", motion.userAcceleration.x ];
            _yAxis.text = [NSString stringWithFormat:@"%@%f", @"y= ", motion.userAcceleration.y ];
            _zAxis.text = [NSString stringWithFormat:@"%@%f", @"z= ", motion.userAcceleration.z ];
            
            _rootSumSquare.text = [NSString stringWithFormat:@"%@%f", @"root sum square= ", xyz];
        });
    }];
}


- (void)initalizeGraph{
    [_graphView setBackgroundColor:[UIColor lightGrayColor]];
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:_graphView.bounds];
    _graphView.hostedGraph = graph;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    graph.title = [NSString stringWithFormat:@"All Accelerometer Data from %@", [dateFormatter stringFromDate:[NSDate date]]];
    graph.plotAreaFrame.masksToBorder = NO;
    graph.paddingLeft = 40;
    
    
//    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace*)graph.defaultPlotSpace;
//    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(15)];
//    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromDouble(20)];
    
    //Formats X-Axis
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:1];
    [formatter setMaximumFractionDigits:2];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet*)_graphView.hostedGraph.axisSet;
    CPTAxis *yAxis = axisSet.yAxis;
    yAxis.labelingPolicy = CPTAxisLabelingPolicyEqualDivisions;
    yAxis.preferredNumberOfMajorTicks = 6;
    yAxis.labelFormatter = formatter;
    
    //Formats Y-Axis
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:0];
    
    CPTAxis *xAxis = axisSet.xAxis;
    xAxis.labelingPolicy = CPTAxisLabelingPolicyEqualDivisions;
    xAxis.preferredNumberOfMajorTicks = 8;
    xAxis.labelFormatter = formatter;
    
    //Determines the data source of the graph
    CPTScatterPlot *mainPlot = [[CPTScatterPlot alloc] init];
    mainPlot.dataSource = self;
    mainPlot.plotSymbol = [CPTPlotSymbol hexagonPlotSymbol];
    [graph addPlot:mainPlot];
    
}

- (void)reloadGraph{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace*)_graphView.hostedGraph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0) length:CPTDecimalFromInteger(allPoints.count)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0)
                                     length:CPTDecimalFromFloat([[allPoints valueForKeyPath:@"@max.self"] floatValue] * 1.1f)];
    
    
    [_graphView.hostedGraph reloadData];
}

#pragma mark - CPTPlotDataSource methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    //NSLog(@"Called numberOfRecordsForPlot and returned %d", allPoints.count);
    return allPoints.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if (fieldEnum == CPTScatterPlotFieldX) {
        //NSLog(@"Called numberForPlot for X and returned %d", index);
        return [NSNumber numberWithInteger:index];
    }
    else if (fieldEnum == CPTScatterPlotFieldY){
        //NSLog(@"Called numberForPlot for Y and returned %@", [allPoints objectAtIndex:index]);
        return [allPoints objectAtIndex:index];
    }
    return nil;
}

//-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
//    return nil;
//}

@end
