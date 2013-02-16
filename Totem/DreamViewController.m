//
//  DreamViewController.m
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import "DreamViewController.h"

@interface DreamViewController ()

@end

@implementation DreamViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitDream:(id)sender {
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    
    [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {
        NSLog(@"Notebooks : %@", notebooks);
    } failure:^(NSError *error) {
        NSLog(@"fail");
    }];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
