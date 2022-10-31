//
//  CBMouvementsArrayController.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 23/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBMouvementsArrayController.h"
#import "CBMouvement.h"


@implementation CBMouvementsArrayController

- (void)awakeFromNib
{
	nonPointes = NO;
	operation = CBTypeMouvementIndefini;
	searchString = nil;
	[self setSoldeMouvementsFiltres:nil];
}

- (void)dealloc
{
	[searchString release];
	[soldeMouvementsFiltres release];
	[super dealloc];
}

- (BOOL)isFiltrage
{
	if ( nonPointes || (operation != CBTypeMouvementIndefini) || (searchString != nil) )
		return YES;
	else
		return NO;
}

- (NSDecimalNumber *)soldeMouvementsFiltres
{
	return [[soldeMouvementsFiltres copy] autorelease];
}

- (void)setSoldeMouvementsFiltres:(NSDecimalNumber *)aSoldeMouvementsFiltres
{
	[soldeMouvementsFiltres autorelease];
	soldeMouvementsFiltres = [aSoldeMouvementsFiltres copy];
}

- (IBAction)filtreMouvementsPointage:(id)sender
{
	nonPointes = [sender state] == NSControlStateValueOn;

	[self rearrangeObjects];
}

- (IBAction)filtreMouvementsOperation:(id)sender
{
	operation = (CBTypeMouvement)[[sender selectedItem]tag];

	[self rearrangeObjects];
}

- (IBAction)filtreMouvementsMotClef:(id)sender
{
	[searchString autorelease];
	if ([sender stringValue] != nil && [[sender stringValue] length] > 0)
		searchString = [[sender stringValue] copy];
	else
		searchString = nil;

	[self rearrangeObjects];
}

- (void)calculeSoldeMouvementsFiltres:(NSArray *)mouvementsFiltresArray
{
    NSDecimal soldeMouvementsFiltresDecimal;
	NSDecimal montantAvecSigne;
	
	soldeMouvementsFiltresDecimal = [[NSDecimalNumber zero] decimalValue];
	
	NSEnumerator *enumerator = [mouvementsFiltresArray objectEnumerator];
	CBMouvement *anObject;
	while (anObject = (CBMouvement *)[enumerator nextObject]) {

		if (CBSignePourTypeMouvement([anObject operation]) == CBSigneMouvementDebit)
			montantAvecSigne = [[[NSDecimalNumber zero] decimalNumberBySubtracting:[anObject montant]] decimalValue];
		else if (CBSignePourTypeMouvement([anObject operation]) == CBSigneMouvementCredit)
			montantAvecSigne = [[anObject montant] decimalValue];
		else
			montantAvecSigne = [[NSDecimalNumber zero] decimalValue];
		
		NSDecimalAdd(&soldeMouvementsFiltresDecimal, &soldeMouvementsFiltresDecimal, &montantAvecSigne, NSRoundPlain);
	}
	
	NSDecimalCompact(&soldeMouvementsFiltresDecimal);
	[self setSoldeMouvementsFiltres:[NSDecimalNumber decimalNumberWithDecimal:soldeMouvementsFiltresDecimal]];
}

- (NSArray *)arrangeObjects:(NSArray *)objects
{
	BOOL condPointage;
	BOOL condOperation;
	BOOL condLibelles;
	
	NSMutableArray *filteredObjects = [NSMutableArray arrayWithCapacity:[objects count]];
	NSEnumerator *objectsEnumerator = [objects objectEnumerator];
	CBMouvement *item;

	while (item = (CBMouvement *)[objectsEnumerator nextObject]) {
	
		condPointage = YES;
		condOperation = YES;
		condLibelles = YES;
		
		if (nonPointes && [item pointage])
			condPointage = NO;

		if (operation != CBTypeMouvementIndefini && operation != [item operation])
			condOperation = NO;
		
		if (searchString != nil) {
			condLibelles = NO;
			if ([[item libelle] rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
				condLibelles = YES;
			if ([item categorie] != nil && [[[item categorie] titre] rangeOfString:searchString options:NSCaseInsensitiveSearch].location != NSNotFound)
				condLibelles = YES;
		}

		if (condPointage && condOperation && condLibelles)
			[filteredObjects addObject:item];

	}

	if ([self isFiltrage] && [filteredObjects count] > 0)
		[self calculeSoldeMouvementsFiltres:filteredObjects];
	else
		[self setSoldeMouvementsFiltres:nil];

	return [super arrangeObjects:filteredObjects];
}

@end
