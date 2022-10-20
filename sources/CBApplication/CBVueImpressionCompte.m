//
//  CBVueImpressionCompte.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 21/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBGlobal.h"
#import "CBVueImpressionCompte.h"
#include <math.h>


@implementation CBVueImpressionCompte

- (id)initWithCompte:(CBCompte *)aCompte mouvements:(NSArray *)aMouvementsArray printInfo:(NSPrintInfo *)pInfo nombreFormatter:(CBNombreFormatter *)aSoldeFormateur dateFormatter:(NSDateFormatter *)aDateFormateur
{
	NSRect theFrame;

	// On récupère les paramètres de mise en page
	thePaperWidth = [pInfo paperSize].width;
	thePaperHeight = [pInfo paperSize].height;
	theLeftMargin = [pInfo leftMargin];
	theRightMargin = [pInfo rightMargin];
	theTopMargin = [pInfo topMargin];
	theBottomMargin = [pInfo bottomMargin];
	theScalingFactor = [[[pInfo dictionary] objectForKey:NSPrintScalingFactor] floatValue];


	// On génère les différents attributs de mise en forme
	NSMutableDictionary *anOrnementsAttributes = [NSMutableDictionary dictionaryWithCapacity:2];
	[anOrnementsAttributes setObject:[NSFont fontWithName:@"Helvetica" size:9.0*theScalingFactor] forKey:NSFontAttributeName];
	[anOrnementsAttributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
	
	NSMutableDictionary *anEnteteGrandAttributes = [NSMutableDictionary dictionaryWithCapacity:2];
	[anEnteteGrandAttributes setObject:
					[[NSFontManager sharedFontManager] convertFont:[NSFont fontWithName:@"Helvetica" size:12.0*theScalingFactor] toHaveTrait:NSBoldFontMask] 
					forKey:NSFontAttributeName];
	[anEnteteGrandAttributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];

	NSMutableDictionary *anEnteteMoyenAttributes = [NSMutableDictionary dictionaryWithCapacity:2];
	[anEnteteMoyenAttributes setObject:[NSFont fontWithName:@"Helvetica" size:10.0*theScalingFactor] forKey:NSFontAttributeName];
	[anEnteteMoyenAttributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];

	NSMutableDictionary *aTableauEnteteAttributes = [NSMutableDictionary dictionaryWithCapacity:2];
	[aTableauEnteteAttributes setObject:
					[[NSFontManager sharedFontManager] convertFont:[NSFont fontWithName:@"Helvetica" size:9.0*theScalingFactor] toHaveTrait:NSBoldFontMask]
					forKey:NSFontAttributeName];
	[aTableauEnteteAttributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];

	NSMutableDictionary *aTableauLigneAttributes = [NSMutableDictionary dictionaryWithCapacity:2];
	[aTableauLigneAttributes setObject:[NSFont fontWithName:@"Helvetica" size:8.0*theScalingFactor] forKey:NSFontAttributeName];
	[aTableauLigneAttributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];


	// On calcule les tailles
	float coeffOrnementsV = 1.2;
	float coeffEnteteGeneralV = 1.2;
	float coeffTableauV = 1.2;
	float coeffTableauH = 1.2;
	NSString *heightString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
	NSString *dateString = @"08/09/1972";
	NSString *operationString = @"Virement Crediteur";
	NSString *montantString = @"1 000 000,00 E";
	NSString *pointageString = @"***";
	NSString *soldeString = @"10 000 000,00 E";

	ornementsHeight = [heightString sizeWithAttributes:anOrnementsAttributes].height * coeffOrnementsV;
	enteteGrandHeight = [heightString sizeWithAttributes:anEnteteGrandAttributes].height * coeffEnteteGeneralV;
	enteteMoyenHeight = [heightString sizeWithAttributes:anEnteteMoyenAttributes].height * coeffEnteteGeneralV;
	enteteGeneralHeight = enteteGrandHeight * 3 + enteteMoyenHeight * 4;

	tableauEnteteHeight = [heightString sizeWithAttributes:aTableauEnteteAttributes].height * coeffTableauV;
	tableauLigneHeight = [heightString sizeWithAttributes:aTableauLigneAttributes].height * coeffTableauV;

	colDateWidth = [dateString sizeWithAttributes:aTableauLigneAttributes].width * coeffTableauH;
	colOperationWidth = [operationString sizeWithAttributes:aTableauLigneAttributes].width * coeffTableauH;
	colMontantWidth = [montantString sizeWithAttributes:aTableauLigneAttributes].width * coeffTableauH;
	colPointageWidth = [pointageString sizeWithAttributes:aTableauLigneAttributes].width * coeffTableauH;
	colSoldeWidth = [soldeString sizeWithAttributes:aTableauLigneAttributes].width * coeffTableauH;

	colLibelleMinWidth = 0.9 * colSoldeWidth;
	colCategorieMinWidth = 0.6 * colSoldeWidth;

	deltaWidth = thePaperWidth - theLeftMargin - theRightMargin - colDateWidth - colOperationWidth - colLibelleMinWidth 
						- colCategorieMinWidth - 2*colMontantWidth - colPointageWidth - colSoldeWidth;
		
	if (deltaWidth < 0.0) {
		NSLog(@"deltaWidth=%f", deltaWidth);
		[self release];
		return nil;
	}

	colLibelleWidth = colLibelleMinWidth + deltaWidth * 0.6;
	colCategorieWidth = colCategorieMinWidth + deltaWidth * 0.4;
	
	nbElementsFirstPage = (int)floor( (thePaperHeight - theTopMargin - theBottomMargin - enteteGeneralHeight - tableauEnteteHeight) / tableauLigneHeight );
	nbElementsOtherPage = (int)floor( (thePaperHeight - theTopMargin - theBottomMargin - tableauEnteteHeight) / tableauLigneHeight );
	
	int nbElements = [aMouvementsArray count];
	if (nbElements <= nbElementsFirstPage) {
		nbPages = 1;
	}
	else {
		nbPages = 2 + (nbElements - nbElementsFirstPage - 1) / nbElementsOtherPage;
	}
	
	//[self displayDimensions];


	theFrame.origin = NSMakePoint(0.0,0.0);
	theFrame.size.width = thePaperWidth;
	theFrame.size.height = thePaperHeight * nbPages;
	
    if (self = [super initWithFrame:theFrame]) {
		theCompte = [aCompte retain];
		theMouvementsArray = [aMouvementsArray retain];
		theSoldeFormateur = [aSoldeFormateur retain];
		theDateFormateur = [aDateFormateur retain];
		ornementsAttributes= [anOrnementsAttributes retain];
		enteteGrandAttributes = [anEnteteGrandAttributes retain];
		enteteMoyenAttributes = [anEnteteMoyenAttributes retain];
		tableauEnteteAttributes = [aTableauEnteteAttributes retain];
		tableauLigneAttributes = [aTableauLigneAttributes retain];
    }
	
    return self;
}

- (void)dealloc
{
	[theCompte release];
	[theMouvementsArray release];
	[theSoldeFormateur release];
	[theDateFormateur release];
	[ornementsAttributes release];
	[enteteGrandAttributes release];
	[enteteMoyenAttributes release];
	[tableauEnteteAttributes release];
	[tableauLigneAttributes release];
	[super dealloc];
}

- (void)displayDimensions
{
//	NSLog(@"=%f", );

	NSLog(@"******* Dimensions for CBVueImpressionCompte *******");
	NSLog(@"paperWidth=%f", thePaperWidth);
	NSLog(@"paperHeight=%f", thePaperHeight);
	NSLog(@"leftMargin=%f", theLeftMargin);
	NSLog(@"rightMargin=%f", theRightMargin);
	NSLog(@"topMargin=%f", theTopMargin);
	NSLog(@"bottomMargin=%f", theBottomMargin);
	NSLog(@"printScalingFactor=%f", theScalingFactor);
	
	NSLog(@"enteteGrandHeight=%f", enteteGrandHeight);
	NSLog(@"enteteMoyenHeight=%f", enteteMoyenHeight);
	NSLog(@"enteteGeneralHeight=%f", enteteGeneralHeight);
	NSLog(@"tableauEnteteHeight=%f", tableauEnteteHeight);
	NSLog(@"tableauLigneHeight=%f", tableauLigneHeight);

	NSLog(@"deltaWidth=%f", deltaWidth);
	NSLog(@"colDateWidth=%f", colDateWidth);
	NSLog(@"colOperationWidth=%f", colOperationWidth);
	NSLog(@"colLibelleMinWidth=%f", colLibelleMinWidth);
	NSLog(@"colLibelleWidth=%f", colLibelleWidth);
	NSLog(@"colCategorieMinWidth=%f", colCategorieMinWidth);
	NSLog(@"colCategorieWidth=%f", colCategorieWidth);
	NSLog(@"colMontantWidth=%f", colMontantWidth);
	NSLog(@"colPointageWidth=%f", colPointageWidth);
	NSLog(@"colSoldeWidth=%f", colSoldeWidth);

	NSLog(@"nbElementsFirstPage=%d", nbElementsFirstPage);
	NSLog(@"nbElementsOtherPage=%d", nbElementsOtherPage);
	NSLog(@"nbPages=%d", nbPages);
}

- (BOOL)knowsPageRange:(NSRangePointer)range
{
	range->location = 1;
	range->length = nbPages;
	return YES;
}

- (NSRect)rectForPage:(NSInteger)pageNumber
{
	NSRect theResult;
	NSRect theBounds = [self bounds];
	
	theResult.size.width = thePaperWidth;
	theResult.size.height = thePaperHeight;
	theResult.origin.x = NSMinX(theBounds);
	theResult.origin.y = NSMaxY(theBounds) - pageNumber * thePaperHeight;
	return theResult;
}

- (void)elementsIntervalleForPage:(int)indexPage indexMin:(int *)indexElementMinPtr indexMax:(int *)indexElementMaxPtr
{
	*indexElementMinPtr = 0;
	*indexElementMaxPtr = nbElementsFirstPage - 1;
	
	if (indexPage > 1) {
		*indexElementMinPtr += nbElementsFirstPage;
		*indexElementMaxPtr += nbElementsOtherPage;
	}
	if (indexPage > 2) {
		*indexElementMinPtr += nbElementsOtherPage * (indexPage - 2);
		*indexElementMaxPtr += nbElementsOtherPage * (indexPage - 2);
	}
	
	if (*indexElementMaxPtr >= [theMouvementsArray count]) {
		*indexElementMaxPtr = [theMouvementsArray count] - 1;
	}
}

- (void)dessineString:(NSString *)aString inRect:(NSRect)aRect withAttributes:(NSDictionary *)attributes alignRight:(BOOL)alignRight
{
	NSSize mySize = [aString sizeWithAttributes:attributes];
	NSRect drawingRect;
	
	drawingRect.size.width = mySize.width;
	drawingRect.size.height = mySize.height;
	drawingRect.origin.x = aRect.origin.x;
	if (alignRight)
		drawingRect.origin.x = aRect.origin.x + aRect.size.width - mySize.width;
	drawingRect.origin.y = aRect.origin.y + (aRect.size.height - mySize.height) / 2;
	
	[aString drawInRect:NSIntersectionRect(drawingRect, aRect) withAttributes:attributes];
}

- (void)drawRect:(NSRect)drawingRect
{
	int indexPage;
	
	for (indexPage = 1; indexPage <= nbPages; indexPage++) {
		
		NSRect pageRect = [self rectForPage:indexPage];
		if (NSIntersectsRect(drawingRect, pageRect)) {

			NSRect theFrameRect;
			float horizontalPosition;
			float verticalPosition = NSMaxY(pageRect) - theTopMargin;

			// Dessin du haut de page
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(pageRect) + theLeftMargin*0.9, NSMaxY(pageRect) - theTopMargin*0.9) toPoint:NSMakePoint(NSMaxX(pageRect) - theRightMargin*0.9, NSMaxY(pageRect) - theTopMargin*0.9)];
			theFrameRect = NSMakeRect(NSMinX(pageRect) + theLeftMargin, NSMaxY(pageRect) - theTopMargin*0.9, thePaperWidth - theLeftMargin - theRightMargin, ornementsHeight);
			[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBHautPageCompte", nil), [theCompte numeroCompte], [theCompte banque]] inRect:theFrameRect withAttributes:ornementsAttributes alignRight:NO];
			
			// Dessin du bas de page
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(pageRect) + theLeftMargin*0.9, NSMinY(pageRect) + theBottomMargin*0.9) toPoint:NSMakePoint(NSMaxX(pageRect) - theRightMargin*0.9, NSMinY(pageRect) + theBottomMargin*0.9)];
			theFrameRect = NSMakeRect(NSMinX(pageRect) + theLeftMargin, NSMinY(pageRect) + theBottomMargin*0.9 - ornementsHeight, thePaperWidth - theLeftMargin - theRightMargin, ornementsHeight);
			[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBImpressionDate", nil), CBStringFromDate([NSDate date], @"dd/MM/yyyy")] inRect:theFrameRect withAttributes:ornementsAttributes alignRight:NO];
			[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBImpressionNumeroPage", nil), indexPage, nbPages] inRect:theFrameRect withAttributes:ornementsAttributes alignRight:YES];
			

			// Dessin de l'entête générak
			if (indexPage == 1) {
				horizontalPosition = NSMinX(pageRect) + theLeftMargin;
				
				// Numéro de compte
				verticalPosition -= enteteGrandHeight;
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, thePaperWidth - theLeftMargin - theRightMargin, enteteGrandHeight);
				[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBEnteteGeneralCompte", nil), [theCompte numeroCompte]] inRect:theFrameRect withAttributes:enteteGrandAttributes alignRight:NO];

				// Banque
				verticalPosition -= enteteGrandHeight;
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, thePaperWidth - theLeftMargin - theRightMargin, enteteGrandHeight);
				[self dessineString:[theCompte banque] inRect:theFrameRect withAttributes:enteteGrandAttributes alignRight:NO];

				// Solde réel
				verticalPosition -= enteteGrandHeight;
				verticalPosition -= enteteMoyenHeight;
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, thePaperWidth - theLeftMargin - theRightMargin, enteteGrandHeight);
				[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBEnteteGeneralSoldeReel", nil), [theSoldeFormateur stringForObjectValue:[theCompte soldeReel]]] inRect:theFrameRect withAttributes:enteteMoyenAttributes alignRight:NO];

				// Solde banque
				verticalPosition -= enteteMoyenHeight;
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, thePaperWidth - theLeftMargin - theRightMargin, enteteGrandHeight);
				[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBEnteteGeneralSoldeBanque", nil), [theSoldeFormateur stringForObjectValue:[theCompte soldeBanque]]] inRect:theFrameRect withAttributes:enteteMoyenAttributes alignRight:NO];

				// CB en cours
				verticalPosition -= enteteMoyenHeight;
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, thePaperWidth - theLeftMargin - theRightMargin, enteteGrandHeight);
				[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBEnteteGeneralSoldeCBEnCours", nil), [theSoldeFormateur stringForObjectValue:[theCompte soldeCBEnCours]]] inRect:theFrameRect withAttributes:enteteMoyenAttributes alignRight:NO];

				verticalPosition -= enteteMoyenHeight;
			}
			
			// Dessin de l'entête du tableau
			horizontalPosition = NSMinX(pageRect) + theLeftMargin;
			verticalPosition -= tableauEnteteHeight;
			
			
			// Titre de la date
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colDateWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauDate", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:NO];
			horizontalPosition += colDateWidth;

			// Titre de l'opération
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colOperationWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauOperation", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:NO];
			horizontalPosition += colOperationWidth;

			// Titre du libellé
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colLibelleWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauLibelle", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:NO];
			horizontalPosition += colLibelleWidth;

			// Titre de la catégorie
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colCategorieWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauCategorie", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:NO];
			horizontalPosition += colCategorieWidth;

			// Titre du débit
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colMontantWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauDebit", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:YES];
			horizontalPosition += colMontantWidth;

			// Titre du pointage
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colPointageWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauPointage", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:YES];
			horizontalPosition += colPointageWidth;

			// Titre du crédit
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colMontantWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauCredit", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:YES];
			horizontalPosition += colMontantWidth;

			// Titre de l'avoir
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colSoldeWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauAvoir", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:YES];
			//horizontalPosition += colSoldeWidth;
			
			
			
			// Dessin des éléments
			int indexElementMin;
			int indexElementMax;
			[self elementsIntervalleForPage:indexPage indexMin:&indexElementMin indexMax:&indexElementMax];
			//NSLog(@"Page %d : elements %d to %d", indexPage, indexElementMin, indexElementMax);
			
			int indexElement;
			for (indexElement = indexElementMin; indexElement <=indexElementMax; indexElement++) {
				
				CBMouvement *theMouvement = [theMouvementsArray objectAtIndex:indexElement];
				horizontalPosition = NSMinX(pageRect) + theLeftMargin;
				verticalPosition -= tableauLigneHeight;
				
				// Dessin de la date
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colDateWidth, tableauLigneHeight);
				[self dessineString:[theDateFormateur stringForObjectValue:[theMouvement date]] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:NO];
				horizontalPosition += colDateWidth;

				// Dessin de l'opération
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colOperationWidth, tableauLigneHeight);
				[self dessineString:[theMouvement libelleOperation] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:NO];
				horizontalPosition += colOperationWidth;

				// Dessin du libellé
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colLibelleWidth, tableauLigneHeight);
				[self dessineString:[theMouvement libelle] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:NO];
				horizontalPosition += colLibelleWidth;

				// Dessin de la catégorie
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colCategorieWidth, tableauLigneHeight);
				if ([theMouvement categorie] != nil)
					[self dessineString:[[theMouvement categorie] titre] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:NO];
				horizontalPosition += colCategorieWidth;

				// Dessin du débit
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colMontantWidth, tableauLigneHeight);
				if ([theMouvement debit] != nil)
					[self dessineString:[theSoldeFormateur stringForObjectValue:[theMouvement debit]] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:YES];
				horizontalPosition += colMontantWidth;

				// Dessin du pointage
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colPointageWidth, tableauLigneHeight);
				if ([theMouvement pointage])
					[self dessineString:@"*" inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:YES];
				horizontalPosition += colPointageWidth;

				// Dessin du crédit
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colMontantWidth, tableauLigneHeight);
				if ([theMouvement credit] != nil)
					[self dessineString:[theSoldeFormateur stringForObjectValue:[theMouvement credit]] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:YES];
				horizontalPosition += colMontantWidth;

				// Dessin de l'avoir
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colSoldeWidth, tableauLigneHeight);
				[self dessineString:[theSoldeFormateur stringForObjectValue:[theMouvement avoir]] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:YES];
				//horizontalPosition += colSoldeWidth;

			}
		}
	}
}

@end
