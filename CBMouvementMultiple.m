//
//  CBMouvementMultiple.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 27/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBMouvementMultiple.h"


@implementation CBMouvementMultiple

+ (void)initialize {
	[self setKeys:[NSArray arrayWithObjects:@"operation", nil] triggerChangeNotificationsForDependentKey:@"operationIndefinie"];
	[self setKeys:[NSArray arrayWithObjects:@"operation", nil] triggerChangeNotificationsForDependentKey:@"cheque"];
	[self setKeys:[NSArray arrayWithObjects:@"operation", nil] triggerChangeNotificationsForDependentKey:@"chequeEmploiService"];
}

- (id)init
{
    if (self = [super init]) {
		[self setDateUpdate:NO];
		[self setOperationUpdate:NO];
		[self setLibelleUpdate:NO];
		[self setCategorieUpdate:NO];
		[self setMontantUpdate:NO];
		[self setPointageUpdate:NO];
    }
    return self;
}

- (void)setDate:(NSCalendarDate *)aDate
{
	[super setDate:aDate];
	[self setDateUpdate:YES];
}

- (BOOL)dateUpdate
{
	return dateUpdate;
}

- (void)setDateUpdate:(BOOL)aDateUpdate
{
	dateUpdate = aDateUpdate;
}

- (void)setOperation:(CBTypeMouvement)anOperation
{
	[super setOperation:anOperation];
	if (anOperation == CBTypeMouvementIndefini)
		[self setOperationUpdate:NO];
	else
		[self setOperationUpdate:YES];
}

- (BOOL)isOperationIndefinie
{
	return operation == CBTypeMouvementIndefini;
}

- (BOOL)operationUpdate
{
	return operationUpdate;
}

- (void)setOperationUpdate:(BOOL)anOperationUpdate
{
	operationUpdate = anOperationUpdate;
}

- (void)setLibelle:(NSString *)aLibelle
{
	[super setLibelle:aLibelle];
	[self setLibelleUpdate:YES];
}

- (BOOL)libelleUpdate
{
	return libelleUpdate;
}

- (void)setLibelleUpdate:(BOOL)aLibelleUpdate
{
	libelleUpdate = aLibelleUpdate;
}

- (void)setCategorie:(CBCategorieMouvement *)aCategorie
{
	[super setCategorie:aCategorie];
	[self setCategorieUpdate:YES];
}

- (BOOL)categorieUpdate
{
	return categorieUpdate;
}

- (void)setCategorieUpdate:(BOOL)aCategorieUpdate
{
	categorieUpdate = aCategorieUpdate;
}

- (void)setMontant:(NSDecimalNumber *)aMontant
{
	[super setMontant:aMontant];
	[self setMontantUpdate:YES];
}

- (BOOL)montantUpdate
{
	return montantUpdate;
}

- (void)setMontantUpdate:(BOOL)aMontantUpdate
{
	montantUpdate = aMontantUpdate;
}

- (void)setPointage:(BOOL)aPointage
{
	[super setPointage:aPointage];
	[self setPointageUpdate:YES];
}

- (BOOL)pointageUpdate
{
	return pointageUpdate;
}

- (void)setPointageUpdate:(BOOL)aPointageUpdate
{
	pointageUpdate = aPointageUpdate;
}

- (void)copieParametresDepuisArray:(NSArray *)aMouvementsArray
{
	BOOL isFirstMouvement = YES;
	
	NSCalendarDate *myCommonDate = nil;
	BOOL isCommonDate = NO;
	CBTypeMouvement myCommonOperation = CBTypeMouvementIndefini;
	BOOL isCommonOperation = NO;
	NSString *myCommonLibelle = nil;
	BOOL isCommonLibelle = NO;
	CBCategorieMouvement *myCommonCategorie = nil;
	BOOL isCommonCategorie = NO;
	NSDecimalNumber *myCommonMontant = nil;
	BOOL isCommonMontant = NO;

	NSEnumerator *enumerator = [aMouvementsArray objectEnumerator];
	CBMouvement *anObject;
	while (anObject = [enumerator nextObject]) {
		
		if (isFirstMouvement) {
			myCommonDate = [anObject date];
			isCommonDate = YES;
		}
		else if ([myCommonDate dayOfCommonEra] != [[anObject date] dayOfCommonEra]) {
			isCommonDate = NO;
		}

		if (isFirstMouvement) {
			myCommonOperation = [anObject operation];
			isCommonOperation = YES;
		}
		else if (myCommonOperation != [anObject operation]) {
			isCommonOperation = NO;
		}

		if (isFirstMouvement) {
			myCommonLibelle = [anObject libelle];
			isCommonLibelle = YES;
		}
		else if (![myCommonLibelle isEqualToString:[anObject libelle]]) {
			isCommonLibelle = NO;
		}

		if (isFirstMouvement) {
			myCommonCategorie = [anObject categorie];
			isCommonCategorie = YES;
		}
		else if (myCommonCategorie != [anObject categorie]) {
			isCommonCategorie = NO;
		}

		if (isFirstMouvement) {
			myCommonMontant = [anObject montant];
			isCommonMontant = YES;
		}
		else if ([myCommonMontant compare:[anObject montant]] != NSOrderedSame) {
			isCommonMontant = NO;
		}
		
		isFirstMouvement = NO;
	}

	if (isCommonDate) {
		[self setDate:myCommonDate];
		[self setDateUpdate:NO];
	}

	if (isCommonOperation) {
		[self setOperation:myCommonOperation];
		[self setOperationUpdate:NO];
	}

	if (isCommonLibelle) {
		[self setLibelle:myCommonLibelle];
		[self setLibelleUpdate:NO];
	}

	if (isCommonCategorie) {
		[self setCategorie:myCommonCategorie];
		[self setCategorieUpdate:NO];
	}

	if (isCommonMontant) {
		[self setMontant:myCommonMontant];
		[self setMontantUpdate:NO];
	}

}

@end
