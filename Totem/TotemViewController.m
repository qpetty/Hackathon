//
//  TotemViewController.m
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import "TotemViewController.h"

@interface TotemViewController ()

@end

@implementation TotemViewController

NSString * const dream_journal_name = @"Totem Dream Journal";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    session = [EvernoteSession sharedSession];
    if ([session isAuthenticated]) {
        _evernoteSwitch.on = YES;
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showSettings:(id)sender{
    InstructionViewController *instruction =[[InstructionViewController alloc] init];
                                
    instruction.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:[[InstructionViewController alloc] init] animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"instructions"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

-(void)finishedInstructions:(InstructionViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
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
