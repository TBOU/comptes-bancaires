//
//  CBCategorieMouvement.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 11/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBCategorieMouvement.h"


@implementation CBCategorieMouvement

- (id)init
{
    if (self = [super init]) {
		[self setTitre:NSLocalizedString(@"CBDefautTitreCategorie", nil)];
		[self setUtilisationMouvements:[NSNumber numberWithInt:0]];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
		[self setTitre:[decoder decodeObjectForKey:@"titre"]];
		[self setUtilisationMouvements:[NSNumber numberWithInt:0]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:titre forKey:@"titre"];
}

- (id)initWithXMLUnarchiver:(CBXMLUnarchiver *)xmlUnarchiver
{
	id decodedObject;
	
    if (self = [self init]) {

		decodedObject = [xmlUnarchiver decodeStringForKey:@"titre"];
		if (decodedObject != nil)
			[self setTitre:decodedObject];
    }
    return self;
}

- (void)encodeWithXMLArchiver:(CBXMLArchiver *)xmlArchiver
{
	[xmlArchiver encodeString:titre forKey:@"titre"];
}

- (void)dealloc
{
	[titre release];
	[utilisationMouvements release];
	[super dealloc];
}

- (NSString *)titre
{
	return [[titre copy] autorelease];
}

- (void)setTitre:(NSString *)aTitre
{
	[titre autorelease];
	titre = [aTitre copy];
}

- (NSNumber *)utilisationMouvements
{
	return [[utilisationMouvements copy] autorelease];
}

- (void)setUtilisationMouvements:(NSNumber *)anUtilisationMouvements
{
	[utilisationMouvements autorelease];
	utilisationMouvements = [anUtilisationMouvements copy];
}

- (void)registerLien:(CBMouvement *)aMouvement
{
	[[NSNotificationCenter defaultCenter] addObserver:aMouvement 
											selector:@selector(categorieMouvementWillDealloc:) 
											name:@"CBCategorieMouvementWillDeallocNotification" 
											object:self];

	[self setUtilisationMouvements:[NSNumber numberWithInt:[[self utilisationMouvements] intValue] + 1]];
}

- (void)unregisterLien:(CBMouvement *)aMouvement
{
	[[NSNotificationCenter defaultCenter] removeObserver:aMouvement 
											name:@"CBCategorieMouvementWillDeallocNotification" 
											object:self];

	[self setUtilisationMouvements:[NSNumber numberWithInt:[[self utilisationMouvements] intValue] - 1]];
}

@end
