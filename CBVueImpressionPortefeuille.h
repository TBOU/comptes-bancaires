//
//  CBVueImpressionPortefeuille.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 21/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBPortefeuille.h"
#import "CBCompte.h"
#import "CBNombreFormatter.h"


@interface CBVueImpressionPortefeuille : NSView {
	CBPortefeuille *thePortefeuille;
	NSArray *theComptesArray;
	CBNombreFormatter *theSoldeFormateur;
	
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
	float colBanqueMinWidth;
	float colBanqueWidth;
	float colNumeroCompteMinWidth;
	float colNumeroCompteWidth;
	float colSoldeWidth;
	
	int nbElementsFirstPage;
	int nbElementsOtherPage;
	int nbPages;
}

- (id)initWithPortefeuille:(CBPortefeuille *)aPortefeuille comptes:(NSArray *)aComptesArray printInfo:(NSPrintInfo *)pInfo nombreFormatter:(CBNombreFormatter *)aSoldeFormateur;

- (void)displayDimensions;

- (void)elementsIntervalleForPage:(int)indexPage indexMin:(int *)indexElementMin indexMax:(int *)indexElementMax;
- (void)dessineString:(NSString *)aString inRect:(NSRect)aRect withAttributes:(NSDictionary *)attributes alignRight:(BOOL)alignRight;

@end
