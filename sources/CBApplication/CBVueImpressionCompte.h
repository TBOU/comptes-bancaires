//
//  CBVueImpressionCompte.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 21/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBCompte.h"
#import "CBMouvement.h"
#import "CBNombreFormatter.h"


@interface CBVueImpressionCompte : NSView {
	CBCompte *theCompte;
	NSArray *theMouvementsArray;
	CBNombreFormatter *theSoldeFormateur;
	NSDateFormatter *theDateFormateur;
	
	float thePaperWidth;
	float thePaperHeight;
	float theLeftMargin;
	float theRightMargin;
	float theTopMargin;
	float theBottomMargin;
	float theScalingFactor;

	NSMutableDictionary *ornementsAttributes;
	NSMutableDictionary *enteteGrandAttributes;
	NSMutableDictionary *enteteMoyenAttributes;
	NSMutableDictionary *tableauEnteteAttributes;
	NSMutableDictionary *tableauLigneAttributes;
	
	float ornementsHeight;
	float enteteGrandHeight;
	float enteteMoyenHeight;
	float enteteGeneralHeight;
	float tableauEnteteHeight;
	float tableauLigneHeight;
	
	float deltaWidth;
	float colDateWidth;
	float colOperationWidth;
	float colLibelleMinWidth;
	float colLibelleWidth;
	float colCategorieMinWidth;
	float colCategorieWidth;
	float colMontantWidth;
	float colPointageWidth;
	float colSoldeWidth;

	int nbElementsFirstPage;
	int nbElementsOtherPage;
	int nbPages;
}

- (id)initWithCompte:(CBCompte *)aCompte mouvements:(NSArray *)aMouvementsArray printInfo:(NSPrintInfo *)pInfo nombreFormatter:(CBNombreFormatter *)aSoldeFormateur dateFormatter:(NSDateFormatter *)aDateFormateur;

- (void)displayDimensions;

- (void)elementsIntervalleForPage:(int)indexPage indexMin:(int *)indexElementMin indexMax:(int *)indexElementMax;
- (void)dessineString:(NSString *)aString inRect:(NSRect)aRect withAttributes:(NSDictionary *)attributes alignRight:(BOOL)alignRight;

@end
