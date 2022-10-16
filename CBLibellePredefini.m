//
//  CBLibellePredefini.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 11/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBLibellePredefini.h"


@implementation CBLibellePredefini

- (id)init
{
    if (self = [super init]) {
		[self setOperation:CBTypeMouvementIndefini];
		[self setLibelle:NSLocalizedString(@"CBDefautLibellePredefini", nil)];
		[self setMontant:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
		[self setOperation:[decoder decodeIntForKey:@"operation"]];
		[self setLibelle:[decoder decodeObjectForKey:@"libelle"]];
		[self setMontant:[decoder decodeObjectForKey:@"montant"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeInt:operation forKey:@"operation"];
	[encoder encodeObject:libelle forKey:@"libelle"];
	[encoder encodeObject:montant forKey:@"montant"];
}

- (id)initWithXMLUnarchiver:(CBXMLUnarchiver *)xmlUnarchiver
{
	id decodedObject;
	int decodedInt;
	
    if (self = [self init]) {
	
		decodedInt = [xmlUnarchiver decodeIntForKey:@"operation"];
		if (CBTypeMouvementCorrect(decodedInt))
			[self setOperation:decodedInt];

		decodedObject = [xmlUnarchiver decodeStringForKey:@"libelle"];
		if (decodedObject != nil)
			[self setLibelle:decodedObject];

		decodedObject = [xmlUnarchiver decodeDecimalNumberForKey:@"montant"];
		if (decodedObject != nil)
			[self setMontant:decodedObject];
		
    }
    return self;
}

- (void)encodeWithXMLArchiver:(CBXMLArchiver *)xmlArchiver
{
	[xmlArchiver encodeInt:operation forKey:@"operation"];
	[xmlArchiver encodeString:libelle forKey:@"libelle"];
	[xmlArchiver encodeDecimalNumber:montant forKey:@"montant"];
}

- (void)dealloc
{
	[libelle release];
	[montant release];
	[super dealloc];
}

- (CBTypeMouvement)operation
{
	return operation;
}

- (void)setOperation:(CBTypeMouvement)anOperation
{
	operation = anOperation;
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

- (NSDecimalNumber *)montant
{
	return [[montant copy] autorelease];
}

- (void)setMontant:(NSDecimalNumber *)aMontant
{
	[montant autorelease];
	montant = [aMontant copy];
}

@end
