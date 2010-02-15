//
//  SNTronMapView.m
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "SNTronMapView.h"

@implementation SNTronMapView

@synthesize map, controller;

- (void)setMap:(SNTronMap *)newMap {
	map = newMap;
	
	width = map.width;
	height = map.height;
	[self configureBlockSizeForFrameSize:[self frame].size];
}

- (void)configureBlockSizeForFrameSize:(NSSize)frameSize {
	blockWidth = frameSize.width / width;
	blockHeight = frameSize.height / height;
	
	[self setNeedsDisplay:YES];
}

- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
//	NSLog(@"resizing to: %@", frameSize);
	[self configureBlockSizeForFrameSize:frameSize];

	return frameSize;
}

- (void)windowDidResize:(NSNotification *)notification {
	NSLog(@"resize?: %@", notification);
	[self configureBlockSizeForFrameSize:[self frame].size];
}

- (BOOL)isFlipped {
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
	CGRect rect = CGRectMake(0, 0, blockWidth, blockHeight);
	int wall = [map wallValue], empty = [map emptyValue], p1 = [map p1Value], p2 = [map p2Value];
	int val;
	
	NSColor *c;
	
	for(int y = 0; y < height; y++) {
		for(int x = 0; x < width; x++) {
			
			val = [map atX:x Y:y];
			if (val == wall) {
				c = [NSColor blackColor];
			} else if (val == empty) {
				c = [NSColor whiteColor];
			} else if (val == p1) {
				c = [NSColor redColor];
				if (controller.player1.isNull) {
					c = [NSColor colorWithDeviceRed:1.0 green:0.5 blue:0.5 alpha:1.0];
				}
			} else if (val == p2) {
				c = [NSColor blueColor];
				if (controller.player2.isNull) {
					c = [NSColor colorWithDeviceRed:0.5 green:0.5 blue:1.0 alpha:1.0];
				}
			} else {
				c = [NSColor whiteColor];
				// stupid
			}

			[c set];
			NSRectFill(rect);
			
			rect = CGRectOffset(rect, blockWidth, 0);
		}

		rect = CGRectOffset(rect, -width * blockWidth, blockHeight);
	}
}

@end
