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
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg-568@2x.png"]];
    
    [_journal becomeFirstResponder];
    _journal.delegate = self;
	// Do any additional setup after loading the view.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd-yyyy";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    title = [NSString stringWithFormat:@"Dream from %@", [dateFormatter stringFromDate:[NSDate date]]];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    _titleLabel.text = title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self submitDream:self];
        return NO;
    }
    
    return YES;
}


- (IBAction)submitDream:(id)sender {

    NSLog(@"%d",[[GlobalVariables sharedInstance] PUBLISH_TO_EVERNOTE]);
    
    if ([[GlobalVariables sharedInstance] PUBLISH_TO_EVERNOTE] && [[EvernoteSession sharedSession] isAuthenticated] && ![_journal.text isEqualToString:@""]) {
        
        notebookgui = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"Dream Journal"];
        NSLog(@"Notebook from UserDefaults: %@",notebookgui);

        NSString *content = _journal.text;
        NSString *toEvernote = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\"><en-note>\n%@\n</en-note>", content ];
        
        [[EvernoteNoteStore noteStore] getNotebookWithGuid:notebookgui success:^(EDAMNotebook *notebook) {
            NSLog(@"Success here %@",notebookgui);
            [DreamViewController addNote:notebookgui title:title content:toEvernote];
        } failure:^(NSError *error) {
            [DreamViewController getNotebookAndAddNote:title content:toEvernote];
            //[DreamViewController addNote:notebookgui title:title content:toEvernote];
        }];
        
        NSLog(@"Notebook used: %@",notebookgui);
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

+(void)addNote:(NSString *)notebookgui title:(NSString *)title content:(NSString *)toEvernote{
    EDAMNote *newnote = [[EDAMNote alloc] initWithGuid:nil title:title content:toEvernote contentHash:nil contentLength:toEvernote.length created:(EDAMTimestamp)nil updated:(EDAMTimestamp)nil deleted:(EDAMTimestamp)nil active:YES updateSequenceNum:(EDAMTimestamp)0 notebookGuid:notebookgui tagGuids:nil resources:nil attributes:nil tagNames:nil];
    
    
    [[EvernoteNoteStore noteStore] createNote:newnote success:^(EDAMNote *note) {
        NSLog(@"Worked");
    } failure:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        NSLog(@"no good");
    }];
}

+(void)getNotebookAndAddNote:(NSString*)title content:(NSString*)toEvernote{
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    
    [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {
        EDAMNotebook *curbnb;
        NSString *notebookguid = nil;
        
        BOOL foundNotebook = NO;
        
        for (curbnb in notebooks) {
            NSLog(@"%@",curbnb.name);
            if ([curbnb.name isEqualToString:dream_journal_name]) {
                foundNotebook = YES;
                break;
            }
        }
        
        if (foundNotebook) {
            notebookguid = curbnb.guid;
            NSLog(@"Found Notebook: %@", notebookguid);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:curbnb.guid forKey:@"Dream Journal"];
            [defaults synchronize];
            
            [DreamViewController addNote:curbnb.guid title:title content:toEvernote];
        }
        else{
            [DreamViewController createNotebookWithNote:title content:toEvernote];
        }
        NSLog(@"Finished");
    } failure:^(NSError *error) {
        NSLog(@"fail");
    }];
}

+(void)createNotebookWithNote:(NSString*)title content:(NSString*)toEvernote{
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    
    [noteStore createNotebook:[[EDAMNotebook alloc] initWithGuid:nil name:dream_journal_name updateSequenceNum:(EDAMTimestamp)0 defaultNotebook:NO serviceCreated:(EDAMTimestamp)nil serviceUpdated:(EDAMTimestamp)nil publishing:nil published:NO stack:nil sharedNotebookIds:nil sharedNotebooks:nil businessNotebook:nil contact:nil restrictions:nil] success:^(EDAMNotebook *notebook) {
        NSLog(@"Worked");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:notebook.guid forKey:@"Dream Journal"];
        [defaults synchronize];
        
        [DreamViewController addNote:notebook.guid title:title content:toEvernote];
        
    } failure:^(NSError *error) {
        NSLog(@"Didn't work");
    }];
}

@end
