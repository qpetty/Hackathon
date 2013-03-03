//
//  TotemViewController.h
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstructionViewController.h"
#import "GlobalVariables.h"
#import "EvernoteSDK.h"

FOUNDATION_EXPORT NSString * const dream_journal_name;

extern BOOL PUBLISH_TO_EVERNOTE;

@interface TotemViewController : UIViewController <UIAlertViewDelegate, InstuctionViewControllerDelegate> {
    EvernoteSession *session;
}

@property (weak, nonatomic) IBOutlet UISwitch *evernoteSwitch;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)showSettings:(id)sender;
- (IBAction)useEvernote:(UISwitch *)sender;
- (IBAction)logoutOfEvernote:(UIButton*)sender;
+ (NSString*)getGUID;

@end
