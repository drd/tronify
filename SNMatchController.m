//
//  SNMainWindowController.m
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "SNMatchController.h"


@implementation SNMatchController

- (void)setup {
	players = [[NSMutableArray alloc] initWithObjects:[SNNullTronBot nullBot], [SNNullTronBot nullBot], nil];
}

-(SNTronBot *)player1 {
	return [players objectAtIndex:PLAYER1];
}

-(SNTronBot *)player2 {
	return [players objectAtIndex:PLAYER2];
}

-(IBAction) openFile:(id)sender {
	NSArray *fileTypes = [NSArray arrayWithObjects:@"txt", nil];
	NSString *filename = [self chooseFileWithTypes:fileTypes];
	
	if ([filename isEqualToString:@""]) {
		return;
	}
	
	if (map != nil) {
		[map release];
	}
	
	map = [[SNTronMap alloc] initFromFile:filename];
	mapView.map = map;
}

-(IBAction) setP1:(id)sender {
	[self setPlayer:PLAYER1];
	NSLog(@"player 1: %@", self.player1);
	NSLog(@"filename: %@", self.player1.filename);
	[player1Field setStringValue:self.player1.filename];
}

-(IBAction) setP2:(id)sender {
	[self setPlayer:PLAYER2];
	NSLog(@"filename: %@", self.player2.filename);
	[player2Field setStringValue:self.player2.filename];
}

-(void) setPlayer:(int)playerNum {
	NSString *filename = [self chooseFileWithTypes:nil];
	
	if ([filename isEqualToString:@""]) {
		return;
	}
	
	if ([players count] >= (playerNum + 1) && [players objectAtIndex:playerNum] != nil) {
		[[players objectAtIndex:playerNum] release];
	}
	
	[players insertObject:[[SNTronBot alloc] initFromFile:filename] atIndex:playerNum];
	[mapView setNeedsDisplay:YES];
}

-(IBAction) go:(id)sender {
	if (self.player1 == nil || self.player2 == nil || map == nil) {
		NSAlert * lert = [NSAlert alertWithMessageText:@"Dude, WTF!?" 
										 defaultButton:@"Oops"
									   alternateButton:nil
										   otherButton:nil
							 informativeTextWithFormat:@"You haven't chosen either or all of a map, player 1, or player 2."];
		[lert runModal];
		return;
	}
	
	NSLog(@"Launching player 1");
	[self.player1 launch];
	NSLog(@"Launching player 2");
	[self.player2 launch];
	
	NSLog(@"Starting game timer..");
	gameRunning = YES;
	botTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 
												target:self 
											  selector:@selector(performStep) 
											  userInfo:nil 
											   repeats:YES];
}

-(void) performStep {
	NSLog(@"performStep, taking player turns");
	int p1move = [self.player1 takeATurn:map];
	int p2move = [self.player2 takeATurn:map];
	
	NSLog(@"p1move: %d p2move: %d", p1move, p2move);
	
	[mapView setNeedsDisplay:YES];
	
	BOOL p1Alive = [map p1Moves:p1move];
	BOOL p2Alive = [map p2Moves:p2move];
	
	if (!(p1Alive && p2Alive)) {
		[self endgameReachedWithPlayer1:p1Alive player2:p2Alive];
	}
}

-(void) endgameReachedWithPlayer1:(BOOL)p1Alive player2:(BOOL)p2Alive {
	[botTimer invalidate];
	gameRunning = NO;

	[self killAllBots];
}

-(void) killAllBots {
	[self.player1 kill];
	[self.player2 kill];
}

-(NSString *) chooseFileWithTypes:(NSArray *)types {
	// Create the File Open Panel class.
	NSOpenPanel* oPanel = [NSOpenPanel openPanel];
	
	[oPanel setCanChooseDirectories:NO];
	[oPanel setCanChooseFiles:YES];
	[oPanel setCanCreateDirectories:YES];
	[oPanel setAllowsMultipleSelection:NO];
	[oPanel setAlphaValue:0.95];
	[oPanel setTitle:@"Select a map"];
	
	// Display the dialog.  If the OK button was pressed,
	// process the files.
	if ( [oPanel runModalForDirectory:nil file:nil types:types] == NSOKButton )
	{
		// Get an array containing the full filenames of all
		// files and directories selected.
		NSArray* files = [oPanel filenames];
		return [files objectAtIndex:0];
	} else {
		return @"";
	}
}	

-(void) dealloc {
	[self.player1 dealloc];
	[self.player2 dealloc];
	
	[super dealloc];
}

@end
