//
//  tronifAppDelegate.m
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "tronifAppDelegate.h"

@implementation tronifAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	controller = [[SNMainWindowController alloc] initWithWindow:window];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[controller killAllBots];
}

@end
