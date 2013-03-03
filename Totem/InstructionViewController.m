//
//  InstructionViewController.m
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import "InstructionViewController.h"

@interface InstructionViewController ()

@end

@implementation InstructionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Graphics/bg-568@2x.png"]];

    //Creates the scrollview for the instructions
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setContentSize:CGSizeMake(640/2, 3949/2)];
    scrollView.bounces = NO;
    
    //Creates the image to later be inserted in a scollview
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"howitworks.png"]];
    [imageView setFrame:CGRectMake(0, 0, 640/2, 3949/2)];
    
    [scrollView addSubview:imageView];
    [self.view addSubview:scrollView];
    
    [self.view bringSubviewToFront:_doneButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender{
    [self.delegate finishedInstructions:self];
}

@end
