//
//  SNTronMapView.h
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SNTronMap.h"

@interface SNTronMapView : NSView {
	SNTronMap *map;
	int width, height;
	int blockWidth, blockHeight;
}

@property (nonatomic,retain) SNTronMap *map;

@end
