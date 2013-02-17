//
//  DreamViewController.h
//  Totem
//
//  Created by Quinton Petty on 2/16/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvernoteSDK.h"

@interface DreamViewController : UIViewController{
    NSString *notebook;
}

@property (weak, nonatomic) IBOutlet UITextView *journal;

- (IBAction)submitDream:(id)sender;

@end
