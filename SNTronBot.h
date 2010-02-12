//
//  SNTronBot.h
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SNTronMap.h"

@interface SNTronBot : NSObject {
	NSString *filename, *command;
	NSArray *arguments;
	NSTask *task;
	NSPipe *input, *output;
}

-(SNTronBot *) initFromFile:(NSString *)path;
-(void) launch;
-(void) kill;
-(int) takeATurn:(SNTronMap *)map;

@property (retain,nonatomic) NSString *filename;

@end
