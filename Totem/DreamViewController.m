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
    [_journal becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitDream:(id)sender {

    if ([[EvernoteSession sharedSession] isAuthenticated]) {
        NSString *notebookgui = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"Dream Journal"];
        NSLog(@"%@",notebookgui);

        NSString *content = _journal.text;
        
        NSString *toEvernote = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\"><en-note>\n%@\n</en-note>", content ];
        
        EDAMNote *newnote = [[EDAMNote alloc] initWithGuid:nil title:@"First" content:toEvernote contentHash:nil contentLength:toEvernote.length created:nil updated:nil deleted:nil active:YES updateSequenceNum:0 notebookGuid:notebookgui tagGuids:nil resources:nil attributes:nil tagNames:nil];
        
        
        [[EvernoteNoteStore noteStore] createNote:newnote success:^(EDAMNote *note) {
            NSLog(@"Worked");
        } failure:^(NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
            NSLog(@"no good");
        }];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
