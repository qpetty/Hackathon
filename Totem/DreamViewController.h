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
#import "CorePlot-CocoaTouch.h"
#import "NSData+EvernoteSDK.h"

@class DreamViewController;

@interface DreamViewController : UIViewController <UITextViewDelegate>
{
    NSString *notebook;
    NSString *notebookgui;
    NSString *title;
    NSData *graphImage;
    NSString *graphHash;
    EDAMResource *graphResource;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *journal;
@property (weak, nonatomic) NSMutableArray *accelData;
@property (weak, nonatomic) CPTGraphHostingView *graphView;


- (IBAction)submitDream:(id)sender;
- (IBAction)exit:(id)sender;

//Evernote Methods

//Creates and send a note to the user's evernote account
- (void)addNote:(NSString *)notebookgui title:(NSString *)title content:(NSString *)toEvernote;

//Looks for the Totem Dream Journal Notebook and creates a note in it
- (void)getNotebookAndAddNote:(NSString*)title content:(NSString*)toEvernote;

//Creates a new Totem Dream Journal Notebook and creates a note in it
- (void)createNotebookWithNote:(NSString*)title content:(NSString*)toEvernote;

//Methods to send graph to Evernote

//Creates an Evernote Resource to be sent with the newly created note
-(EDAMResource*)createResource:(NSData*)imageNSData hash:(NSString*)hash;
//Creates a screenshot of a UIView
- (NSData *) imageFromView:(UIView *)view;
//Creates the md5 hash string of the give NSData
- (NSString*) hashOfData:(NSData*)data;

@end
