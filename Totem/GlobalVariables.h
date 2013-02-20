//
//  GlobalVariables.h
//  Totem
//
//  Created by Quinton Petty on 2/19/13.
//  Copyright (c) 2013 Cal Poly Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject{

}

@property(readwrite)BOOL PUBLISH_TO_EVERNOTE;

+ (id)sharedInstance;
@end
