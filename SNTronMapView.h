//
//  SNTronMapView.h
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SNTronMap.h"
#import "SNMatchController.h"

@class SNMatchController;

@interface SNTronMapView : NSView <NSWindowDelegate> {
	SNTronMap *map;
	IBOutlet SNMatchController *controller;
	int width, height;
	float blockWidth, blockHeight;
}

- (void)configureBlockSizeForFrameSize:(NSSize)frameSize;

@property (nonatomic,retain) SNMatchController *controller;
@property (nonatomic,retain) SNTronMap *map;

@end
