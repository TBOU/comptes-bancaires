//
//  Compte.m
//  Comptes Bancaires
//
//  Created by thierry on Wed Nov 28 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import "Compte.h"
#import "Mouvement.h"
#import "Portefeuille.h"


@implementation Compte

- (id)initWithBanque:(NSString *)banque numeroCompte:(NSString *)numeroCompte 
            numeroProchainCheque:(NSDecimalNumber *)numeroProchainCheque soldeInitial:(NSDecimalNumber *)soldeInitial
{
    self = [super init];
    if (self) {
        _banque = [[NSString allocWithZone:[self zone]] initWithString:banque];
        _numeroCompte = [[NSString allocWithZone:[self zone]] initWithString:numeroCompte];
        _numeroProchainCheque = [numeroProchainCheque copyWithZone:[self zone]];
        _soldeInitial = [soldeInitial copyWithZone:[self zone]];
        _soldeCompte = [soldeInitial copyWithZone:[self zone]];
        _soldeCalcule = [soldeInitial copyWithZone:[self zone]];
        _soldeCBEnCours = [[NSDecimalNumber allocWithZone:[self zone]] initWithString:@"0"];
        _listeCarteBleue = [[ListeLibelles allocWithZone:[self zone]] init];
        _listeCheque = [[ListeLibelles allocWithZone:[self zone]] init];
        _listeDepot = [[ListeLibelles allocWithZone:[self zone]] init];
        _listePrelevement = [[ListeLibelles allocWithZone:[self zone]] init];
        _listeVirement = [[ListeLibelles allocWithZone:[self zone]] init];
        _mouvements = [[NSMutableArray allocWithZone:[self zone]] initWithCapacity:7];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _banque = [[coder decodeObject] retain];
        _numeroCompte = [[coder decodeObject] retain];
        _numeroProchainCheque = [[coder decodeObject] retain];
        _soldeInitial = [[coder decodeObject] retain];
        _soldeCompte = [[coder decodeObject] retain];
        _soldeCalcule = [[coder decodeObject] retain];
        _soldeCBEnCours = [[coder decodeObject] retain];
        _listeCarteBleue = [[coder decodeObject] retain];
        _listeCheque = [[coder decodeObject] retain];
        _listeDepot = [[coder decodeObject] retain];
        _listePrelevement = [[coder decodeObject] retain];
        _listeVirement = [[coder decodeObject] retain];
        _mouvements = [[coder decodeObject] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_banque];
    [coder encodeObject:_numeroCompte];
    [coder encodeObject:_numeroProchainCheque];
    [coder encodeObject:_soldeInitial];
    [coder encodeObject:_soldeCompte];
    [coder encodeObject:_soldeCalcule];
    [coder encodeObject:_soldeCBEnCours];
    [coder encodeObject:_listeCarteBleue];
    [coder encodeObject:_listeCheque];
    [coder encodeObject:_listeDepot];
    [coder encodeObject:_listePrelevement];
    [coder encodeObject:_listeVirement];
    [coder encodeObject:_mouvements];
}

- (void)dealloc
{
    [_banque release];
    [_numeroCompte release];
    [_numeroProchainCheque release];
    [_soldeInitial release];
    [_soldeCompte release];
    [_soldeCalcule release];
    [_soldeCBEnCours release];
    [_listeCarteBleue release];
    [_listeCheque release];
    [_listeDepot release];
    [_listePrelevement release];
    [_listeVirement release];
    [_mouvements release];
    
    [super dealloc];
}

- (NSString *)banque
{
    return _banque;
}

- (NSString *)numeroCompte
{
    return _numeroCompte;
}

- (NSDecimalNumber *)numeroProchainCheque
{
    return _numeroProchainCheque;
}

- (NSDecimalNumber *)soldeInitial
{
    return _soldeInitial;
}

- (NSDecimalNumber *)soldeCompte
{
    return _soldeCompte;
}

- (NSDecimalNumber *)soldeCalcule
{
    return _soldeCalcule;
}

- (NSDecimalNumber *)soldeCBEnCours
{
    return _soldeCBEnCours;
}

- (ListeLibelles *)sourceLibellesCarteBleue
{
    return _listeCarteBleue;
}

- (ListeLibelles *)sourceLibellesCheque
{
    return _listeCheque;
}

- (ListeLibelles *)sourceLibellesDepot
{
    return _listeDepot;
}

- (ListeLibelles *)sourceLibellesPrelevement
{
    return _listePrelevement;
}

- (ListeLibelles *)sourceLibellesVirement
{
    return _listeVirement;
}

- (NSMutableArray *)mouvements
{
	return _mouvements;
}

@end
