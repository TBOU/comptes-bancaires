//
//  CBMouvement.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBMouvement.h"
#import "CBMouvementMultiple.h"


@implementation CBMouvement

+ (NSSet *)keyPathsForValuesAffectingLibelleOperation
{
	return [NSSet setWithObjects:@"operation", @"numeroCheque", @"numeroChequeEmploiService", nil];
}

+ (NSSet *)keyPathsForValuesAffectingDebit
{
	return [NSSet setWithObjects:@"operation", @"montant", nil];
}

+ (NSSet *)keyPathsForValuesAffectingCredit
{
	return [NSSet setWithObjects:@"operation", @"montant", nil];
}

+ (NSSet *)keyPathsForValuesAffectingCheque
{
	return [NSSet setWithObjects:@"operation", nil];
}

+ (NSSet *)keyPathsForValuesAffectingChequeEmploiService
{
	return [NSSet setWithObjects:@"operation", nil];
}

- (id)init
{
    if (self = [super init]) {
		[self setDate:[NSDate date]];
		[self setOperation:CBTypeMouvementIndefini];
		[self setLibelle:NSLocalizedString(@"CBDefautLibelleMouvement", nil)];
		[self setCategorie:nil];
		[self setMontant:[NSDecimalNumber zero]];
		[self setPointage:NO];
		[self setAvoir:[NSDecimalNumber zero]];
		[self setNumeroCheque:[NSNumber numberWithLongLong:0]];
		[self setNumeroChequeEmploiService:[NSNumber numberWithLongLong:0]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
		[self setDate:[decoder decodeObjectForKey:@"date"]];
		[self setOperation:[decoder decodeIntForKey:@"operation"]];
		[self setLibelle:[decoder decodeObjectForKey:@"libelle"]];
		[self setCategorie:[decoder decodeObjectForKey:@"categorie"]];
		[self setMontant:[decoder decodeObjectForKey:@"montant"]];
		[self setPointage:[decoder decodeBoolForKey:@"pointage"]];
		[self setAvoir:[decoder decodeObjectForKey:@"avoir"]];
		[self setNumeroCheque:[decoder decodeObjectForKey:@"numeroCheque"]];
		[self setNumeroChequeEmploiService:[decoder decodeObjectForKey:@"numeroChequeEmploiService"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:date forKey:@"date"];
	[encoder encodeInt:operation forKey:@"operation"];
	[encoder encodeObject:libelle forKey:@"libelle"];
	[encoder encodeObject:categorie forKey:@"categorie"];
	[encoder encodeObject:montant forKey:@"montant"];
	[encoder encodeBool:pointage forKey:@"pointage"];
	[encoder encodeObject:avoir forKey:@"avoir"];
	[encoder encodeObject:numeroCheque forKey:@"numeroCheque"];
	[encoder encodeObject:numeroChequeEmploiService forKey:@"numeroChequeEmploiService"];
}

- (id)initWithXMLUnarchiver:(CBXMLUnarchiver *)xmlUnarchiver
{
	id decodedObject;
	int decodedInt;
	
    if (self = [self init]) {
	
		decodedObject = [xmlUnarchiver decodeCalendarDateForKey:@"date"];
		if (decodedObject != nil)
			[self setDate:decodedObject];

		decodedInt = [xmlUnarchiver decodeIntForKey:@"operation"];
		if (CBTypeMouvementCorrect(decodedInt))
			[self setOperation:decodedInt];

		decodedObject = [xmlUnarchiver decodeStringForKey:@"libelle"];
		if (decodedObject != nil)
			[self setLibelle:decodedObject];

		decodedObject = [xmlUnarchiver decodeObjectReferenceForKey:@"categorie"];
		if (decodedObject != nil)
			[self setCategorie:decodedObject];

		decodedObject = [xmlUnarchiver decodeDecimalNumberForKey:@"montant"];
		if (decodedObject != nil)
			[self setMontant:decodedObject];

		[self setPointage:[xmlUnarchiver decodeBoolForKey:@"pointage"]];
		
		decodedObject = [xmlUnarchiver decodeNumberForKey:@"numeroCheque"];
		if (decodedObject != nil)
			[self setNumeroCheque:decodedObject];

		decodedObject = [xmlUnarchiver decodeNumberForKey:@"numeroChequeEmploiService"];
		if (decodedObject != nil)
			[self setNumeroChequeEmploiService:decodedObject];
    }
    return self;
}

- (void)encodeWithXMLArchiver:(CBXMLArchiver *)xmlArchiver
{
	[xmlArchiver encodeCalendarDate:date forKey:@"date"];
	[xmlArchiver encodeInt:operation forKey:@"operation"];
	[xmlArchiver encodeString:libelle forKey:@"libelle"];
	[xmlArchiver encodeXMLCodingObject:categorie forKey:@"categorie" withID:NO];
	[xmlArchiver encodeDecimalNumber:montant forKey:@"montant"];
	[xmlArchiver encodeBool:pointage forKey:@"pointage"];
	[xmlArchiver encodeDecimalNumber:avoir forKey:@"avoir"];
	[xmlArchiver encodeNumber:numeroCheque forKey:@"numeroCheque"];
	[xmlArchiver encodeNumber:numeroChequeEmploiService forKey:@"numeroChequeEmploiService"];
}

- (void)dealloc
{
	[date release];
	[libelle release];
	[categorie unregisterLien:self];
	[categorie release];
	[montant release];
	[avoir release];
	[numeroCheque release];
	[numeroChequeEmploiService release];
	[super dealloc];
}

- (NSDate *)date
{
	return [[date copy] autorelease];
}

- (void)setDate:(NSDate *)aDate
{
	[date autorelease];
	date = [aDate copy];
}

- (CBTypeMouvement)operation
{
	return operation;
}

- (void)setOperation:(CBTypeMouvement)anOperation
{
	operation = anOperation;
}

- (NSString *)libelleOperation
{
	return CBLibellePourTypeMouvement(operation, numeroCheque, numeroChequeEmploiService);
}

- (NSString *)libelle
{
	return [[libelle copy] autorelease];
}

- (void)setLibelle:(NSString *)aLibelle
{
	[libelle autorelease];
	libelle = [aLibelle copy];
}

- (CBCategorieMouvement *)categorie
{
//	"categorie" est un objet partagé
	return categorie;
}

- (void)setCategorie:(CBCategorieMouvement *)aCategorie
{
//	"categorie" est un objet partagé
	[categorie unregisterLien:self];
	[categorie autorelease];
	categorie = [aCategorie retain];
	[categorie registerLien:self];
}

- (NSDecimalNumber *)montant
{
	return [[montant copy] autorelease];
}

- (void)setMontant:(NSDecimalNumber *)aMontant
{
	[montant autorelease];
	montant = [aMontant copy];
}

- (NSDecimalNumber *)debit
{
	if (CBSignePourTypeMouvement(operation) == CBSigneMouvementDebit)
		return [[montant copy] autorelease];
	else
		return nil;
}

- (NSDecimalNumber *)credit
{
	if (CBSignePourTypeMouvement(operation) == CBSigneMouvementCredit)
		return [[montant copy] autorelease];
	else
		return nil;
}

- (BOOL)pointage
{
	return pointage;
}

- (void)setPointage:(BOOL)aPointage
{
	pointage = aPointage;
}

- (void)togglePointage
{
	[self setPointage:![self pointage]];
}

- (NSDecimalNumber *)avoir
{
	return [[avoir copy] autorelease];
}

- (void)setAvoir:(NSDecimalNumber *)anAvoir
{
	[avoir autorelease];
	avoir = [anAvoir copy];
}

- (NSNumber *)numeroCheque
{
	return [[numeroCheque copy] autorelease];
}

- (void)setNumeroCheque:(NSNumber *)aNumeroCheque
{
	[numeroCheque autorelease];
	numeroCheque = [aNumeroCheque copy];
}

- (BOOL)isCheque
{
	return operation == CBTypeMouvementCheque;
}

- (NSNumber *)numeroChequeEmploiService
{
	return [[numeroChequeEmploiService copy] autorelease];
}

- (void)setNumeroChequeEmploiService:(NSNumber *)aNumeroChequeEmploiService
{
	[numeroChequeEmploiService autorelease];
	numeroChequeEmploiService = [aNumeroChequeEmploiService copy];
}

- (BOOL)isChequeEmploiService
{
	return operation == CBTypeMouvementChequeEmploiService;
}

- (void)setNilValueForKey:(NSString *)theKey
{
	if ([theKey isEqualToString:@"operation"]) {
		[self setOperation:CBTypeMouvementIndefini];
	}
	else if ([theKey isEqualToString:@"pointage"]) {
		[self setPointage:NO];
	}
	else {
		[super setNilValueForKey:theKey];
	}
}

- (void)copieParametresDepuis:(CBMouvement *)aMouvement
{
	[self setDate:[aMouvement date]];
	[self setOperation:[aMouvement operation]];
	[self setLibelle:[aMouvement libelle]];
	[self setCategorie:[aMouvement categorie]];
	[self setMontant:[aMouvement montant]];
	[self setPointage:[aMouvement pointage]];
	[self setNumeroCheque:[aMouvement numeroCheque]];
	[self setNumeroChequeEmploiService:[aMouvement numeroChequeEmploiService]];
}

- (void)copieParametresDepuisMultiple:(CBMouvementMultiple *)aMouvementMultiple
{
	if ([aMouvementMultiple dateUpdate]) {
		[self setDate:[aMouvementMultiple date]];
	}
	if ([aMouvementMultiple operationUpdate]) {
		[self setOperation:[aMouvementMultiple operation]];
		[self setNumeroCheque:[aMouvementMultiple numeroCheque]];
		[self setNumeroChequeEmploiService:[aMouvementMultiple numeroChequeEmploiService]];
	}
	if ([aMouvementMultiple libelleUpdate]) {
		[self setLibelle:[aMouvementMultiple libelle]];
	}
	if ([aMouvementMultiple categorieUpdate]) {
		[self setCategorie:[aMouvementMultiple categorie]];
	}
	if ([aMouvementMultiple montantUpdate]) {
		[self setMontant:[aMouvementMultiple montant]];
	}
	if ([aMouvementMultiple pointageUpdate]) {
		[self setPointage:[aMouvementMultiple pointage]];
	}
}

- (void)categorieMouvementWillDealloc:(NSNotification *)aNotification
{
	[self setCategorie:nil];
}

@end
