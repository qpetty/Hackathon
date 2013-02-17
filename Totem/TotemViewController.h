//
//  TotemViewController.h
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstructionViewController.h"
#import "EvernoteSDK.h"

FOUNDATION_EXPORT NSString * const dream_journal_name;

@interface TotemViewController : UIViewController{
    EvernoteSession *session;
}

@property (weak, nonatomic) IBOutlet UISwitch *evernoteSwitch;

-(IBAction)showSettings:(id)sender;
-(IBAction)useEvernote:(UISwitch *)sender;
-(NSString*)getGUID;

@end
