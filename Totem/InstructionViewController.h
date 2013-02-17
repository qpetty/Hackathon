//
//  InstructionViewController.h
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvernoteSDK.h"

@class InstructionViewController;

@protocol InstuctionViewControllerDelegate
-(void)finishedInstructions:(InstructionViewController *)controller;
@end

@interface InstructionViewController : UIViewController

@property (weak, nonatomic) id <InstuctionViewControllerDelegate> delegate;

-(IBAction)back:(id)sender;

@end
