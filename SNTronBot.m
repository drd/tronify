//
//  SNTronBot.m
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "SNTronBot.h"


@implementation SNTronBot

@synthesize filename, playerNum;

-(id) initFromFile:(NSString *)path playerNum:(int)num {
	self.filename = path;
	playerNum = num;
	return self;
}	

- (BOOL) isNull {
	return NO;
}

-(void) setFilename:(NSString *)name {
	filename = [name retain];
	
	NSDictionary *commandLookups = [NSDictionary dictionaryWithObjectsAndKeys:
									@"/usr/bin/python", @"py",
									@"/usr/bin/ruby", @"rb", 
									@"/usr/bin/java", @"jar", nil];

	NSDictionary *argumentLookups = [NSDictionary dictionaryWithObjectsAndKeys:
									 @"-jar", @"jar", nil];
	
	NSString *extension = [[filename componentsSeparatedByString:@"."] lastObject];
	
	if ([extension isEqualToString:filename]) {
		command = filename;
		arguments = [[NSArray alloc] init];
	} else {
		command = [[commandLookups valueForKey:extension] retain];
		NSString *secondaryArgument = [argumentLookups valueForKey:extension];
		NSMutableArray *tempArguments = [[NSMutableArray alloc] init];
		
		if (secondaryArgument != nil) {
			[tempArguments addObject:secondaryArgument];
		}
		
		[tempArguments addObject:filename];
		arguments = tempArguments;
	}

	if ([task isRunning]) {
		NSLog(@"Terminating task.. %d", [task processIdentifier]);
		[task terminate];
	}
	
	input = [[NSPipe pipe] retain];
	output = [[NSPipe pipe] retain];
	task = [[NSTask alloc] init];
	
	[task setLaunchPath:command];
	[task setArguments:arguments];
	[task setCurrentDirectoryPath:[filename stringByDeletingLastPathComponent]];
	[task setEnvironment:[NSDictionary dictionaryWithObject:@"/usr/local/bin:/usr/bin"
													 forKey:@"PATH"]];
	
	[task setStandardInput:input];
	[task setStandardOutput:output];
	
}

-(NSFileHandle *)read {
	return [input fileHandleForReading];
}

-(NSFileHandle *)write {
	return [input fileHandleForWriting];
}

-(void) launch {
	[task launch];
}

-(void) kill {
	[task terminate];
	[input release];
	[output release];
	[task release];
}	

-(void) sendMap:(SNTronMap *)map {
	NSLog(@"Taking a turn...");
	[map sendToBot:self];
}

-(int) getMove {
	int fd = [[output fileHandleForReading] fileDescriptor];
	FILE* fp = fdopen(fd, "r");
	
	char in[100];
	fgets(in, 100, fp);
	
	NSLog(@"received input: %s", in);
	
	return atoi(in);
}

@end
