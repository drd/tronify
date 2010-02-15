//
//  SNTronBot.h
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SNTronMap.h"

@class SNTronMap;

@interface SNTronBot : NSObject {
	NSString *filename, *command;
	NSArray *arguments;
	NSTask *task;
	NSPipe *input, *output;
	
	int playerNum;
}

-(SNTronBot *) initFromFile:(NSString *)path playerNum:(int)player;
-(void) launch;
-(void) kill;
-(void) sendMap:(SNTronMap *)map;
-(int) getMove;
-(BOOL) isNull;

@property (retain,nonatomic) NSString *filename;
@property (readonly) int playerNum;
@property (readonly) BOOL isNull;

@property (readonly) NSFileHandle *read;
@property (readonly) NSFileHandle *write;

@end
