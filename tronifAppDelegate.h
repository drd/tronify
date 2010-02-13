//
//  tronifAppDelegate.h
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SNMatchController.h"

@interface tronifAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet SNMatchController *controller;
}

@property (assign) IBOutlet NSWindow *window;

@end
