//
//  CBStatistiques.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 04/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBStatistiques.h"
#import "CBStatistiqueCategorie.h"


@implementation CBStatistiques

- (id)init
{
	if (self = [super init]) {
		[self setSoldeDebiteurPeriode:[NSDecimalNumber zero]];
		[self setSoldeDebiteurMensuel:[NSDecimalNumber zero]];
		[self setSoldeCrediteurPeriode:[NSDecimalNumber zero]];
		[self setSoldeCrediteurMensuel:[NSDecimalNumber zero]];
		statistiquesCategories = [[NSMutableArray alloc] initWithCapacity:7];
	}
	return self;
}

- (void)dealloc
{
	[soldeDebiteurPeriode release];
	[soldeDebiteurMensuel release];
	[soldeCrediteurPeriode release];
	[soldeCrediteurMensuel release];
	[statistiquesCategories release];
	[super dealloc];
}

- (void)ajouteMontant:(NSDecimalNumber *)aMontant pourCategorie:(CBCategorieMouvement *)aCategorie 
													nombreMoisPeriode:(NSDecimalNumber *)aNombreMoisPeriode
{
	int index = NSNotFound;
	CBStatistiqueCategorie *myStatCategorie;
	
	NSEnumerator *enumerator = [statistiquesCategories objectEnumerator];
	id anObject;
	while (anObject = [enumerator nextObject]) {
		
		if ([anObject categorie] == aCategorie) {
			index = [statistiquesCategories indexOfObjectIdenticalTo:anObject];
			break;
		}
	}
	
	if (index == NSNotFound) {
		myStatCategorie = [[[CBStatistiqueCategorie alloc] initWithCategorie:aCategorie nombreMoisPeriode:aNombreMoisPeriode] autorelease];
		[statistiquesCategories addObject:myStatCategorie];
	}
	else {
		myStatCategorie = [statistiquesCategories objectAtIndex:index];
	}
	
	[myStatCategorie ajouteMontant:aMontant];
}

- (NSDecimalNumber *)soldeDebiteurPeriode
{
	return [[soldeDebiteurPeriode copy] autorelease];
}

- (void)setSoldeDebiteurPeriode:(NSDecimalNumber *)aSoldeDebiteurPeriode
{
	[soldeDebiteurPeriode autorelease];
	soldeDebiteurPeriode = [aSoldeDebiteurPeriode copy];
}

- (NSDecimalNumber *)soldeDebiteurMensuel
{
	return [[soldeDebiteurMensuel copy] autorelease];
}

- (void)setSoldeDebiteurMensuel:(NSDecimalNumber *)aSoldeDebiteurMensuel
{
	[soldeDebiteurMensuel autorelease];
	soldeDebiteurMensuel = [aSoldeDebiteurMensuel copy];
}

- (NSDecimalNumber *)soldeCrediteurPeriode
{
	return [[soldeCrediteurPeriode copy] autorelease];
}

- (void)setSoldeCrediteurPeriode:(NSDecimalNumber *)aSoldeCrediteurPeriode
{
	[soldeCrediteurPeriode autorelease];
	soldeCrediteurPeriode = [aSoldeCrediteurPeriode copy];
}

- (NSDecimalNumber *)soldeCrediteurMensuel
{
	return [[soldeCrediteurMensuel copy] autorelease];
}

- (void)setSoldeCrediteurMensuel:(NSDecimalNumber *)aSoldeCrediteurMensuel
{
	[soldeCrediteurMensuel autorelease];
	soldeCrediteurMensuel = [aSoldeCrediteurMensuel copy];
}

- (NSMutableArray *)statistiquesCategories
{
	return statistiquesCategories;
}

@end
