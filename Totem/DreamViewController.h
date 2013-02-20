//
//  DreamViewController.h
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvernoteSDK.h"
#import "TotemViewController.h"
#import "GlobalVariables.h"

@interface DreamViewController : UIViewController <UITextViewDelegate>
{
    NSString *notebook;
    NSString *notebookgui;
    NSString *title;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *journal;

- (IBAction)submitDream:(id)sender;
//- (BOOL)textFieldShouldReturn:(UITextField *)textField;
+ (void)addNote:(NSString *)notebookgui title:(NSString *)title content:(NSString *)toEvernote;
+ (void)getNotebookAndAddNote:(NSString*)title content:(NSString*)toEvernote;
+ (void)createNotebookWithNote:(NSString*)title content:(NSString*)toEvernote;
@end
