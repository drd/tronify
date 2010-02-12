//
//  SNTronBot.m
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "SNTronBot.h"


@implementation SNTronBot

@synthesize filename;

-(id) initFromFile:(NSString *)path {
	self.filename = path;
	return self;
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
	[task setEnvironment:[NSDictionary dictionaryWithObject:@"/usr/local/bin:/usr/bin"
													 forKey:@"PATH"]];
	
	[task setStandardInput:input];
	[task setStandardOutput:output];
	
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

-(int) takeATurn:(SNTronMap *)map {
	NSLog(@"Taking a turn...");
	NSFileHandle *write = [input fileHandleForWriting];
	[map dumpToFileHandle:write];
	NSLog(@"Data written...");

//	return 0;
	int fd = [[output fileHandleForReading] fileDescriptor];
	FILE* fp = fdopen(fd, "r");

	char in[100];
	fgets(in, 100, fp);

	NSLog(@"received input: %s", in);
	
	return atoi(in);
}

@end
