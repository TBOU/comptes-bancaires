//
//  CBMouvementsArrayController.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 23/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBGlobal.h"


@interface CBMouvementsArrayController : NSArrayController {
	BOOL nonPointes;
	CBTypeMouvement operation;
	NSString *searchString;
	NSDecimalNumber *soldeMouvementsFiltres;
}

- (BOOL)isFiltrage;

- (NSDecimalNumber *)soldeMouvementsFiltres;
- (void)setSoldeMouvementsFiltres:(NSDecimalNumber *)aSoldeMouvementsFiltres;

- (IBAction)filtreMouvementsPointage:(id)sender;
- (IBAction)filtreMouvementsOperation:(id)sender;
- (IBAction)filtreMouvementsMotClef:(id)sender;

- (void)calculeSoldeMouvementsFiltres:(NSArray *)mouvementsFiltresArray;

@end
