//
//  InstructionViewController.h
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvernoteSDK.h"

//FOUNDATION_EXPORT NSString * const ENBootstrapProfileNameChina;

@class InstructionViewController;

@protocol InstuctionViewControllerDelegate
-(void)finishedInstructions:(InstructionViewController *)controller;
@end

@interface InstructionViewController : UIViewController{
    EvernoteSession *session;
    NSString *dream_journal_name;
}

@property (weak, nonatomic) IBOutlet UISwitch *evernoteSwitch;
@property (weak, nonatomic) id <InstuctionViewControllerDelegate> delegate;

-(IBAction)back:(id)sender;
-(IBAction)useEvernote:(UISwitch *)sender;
-(NSString*)getGUID;

@end
