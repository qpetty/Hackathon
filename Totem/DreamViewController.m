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

    if ([[EvernoteSession sharedSession] isAuthenticated] && ![_journal.text isEqualToString:@""]) {
        notebookgui = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"Dream Journal"];
        NSLog(@"%@",notebookgui);

        NSString *content = _journal.text;
        NSString *toEvernote = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\"><en-note>\n%@\n</en-note>", content ];
        
        [[EvernoteNoteStore noteStore] getNotebookWithGuid:notebookgui success:^(EDAMNotebook *notebook) {
            NSLog(@"Success here %@",notebookgui);
            [DreamViewController addNote:notebookgui title:title content:toEvernote];
        } failure:^(NSError *error) {
            notebookgui = [TotemViewController getGUID];
            [DreamViewController addNote:notebookgui title:title content:toEvernote];
        }];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

+(void)addNote:(NSString *)notebookgui title:(NSString *)title content:(NSString *)toEvernote{
    EDAMNote *newnote = [[EDAMNote alloc] initWithGuid:nil title:title content:toEvernote contentHash:nil contentLength:toEvernote.length created:nil updated:nil deleted:nil active:YES updateSequenceNum:0 notebookGuid:notebookgui tagGuids:nil resources:nil attributes:nil tagNames:nil];
    
    
    [[EvernoteNoteStore noteStore] createNote:newnote success:^(EDAMNote *note) {
        NSLog(@"Worked");
    } failure:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        NSLog(@"no good");
    }];
}

//- (IBAction)submitDream:(id)sender {
//
//    if ([[EvernoteSession sharedSession] isAuthenticated]) {
//        notebookgui = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"Dream Journal"];
//        NSLog(@"%@",notebookgui);
//
//        [[EvernoteNoteStore noteStore] getNotebookWithGuid:notebookgui success:^(EDAMNotebook *notebook) {
//            NSLog(@"%@",notebookgui);
//        } failure:^(NSError *error) {
//            notebookgui = [TotemViewController getGUID];
//        }];
//        
//        NSString *content = _journal.text;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"MM-dd-yyyy";
//        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        NSString *title = [NSString stringWithFormat:@"Dream from %@", [dateFormatter stringFromDate:[NSDate date]]];
//        NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
//        
//        
//        NSString *toEvernote = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\"><en-note>\n%@\n</en-note>", content ];
//        
//        EDAMNote *newnote = [[EDAMNote alloc] initWithGuid:nil title:title content:toEvernote contentHash:nil contentLength:toEvernote.length created:nil updated:nil deleted:nil active:YES updateSequenceNum:0 notebookGuid:notebookgui tagGuids:nil resources:nil attributes:nil tagNames:nil];
//        
//        
//        [[EvernoteNoteStore noteStore] createNote:newnote success:^(EDAMNote *note) {
//            NSLog(@"Worked");
//        } failure:^(NSError *error) {
//            NSLog(@"%@",[error localizedDescription]);
//            NSLog(@"no good");
//        }];
//    }
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
@end
