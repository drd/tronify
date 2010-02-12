//
//  SNTronMap.h
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define WALL	1000
#define EMPTY	0
#define P1		-100
#define P2		100

#define PLAYER1	0
#define PLAYER2	1

#define NORTH	1
#define EAST	2
#define SOUTH	3
#define WEST	4

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

- (void)dumpToFileHandle:(NSFileHandle *)fh;
- (void)dump;
- (NSData *)toNSData;

@property (nonatomic,readonly) int width;
@property (nonatomic,readonly) int height;


@end
