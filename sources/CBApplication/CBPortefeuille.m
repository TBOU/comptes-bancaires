//
//  CBPortefeuille.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBPortefeuille.h"
#import "CBCompte.h"
#import "CBCategorieMouvement.h"


@implementation CBPortefeuille

+ (NSSet *)keyPathsForValuesAffectingNomPrenom
{
	return [NSSet setWithObjects:@"nom", @"prenom", nil];
}

- (id)init
{
    if (self = [super init]) {
		[self setNom:NSLocalizedString(@"CBDefautNomPortefeuille", nil)];
		[self setPrenom:NSLocalizedString(@"CBDefautPrenomPortefeuille", nil)];
		[self setSymboleMonetaire:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]];
        [self setVerifieEcrituresAutomatiquesEnSuspens:YES];
		categoriesMouvement = [[NSMutableArray alloc] initWithCapacity:7];
		comptes = [[NSMutableArray alloc] initWithCapacity:7];
		[self setSoldeTotalComptes:[NSDecimalNumber zero]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
		[self setNom:[decoder decodeObjectForKey:@"nom"]];
		[self setPrenom:[decoder decodeObjectForKey:@"prenom"]];
		[self setSymboleMonetaire:[decoder decodeObjectForKey:@"symboleMonetaire"]];
        
        if ([decoder containsValueForKey:@"verifieEcrituresAutomatiquesEnSuspens"]) {
            [self setVerifieEcrituresAutomatiquesEnSuspens:[decoder decodeBoolForKey:@"verifieEcrituresAutomatiquesEnSuspens"]];
        }
        else {
            [self setVerifieEcrituresAutomatiquesEnSuspens:YES];
        }
        
		categoriesMouvement = [[decoder decodeObjectForKey:@"categoriesMouvement"] retain];
		comptes = [[decoder decodeObjectForKey:@"comptes"] retain];
		[self setSoldeTotalComptes:[decoder decodeObjectForKey:@"soldeTotalComptes"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:nom forKey:@"nom"];
	[encoder encodeObject:prenom forKey:@"prenom"];
	[encoder encodeObject:symboleMonetaire forKey:@"symboleMonetaire"];
    [encoder encodeBool:verifieEcrituresAutomatiquesEnSuspens forKey:@"verifieEcrituresAutomatiquesEnSuspens"];
	[encoder encodeObject:categoriesMouvement forKey:@"categoriesMouvement"];
	[encoder encodeObject:comptes forKey:@"comptes"];
	[encoder encodeObject:soldeTotalComptes forKey:@"soldeTotalComptes"];
}

- (id)initWithXMLUnarchiver:(CBXMLUnarchiver *)xmlUnarchiver
{
	id decodedObject;
	
    if (self = [self init]) {
	
		decodedObject = [xmlUnarchiver decodeStringForKey:@"nom"];
		if (decodedObject != nil)
			[self setNom:decodedObject];
		
		decodedObject = [xmlUnarchiver decodeStringForKey:@"prenom"];
		if (decodedObject != nil)
			[self setPrenom:decodedObject];

		decodedObject = [xmlUnarchiver decodeStringForKey:@"symboleMonetaire"];
		if (decodedObject != nil)
			[self setSymboleMonetaire:decodedObject];
        
        if ([xmlUnarchiver containsValueForKey:@"verifieEcrituresAutomatiquesEnSuspens"]) {
            [self setVerifieEcrituresAutomatiquesEnSuspens:[xmlUnarchiver decodeBoolForKey:@"verifieEcrituresAutomatiquesEnSuspens"]];
        }
        else {
            [self setVerifieEcrituresAutomatiquesEnSuspens:YES];
        }


		NSArray *array;
		NSEnumerator *enumerator;
		id anObject;
		
		// On récupère les catégories de mouvements
		array = [xmlUnarchiver derivedArrayOfUnarchiversForKey:@"categoriesMouvement" keyItem:@"categoriesMouvementItem"];
		if (array != nil) {
			enumerator = [array objectEnumerator];
			while (anObject = [enumerator nextObject]) {
				CBCategorieMouvement *myCategorie = [[CBCategorieMouvement alloc] initWithXMLUnarchiver:(CBXMLUnarchiver *)anObject];
				[[self categoriesMouvement] addObject:myCategorie];
				[(CBXMLUnarchiver *)anObject archiveIDForObject:myCategorie];
				[myCategorie release];
			}
		}

		// On récupère les comptes
		array = [xmlUnarchiver derivedArrayOfUnarchiversForKey:@"comptes" keyItem:@"comptesItem"];
		if (array != nil) {
			enumerator = [array objectEnumerator];
			while (anObject = [enumerator nextObject]) {
				CBCompte *myCompte = [[CBCompte alloc] initWithXMLUnarchiver:(CBXMLUnarchiver *)anObject];
				[myCompte calculeSoldes];
				[[self comptes] addObject:myCompte];
				[myCompte release];
			}
		}

    }
    return self;
}

- (void)encodeWithXMLArchiver:(CBXMLArchiver *)xmlArchiver
{
	[xmlArchiver encodeString:nom forKey:@"nom"];
	[xmlArchiver encodeString:prenom forKey:@"prenom"];
	[xmlArchiver encodeString:symboleMonetaire forKey:@"symboleMonetaire"];
    [xmlArchiver encodeBool:verifieEcrituresAutomatiquesEnSuspens forKey:@"verifieEcrituresAutomatiquesEnSuspens"];
	[xmlArchiver encodeArrayOfXMLCodingObjects:categoriesMouvement forKey:@"categoriesMouvement" keyItem:@"categoriesMouvementItem" withID:YES];
	[xmlArchiver encodeArrayOfXMLCodingObjects:comptes forKey:@"comptes" keyItem:@"comptesItem" withID:NO];
	[xmlArchiver encodeDecimalNumber:soldeTotalComptes forKey:@"soldeTotalComptes"];
}

- (void)dealloc
{
	[nom release];
	[prenom release];
	[symboleMonetaire release];
	[categoriesMouvement release];
	[comptes release];
	[soldeTotalComptes release];
	[super dealloc];
}

- (NSString *)nom
{
	return [[nom copy] autorelease];
}

- (void)setNom:(NSString *)aNom
{
	[nom autorelease];
	nom = [aNom copy];
}

- (NSString *)prenom
{
	return [[prenom copy] autorelease];
}

- (void)setPrenom:(NSString *)aPrenom
{
	[prenom autorelease];
	prenom = [aPrenom copy];
}

- (NSString *)nomPrenom
{
	return [NSString stringWithFormat:@"%@ %@", prenom, nom];
}

- (NSString *)symboleMonetaire
{
	return [[symboleMonetaire copy] autorelease];
}

- (void)setSymboleMonetaire:(NSString *)aSymboleMonetaire
{
	[symboleMonetaire autorelease];
	symboleMonetaire = [aSymboleMonetaire copy];
}

- (BOOL)verifieEcrituresAutomatiquesEnSuspens
{
    return verifieEcrituresAutomatiquesEnSuspens;
}

- (void)setVerifieEcrituresAutomatiquesEnSuspens:(BOOL)aVerifieEcrituresAutomatiquesEnSuspens
{
    verifieEcrituresAutomatiquesEnSuspens = aVerifieEcrituresAutomatiquesEnSuspens;
}

- (NSMutableArray *)categoriesMouvement
{
	return categoriesMouvement;
}

- (NSMutableArray *)comptes
{
	return comptes;
}

- (NSDecimalNumber *)soldeTotalComptes
{
	return [[soldeTotalComptes copy] autorelease];
}

- (void)setSoldeTotalComptes:(NSDecimalNumber *)aSoldeTotalComptes
{
	[soldeTotalComptes autorelease];
	soldeTotalComptes = [aSoldeTotalComptes copy];
}

- (void)copieParametresDepuis:(CBPortefeuille *)aPortefeuille
{
	[self setNom:[aPortefeuille nom]];
	[self setPrenom:[aPortefeuille prenom]];
	[self setSymboleMonetaire:[aPortefeuille symboleMonetaire]];
    [self setVerifieEcrituresAutomatiquesEnSuspens:[aPortefeuille verifieEcrituresAutomatiquesEnSuspens]];
}

- (void)calculeSoldes
{
    NSDecimal soldeTotalComptesDecimal;
	NSDecimal soldeReelCompte;
	
	soldeTotalComptesDecimal = [[NSDecimalNumber zero] decimalValue];
	
	NSEnumerator *enumerator = [[self comptes] objectEnumerator];
	CBCompte *anObject;
	while (anObject = (CBCompte *)[enumerator nextObject]) {

		soldeReelCompte = [[anObject soldeReel] decimalValue];
		NSDecimalAdd(&soldeTotalComptesDecimal, &soldeTotalComptesDecimal, &soldeReelCompte, NSRoundPlain);
	}
	
	NSDecimalCompact(&soldeTotalComptesDecimal);
	[self setSoldeTotalComptes:[NSDecimalNumber decimalNumberWithDecimal:soldeTotalComptesDecimal]];
}

@end
