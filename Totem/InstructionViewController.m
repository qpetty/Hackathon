//
//  InstructionViewController.m
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#define DREAM_NOTEBOOK_NAME Totem Dream Log

#import "InstructionViewController.h"

@interface InstructionViewController ()

@end

@implementation InstructionViewController

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
    
    dream_journal_name = @"Totem Dream Journal";
    
    session = [EvernoteSession sharedSession];
    if ([session isAuthenticated]) {
        _evernoteSwitch.on = YES;
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender{
    [self.delegate finishedInstructions:self];
}

- (IBAction)useEvernote:(UISwitch *)sender {
    
    if(sender.on == YES){
        if(![session isAuthenticated]){
            [session authenticateWithViewController:self completionHandler:^(NSError *error) {
                if ([session isAuthenticated]){
                    sender.on = YES;
                    NSString *something = [self getGUID];
                }
                else
                    sender.on = NO;
            }];
        }
    }
    else{
        [session logout];
    }
}

-(NSString*)getGUID{
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    
    
    [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {
        EDAMNotebook *curbnb;
        BOOL foundNotebook = NO;
        
        for (curbnb in notebooks) {
            NSLog(curbnb.name);
            if ([curbnb.name isEqualToString:dream_journal_name]) {
                foundNotebook = YES;
                break;
            }
        }
        
        if (foundNotebook) {
            NSLog(@"Found Notebook");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:curbnb.guid forKey:@"Dream Journal"];
            [defaults synchronize];
        }
        else{
            [noteStore createNotebook:[[EDAMNotebook alloc] initWithGuid:nil name:dream_journal_name updateSequenceNum:0 defaultNotebook:NO serviceCreated:nil serviceUpdated:nil publishing:nil published:NO stack:nil sharedNotebookIds:nil sharedNotebooks:nil businessNotebook:nil contact:nil restrictions:nil] success:^(EDAMNotebook *notebook) {
                NSLog(@"Worked");
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:notebook.guid forKey:@"Dream Journal"];
                [defaults synchronize];
            } failure:^(NSError *error) {
                NSLog(@"Not worked");
            }];
        }
        NSLog(@"Finished");
    } failure:^(NSError *error) {
        NSLog(@"fail");
    }];
    return nil;
}

@end
