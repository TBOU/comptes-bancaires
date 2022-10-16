//
//  Portefeuille.m
//  Comptes Bancaires
//
//  Created by thierry on Wed Nov 28 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import "Portefeuille.h"
#import "Compte.h"


@implementation Portefeuille

- (id)init
{
    self = [super init];
    if (self) {
        _nom = [[NSString allocWithZone:[self zone]] initWithString:@"Nom"];
        _prenom = [[NSString allocWithZone:[self zone]] initWithString:@"Prenom"];
        _soldeTotalComptes = [[NSDecimalNumber allocWithZone:[self zone]] initWithString:@"0"];
        _comptes = [[NSMutableArray allocWithZone:[self zone]] initWithCapacity:7];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _nom = [[coder decodeObject] retain];
        _prenom = [[coder decodeObject] retain];
        _soldeTotalComptes = [[coder decodeObject] retain];
        _comptes = [[coder decodeObject] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_nom];
    [coder encodeObject:_prenom];
    [coder encodeObject:_soldeTotalComptes];
    [coder encodeObject:_comptes];
}

- (void)dealloc
{
    [_nom release];
    [_prenom release];
    [_soldeTotalComptes release];
    [_comptes release];
    
    [super dealloc];
}

- (NSString *)nom
{
    return _nom;
}

- (NSString *)prenom
{
    return _prenom;
}

- (NSDecimalNumber *)soldeTotalComptes
{
    return _soldeTotalComptes;
}

- (NSMutableArray *)comptes
{
	return _comptes;
}

@end
