//
//  SNNullTronBot.m
//  tronif
//
//  Created by Eric O'Connell on 2/15/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "SNNullTronBot.h"


@implementation SNNullTronBot

+ (SNNullTronBot *)nullBot {
	return [[SNNullTronBot alloc] init];
}

- (BOOL) isNull {
	return YES;
}

@end
