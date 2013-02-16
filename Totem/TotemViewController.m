//
//  TotemViewController.m
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import "TotemViewController.h"

@interface TotemViewController ()

@end

@implementation TotemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showSettings:(id)sender{
    InstructionViewController *instruction =[[InstructionViewController alloc] init];
                                
    instruction.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:[[InstructionViewController alloc] init] animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"instructions"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

-(void)finishedInstructions:(InstructionViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
