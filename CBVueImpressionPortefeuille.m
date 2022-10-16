//
//  CBVueImpressionPortefeuille.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 21/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBVueImpressionPortefeuille.h"
#include <math.h>


@implementation CBVueImpressionPortefeuille

- (id)initWithPortefeuille:(CBPortefeuille *)aPortefeuille comptes:(NSArray *)aComptesArray printInfo:(NSPrintInfo *)pInfo nombreFormatter:(CBNombreFormatter *)aSoldeFormateur
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

	NSMutableDictionary *aTableauLigneAttributes = [NSMutableDictionary dictionaryWithCapacity:2];
	[aTableauLigneAttributes setObject:[NSFont fontWithName:@"Helvetica" size:8.0*theScalingFactor] forKey:NSFontAttributeName];
	[aTableauLigneAttributes setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];


	// On calcule les tailles
	float coeffOrnementsV = 1.2;
	float coeffEnteteGeneralV = 1.2;
	float coeffTableauV = 1.2;
	float coeffTableauH = 1.2;
	NSString *heightString = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890";
	NSString *soldeString = @"10 000 000,00 E";
	
	ornementsHeight = [heightString sizeWithAttributes:anOrnementsAttributes].height * coeffOrnementsV;
	enteteGrandHeight = [heightString sizeWithAttributes:anEnteteGrandAttributes].height * coeffEnteteGeneralV;
	enteteMoyenHeight = [heightString sizeWithAttributes:anEnteteMoyenAttributes].height * coeffEnteteGeneralV;
	enteteGeneralHeight = enteteGrandHeight * 2 + enteteMoyenHeight * 2;

	tableauEnteteHeight = [heightString sizeWithAttributes:aTableauEnteteAttributes].height * coeffTableauV;
	tableauLigneHeight = [heightString sizeWithAttributes:aTableauLigneAttributes].height * coeffTableauV;

	colSoldeWidth = [soldeString sizeWithAttributes:aTableauLigneAttributes].width * coeffTableauH;

	colBanqueMinWidth = 1.8 * colSoldeWidth;
	colNumeroCompteMinWidth = 1.2 * colSoldeWidth;

	deltaWidth = thePaperWidth - theLeftMargin - theRightMargin - colBanqueMinWidth - colNumeroCompteMinWidth - 2*colSoldeWidth;
	
	if (deltaWidth < 0.0) {
		NSLog(@"deltaWidth=%f", deltaWidth);
		[self release];
		return nil;
	}

	colBanqueWidth = colBanqueMinWidth + deltaWidth * 0.6;
	colNumeroCompteWidth = colNumeroCompteMinWidth + deltaWidth * 0.4;

	nbElementsFirstPage = (int)floor( (thePaperHeight - theTopMargin - theBottomMargin - enteteGeneralHeight - tableauEnteteHeight) / tableauLigneHeight );
	nbElementsOtherPage = (int)floor( (thePaperHeight - theTopMargin - theBottomMargin - tableauEnteteHeight) / tableauLigneHeight );
	
	int nbElements = [aComptesArray count];
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
		thePortefeuille = [aPortefeuille retain];
		theComptesArray = [aComptesArray retain];
		theSoldeFormateur = [aSoldeFormateur retain];
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
	[thePortefeuille release];
	[theComptesArray release];
	[theSoldeFormateur release];
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

	NSLog(@"******* Dimensions for CBVueImpressionPortefeuille *******");
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
	NSLog(@"colBanqueMinWidth=%f", colBanqueMinWidth);
	NSLog(@"colBanqueWidth=%f", colBanqueWidth);
	NSLog(@"colNumeroCompteMinWidth=%f", colNumeroCompteMinWidth);
	NSLog(@"colNumeroCompteWidth=%f", colNumeroCompteWidth);
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

- (NSRect)rectForPage:(int)pageNumber
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
	
	if (*indexElementMaxPtr >= [theComptesArray count]) {
		*indexElementMaxPtr = [theComptesArray count] - 1;
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
			[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBHautPagePortefeuille", nil), [thePortefeuille nomPrenom]] inRect:theFrameRect withAttributes:ornementsAttributes alignRight:NO];
			
			// Dessin du bas de page
			[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(pageRect) + theLeftMargin*0.9, NSMinY(pageRect) + theBottomMargin*0.9) toPoint:NSMakePoint(NSMaxX(pageRect) - theRightMargin*0.9, NSMinY(pageRect) + theBottomMargin*0.9)];
			theFrameRect = NSMakeRect(NSMinX(pageRect) + theLeftMargin, NSMinY(pageRect) + theBottomMargin*0.9 - ornementsHeight, thePaperWidth - theLeftMargin - theRightMargin, ornementsHeight);
			[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBImpressionDate", nil), [[NSCalendarDate calendarDate] descriptionWithCalendarFormat:@"%d/%m/%Y"]] inRect:theFrameRect withAttributes:ornementsAttributes alignRight:NO];
			[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBImpressionNumeroPage", nil), indexPage, nbPages] inRect:theFrameRect withAttributes:ornementsAttributes alignRight:YES];
			

			// Dessin de l'entête générak
			if (indexPage == 1) {
				horizontalPosition = NSMinX(pageRect) + theLeftMargin;
				
				// Prénom et nom
				verticalPosition -= enteteGrandHeight;
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, thePaperWidth - theLeftMargin - theRightMargin, enteteGrandHeight);
				[self dessineString:[thePortefeuille nomPrenom] inRect:theFrameRect withAttributes:enteteGrandAttributes alignRight:NO];

				// Solde total des comptes
				verticalPosition -= enteteGrandHeight;
				verticalPosition -= enteteMoyenHeight;
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, thePaperWidth - theLeftMargin - theRightMargin, enteteGrandHeight);
				[self dessineString:[NSString stringWithFormat:NSLocalizedString(@"CBEnteteGeneralSoldeTotal", nil), [theSoldeFormateur stringForObjectValue:[thePortefeuille soldeTotalComptes]]] inRect:theFrameRect withAttributes:enteteMoyenAttributes alignRight:NO];

				verticalPosition -= enteteMoyenHeight;
			}
			
			// Dessin de l'entête du tableau
			horizontalPosition = NSMinX(pageRect) + theLeftMargin;
			verticalPosition -= tableauEnteteHeight;
			
			
			// Titre de la banque
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colBanqueWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauBanque", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:NO];
			horizontalPosition += colBanqueWidth;

			// Titre du numéro de compte
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colNumeroCompteWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauNumeroCompte", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:NO];
			horizontalPosition += colNumeroCompteWidth;

			// Titre du solde réel
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colSoldeWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauSoldeReel", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:YES];
			horizontalPosition += colSoldeWidth;

			// Titre du solde banque
			theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colSoldeWidth, tableauLigneHeight);
			[self dessineString:NSLocalizedString(@"CBEnteteTableauSoldeBanque", nil) inRect:theFrameRect withAttributes:tableauEnteteAttributes alignRight:YES];
			horizontalPosition += colSoldeWidth;
			
			
			
			// Dessin des éléments
			int indexElementMin;
			int indexElementMax;
			[self elementsIntervalleForPage:indexPage indexMin:&indexElementMin indexMax:&indexElementMax];
			//NSLog(@"Page %d : elements %d to %d", indexPage, indexElementMin, indexElementMax);
			
			int indexElement;
			for (indexElement = indexElementMin; indexElement <=indexElementMax; indexElement++) {
				
				CBCompte *theCompte = [theComptesArray objectAtIndex:indexElement];
				horizontalPosition = NSMinX(pageRect) + theLeftMargin;
				verticalPosition -= tableauLigneHeight;
				
				// Dessin de la banque
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colBanqueWidth, tableauLigneHeight);
				[self dessineString:[theCompte banque] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:NO];
				horizontalPosition += colBanqueWidth;

				// Dessin du numéro de compte
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colNumeroCompteWidth, tableauLigneHeight);
				[self dessineString:[theCompte numeroCompte] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:NO];
				horizontalPosition += colNumeroCompteWidth;

				// Dessin du solde réel
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colSoldeWidth, tableauLigneHeight);
				[self dessineString:[theSoldeFormateur stringForObjectValue:[theCompte soldeReel]] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:YES];
				horizontalPosition += colSoldeWidth;

				// Dessin du solde banque
				theFrameRect = NSMakeRect(horizontalPosition, verticalPosition, colSoldeWidth, tableauLigneHeight);
				[self dessineString:[theSoldeFormateur stringForObjectValue:[theCompte soldeBanque]] inRect:theFrameRect withAttributes:tableauLigneAttributes alignRight:YES];
				horizontalPosition += colSoldeWidth;

			}
		}
	}
}

@end
