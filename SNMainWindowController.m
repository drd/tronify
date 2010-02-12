//
//  SNMainWindowController.m
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import "SNMainWindowController.h"


@implementation SNMainWindowController


-(IBAction) openFile:(id)sender {
	NSArray *fileTypes = [NSArray arrayWithObjects:@"txt", nil];
	NSString *filename = [self chooseFileWithTypes:fileTypes];
	
	map = [[SNTronMap alloc] initFromFile:filename];
	mapView.map = map;
}

-(IBAction) setP1:(id)sender {
	player1 = [self setPlayer:1];
}

-(IBAction) setP2:(id)sender {
	player2 = [self setPlayer:2];
}

-(SNTronBot *) setPlayer:(int)playerNum {
	return [[SNTronBot alloc] initFromFile:[self chooseFileWithTypes:nil]];
}

-(IBAction) go:(id)sender {
	if (player1 == nil || player2 == nil || map == nil) {
		NSAlert * lert = [NSAlert alertWithMessageText:@"Dude, WTF!?" 
										 defaultButton:@"Oops"
									   alternateButton:nil
										   otherButton:nil
							 informativeTextWithFormat:@"You haven't chosen either or all of a map, player 1, or player 2."];
		[lert runModal];
		return;
	}
	
	NSLog(@"Launching player 1");
	[player1 launch];
	NSLog(@"Launching player 2");
	[player2 launch];
	
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
	int p1move = [player1 takeATurn:map];
	int p2move = [player2 takeATurn:map];
	
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
	[player1 kill];
	[player2 kill];
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
	[player1 dealloc];
	[player2 dealloc];
	[super dealloc];
}

@end
