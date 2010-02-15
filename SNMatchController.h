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
#import "SNNullTronBot.h"
#import "SNTronMapView.h"

@class SNTronMapView;

@interface SNMatchController : NSWindowController {
	SNTronMap *map;
	NSMutableArray *players;
	
	NSTimer *botTimer;
	BOOL gameRunning;
	
	IBOutlet NSWindow *window;
	IBOutlet SNTronMapView *mapView;
	IBOutlet NSTextField *player1Field, *player2Field;
}

-(void) setup;

-(IBAction) openFile:(id)sender;
-(IBAction) setP1:(id)sender;
-(IBAction) setP2:(id)sender;
-(IBAction) go:(id)sender;

-(void) takeFirstTurn;
-(void) takeNormalTurn;
-(void) sendMapToBots;

-(void) endgameReachedWithPlayer1:(BOOL)p1Alive player2:(BOOL)p2Alive;

-(void) killAllBots;

-(void) setPlayer:(int)playerNum;
-(NSString *) chooseFileWithTypes:(NSArray*)types;

@property (readonly) SNTronBot *player1;
@property (readonly) SNTronBot *player2;

@end
