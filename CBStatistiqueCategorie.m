//
//  CBStatistiqueCategorie.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 04/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBStatistiqueCategorie.h"


@implementation CBStatistiqueCategorie

- (id)initWithCategorie:(CBCategorieMouvement *)aCategorie nombreMoisPeriode:(NSDecimalNumber *)aNombreMoisPeriode
{
	if (self = [super init]) {
		categorie = [aCategorie retain];
		[self setSoldePeriode:[NSDecimalNumber zero]];
		nombreMoisPeriode = [aNombreMoisPeriode copy];
		[self setSoldeMensuel:[NSDecimalNumber zero]];
	}
	return self;
}

- (void)dealloc
{
	[categorie release];
	[soldePeriode release];
	[nombreMoisPeriode release];
	[soldeMensuel release];
	[super dealloc];
}

- (void)ajouteMontant:(NSDecimalNumber *)aMontant
{
	[self setSoldePeriode:[[self soldePeriode] decimalNumberByAdding:aMontant]];
	
	if (nombreMoisPeriode != nil) {
		[self setSoldeMensuel:[[self soldePeriode] decimalNumberByDividingBy:nombreMoisPeriode]];
	}
	else {
		[self setSoldeMensuel:nil];
	}
}

- (CBCategorieMouvement *)categorie
{
	return categorie;
}

- (NSDecimalNumber *)soldePeriode
{
	return [[soldePeriode copy] autorelease];
}

- (void)setSoldePeriode:(NSDecimalNumber *)aSoldePeriode
{
	[soldePeriode autorelease];
	soldePeriode = [aSoldePeriode copy];
}

- (NSDecimalNumber *)soldeMensuel
{
	return [[soldeMensuel copy] autorelease];
}

- (void)setSoldeMensuel:(NSDecimalNumber *)aSoldeMensuel
{
	[soldeMensuel autorelease];
	soldeMensuel = [aSoldeMensuel copy];
}

@end
