//
//  SNTronMap.h
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SNTronBot.h"

@class SNTronBot;

typedef struct _position {
	int x, y;
} position;

@interface SNTronMap : NSObject {
	int **walls;
	int width, height;
	position players[2];
}

- (id)initFromFile:(NSString *)path;

- (BOOL)player:(int)player moves:(int)move;
- (BOOL)p1Moves:(int)move;
- (BOOL)p2Moves:(int)move;

- (int)p1Value;
- (int)p2Value;
- (int)wallValue;
- (int)emptyValue;

- (BOOL)isWallAtX:(int)x Y:(int)y;
- (int)atX:(int)x Y:(int)y;

- (void)sendToBot:(SNTronBot *)player;
- (void)dumpForPlayer:(int)playerNum;
- (void)sendToPlayer:(int)playerNum fileHandle:(NSFileHandle *)fh;
- (NSData *)toNSDataForPlayer:(int)playerNum;

@property (nonatomic,readonly) int width;
@property (nonatomic,readonly) int height;


@end
