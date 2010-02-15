//
//  SNTronMap.m
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "SNTronMap.h"

@implementation SNTronMap

@synthesize width, height;

- (id)initFromFile:(NSString *)path {
	FILE *fp = fopen([path UTF8String], "r");
	char c;
	int x = 0, y = 0;
	
	int num_items = fscanf(fp, "%d %d\n", &width, &height);
	if (feof(fp) || num_items < 2) {
		exit(0); // End of stream means end of game. Just exit.
	}
	
	walls = (int **)(malloc(sizeof(int *) * width));
	for (int i = 0; i < width; i++) {
		walls[i] = (int *)(malloc(sizeof(int) * height));
	}
		
	while ((c = fgetc(fp)) != EOF) {
		switch (c) {
			case '\r':
				break;
			case '\n':
				if (x != width) {
					fprintf(stderr, "x != width in Board_ReadFromStream\n");
					return nil;
				}
				++y;
				x = 0;
				break;
			case '#':
				if (x >= width) {
					fprintf(stderr, "x >= width in Board_ReadFromStream\n");
					return nil;
				}
				walls[x][y] = WALL;
				++x;
				break;
			case ' ':
				if (x >= width) {
					fprintf(stderr, "x >= width in Board_ReadFromStream\n");
					return nil;
				}
				walls[x][y] = EMPTY;
				++x;
				break;
			case '1':
				if (x >= width) {
					fprintf(stderr, "x >= width in Board_ReadFromStream\n");
					return nil;
				}
				walls[x][y] = P1;
				players[0].x = x;
				players[0].y = y;
				++x;
				break;
			case '2':
				if (x >= width) {
					fprintf(stderr, "x >= width in Board_ReadFromStream\n");
					return nil;
				}
				walls[x][y] = P2;
				players[1].x = x;
				players[1].y = y;
				++x;
				break;
			default:
				fprintf(stderr, "unexpected character %d in Board_ReadFromStream", c);
				return nil;
		}
		
	}
	
	return self;
}

- (BOOL)player:(int)player moves:(int)move {
	BOOL alive;
	position p = players[player];
	int newValue = (player == 0 ? P1 : P2) - 1;

	walls[p.x][p.y] = newValue;

	switch (move) {
		case NORTH:
			p.y--;
			break;
		case EAST:
			p.x++;
			break;
		case SOUTH:
			p.y++;
			break;
		case WEST:
			p.x--;
			break;
		default:
			break;
	}

	if (p.x > width || p.y > height || p.x < 0 || p.y < 0 || walls[p.x][p.y] != EMPTY) {
		alive = NO;
	} else {
		alive = YES;
	}
	
	players[player] = p;
	walls[p.x][p.y] = (player == 0 ? P1 : P2);
	
	return alive;
}

- (BOOL)p1Moves:(int)move {
	return [self player:PLAYER1 moves:move];
}

- (BOOL)p2Moves:(int)move {
	return [self player:PLAYER2 moves:move];
}


- (int)p1Value {
	return P1;
}

- (int)p2Value {
	return P2;
}

- (int)wallValue {
	return WALL;
}

- (int)emptyValue {
	return EMPTY;
}

- (int)atX:(int)x Y:(int)y {
	return walls[x][y];
}

- (BOOL)isWallAtX:(int)x Y:(int)y {
	return walls[x][y] != EMPTY;
}

- (void)sendToBot:(SNTronBot *)player {
	[self sendToPlayer:player.playerNum fileHandle:player.write];
}

- (void)dumpForPlayer:(int)playerNum {
	[self sendToPlayer:playerNum fileHandle:[NSFileHandle fileHandleWithStandardOutput]];
}
	
- (void)sendToPlayer:(int)playerNum fileHandle:(NSFileHandle *)fh {
	[fh writeData:[self toNSDataForPlayer:playerNum]];
}

- (NSData *)toNSDataForPlayer:(int)playerNum {
	NSMutableString *map;
	NSString *p1Str = playerNum == PLAYER1 ? @"1" : @"2";
	NSString *p2Str = playerNum == PLAYER1 ? @"2" : @"1";
	
	map = [NSMutableString stringWithFormat:@"%d %d\n", width, height];
	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			switch (walls[x][y]) {
				case EMPTY:
					[map appendString:@" "];
					break;
				case P1:
					[map appendString:p1Str];
					break;
				case P2:
					[map appendString:p2Str];
					break;
				case WALL:
				default:
					[map appendString:@"#"];
					break;
			}
		}
		[map appendString:@"\n"];
	}
	return [map dataUsingEncoding:NSASCIIStringEncoding];
}

@end
