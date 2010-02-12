//
//  SNMainWindowController.h
//  tronif
//
//  Created by Eric O'Connell on 2/11/10.
//  Copyright 2010 Roundpeg Designs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SNTronMap.h"
#import "SNTronBot.h"
#import "SNTronMapView.h"

@interface SNMainWindowController : NSWindowController {
	SNTronMap *map;
	SNTronBot *player1, *player2;	
	
	NSTimer *botTimer;
	BOOL gameRunning;
	
	IBOutlet NSWindow *window;
	IBOutlet SNTronMapView *mapView;
}

-(IBAction) openFile:(id)sender;
-(IBAction) setP1:(id)sender;
-(IBAction) setP2:(id)sender;
-(IBAction) go:(id)sender;

-(void) performStep;
-(void) endgameReachedWithPlayer1:(BOOL)p1Alive player2:(BOOL)p2Alive;

-(void) killAllBots;

-(SNTronBot *) setPlayer:(int)playerNum;
-(NSString *) chooseFileWithTypes:(NSArray*)types;

@end
