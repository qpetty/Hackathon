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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppeared:) name:UIKeyboardDidShowNotification object:nil];
    
    [_journal becomeFirstResponder];
    _journal.delegate = self;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd-yyyy";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    title = [NSString stringWithFormat:@"Dream from %@", [dateFormatter stringFromDate:[NSDate date]]];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    _titleLabel.text = title;
    
    graphImage = [self imageFromView:_graphView];
    graphHash = [self hashOfData:graphImage];
    graphResource = nil;
    NSLog(@"Hash of Picture: %@", graphHash);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    if([text isEqualToString:@"\n"]) {
//        [self submitDream:self];
//        return NO;
//    }
//    
//    return YES;
//}

- (void)keyboardAppeared:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    _journal.frame = CGRectMake(_journal.frame.origin.x, _journal.frame.origin.y, _journal.frame.size.width, _journal.superview.frame.size.height - _journal.frame.origin.y * 1.1 - keyboardFrameBeginRect.size.height);
}

- (NSData *) imageFromView:(UIView *)view {
    UIGraphicsBeginImageContext(view.frame.size);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(screenshot);
}

- (NSString*)hashOfData:(NSData*)data{
    NSString *hash = [[[data md5] description] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"First hash: %@", hash);
    hash = [hash substringWithRange:NSMakeRange(1, [hash length] - 2)];
    return hash;
}

-(EDAMResource*)createResource:(NSData*)imageNSData hash:(NSString*)hash{
    EDAMData * imageData = [[EDAMData alloc] initWithBodyHash:[hash dataUsingEncoding: NSASCIIStringEncoding] size:[imageNSData length] body:imageNSData];
    
    
    // 2) Create an EDAMResourceAttributes object with other important attributes of the file
    EDAMResourceAttributes *imageAttributes = [[EDAMResourceAttributes alloc] init];
    [imageAttributes setFileName:@"example.png"];
    
    // 3) create an EDAMResource the hold the mime, the data and the attributes
    EDAMResource *imageResource  = [[EDAMResource alloc] init];
    [imageResource setMime:@"image/png"];
    [imageResource setData:imageData];
    [imageResource setAttributes:imageAttributes];
    
    return imageResource;
}

- (IBAction)exit:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)submitDream:(id)sender{

    NSLog(@"%d",[[GlobalVariables sharedInstance] PUBLISH_TO_EVERNOTE]);
    
    if ([[GlobalVariables sharedInstance] PUBLISH_TO_EVERNOTE] && [[EvernoteSession sharedSession] isAuthenticated] && ![_journal.text isEqualToString:@""]) {
        
        notebookgui = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"Dream Journal"];
        NSLog(@"Notebook from UserDefaults: %@",notebookgui);

        NSString *imageTag = nil;
        if (graphImage) {
            imageTag = [NSString stringWithFormat:@"<br/><en-media type=\"image/png\" hash=\"%@\"/>", graphHash];
            graphResource = [self createResource:graphImage hash:graphHash];
        }
        
        //Create Evernote XML
        NSString *paragraphBegin = @"<div>";
        NSString *paragraphEnd = @"</div>";
        //NSString *content = _journal.text;
        NSString *content = [_journal.text stringByReplacingOccurrencesOfString:@"\n" withString:[[NSString alloc] initWithFormat:@"%@%@", paragraphEnd,paragraphBegin]];
        
        content = [content stringByReplacingOccurrencesOfString:[paragraphBegin stringByAppendingString:paragraphEnd] withString:@"<br />"];
        NSString *toEvernote = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\"><en-note>\n%@%@%@%@\n</en-note>",paragraphBegin, content, paragraphEnd, imageTag];
        
        [[EvernoteNoteStore noteStore] getNotebookWithGuid:notebookgui success:^(EDAMNotebook *notebook) {
            NSLog(@"Success here %@",notebookgui);
            [self addNote:notebookgui title:title content:toEvernote];
        } failure:^(NSError *error) {
            [self getNotebookAndAddNote:title content:toEvernote];
            //[DreamViewController addNote:notebookgui title:title content:toEvernote];
        }];
        
        NSLog(@"Notebook used: %@",notebookgui);
    }
    [self exit:nil];
}

-(void)addNote:(NSString *)notebookGuiForNote title:(NSString *)noteTitle content:(NSString *)toEvernote{
    EDAMNote *newnote = [[EDAMNote alloc] initWithGuid:nil title:noteTitle content:toEvernote contentHash:nil contentLength:toEvernote.length created:(EDAMTimestamp)nil updated:(EDAMTimestamp)nil deleted:(EDAMTimestamp)nil active:YES updateSequenceNum:(EDAMTimestamp)0 notebookGuid:notebookGuiForNote tagGuids:nil resources:nil attributes:nil tagNames:nil];
    
    if (graphResource) {
        [newnote setResources:[[NSMutableArray alloc] initWithObjects:graphResource, nil]];
    }
    
    [[EvernoteNoteStore noteStore] createNote:newnote success:^(EDAMNote *note) {
        NSLog(@"Worked");
    } failure:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
        NSLog(@"no good");
    }];
}

-(void)getNotebookAndAddNote:(NSString*)noteTitle content:(NSString*)toEvernote{
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
            
            [self addNote:curbnb.guid title:noteTitle content:toEvernote];
        }
        else{
            [self createNotebookWithNote:noteTitle content:toEvernote];
        }
        NSLog(@"Finished");
    } failure:^(NSError *error) {
        NSLog(@"fail");
    }];
}

-(void)createNotebookWithNote:(NSString*)noteTitle content:(NSString*)toEvernote{
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    
    [noteStore createNotebook:[[EDAMNotebook alloc] initWithGuid:nil name:dream_journal_name updateSequenceNum:(EDAMTimestamp)0 defaultNotebook:NO serviceCreated:(EDAMTimestamp)nil serviceUpdated:(EDAMTimestamp)nil publishing:nil published:NO stack:nil sharedNotebookIds:nil sharedNotebooks:nil businessNotebook:nil contact:nil restrictions:nil] success:^(EDAMNotebook *newNotebook) {
        NSLog(@"Worked");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:newNotebook.guid forKey:@"Dream Journal"];
        [defaults synchronize];
        
        [self addNote:newNotebook.guid title:noteTitle content:toEvernote];
        
    } failure:^(NSError *error) {
        NSLog(@"Didn't work");
    }];
}

@end
