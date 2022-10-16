//
//  CBVirement.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 03/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBVirement.h"


@implementation CBVirement

- (id)init
{
	if (self = [super init]) {
		[self setCompteDebiteur:nil];
		[self setCompteCrediteur:nil];
		mouvement = [[CBMouvement alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[compteDebiteur release];
	[compteCrediteur release];
	[mouvement release];
	[super dealloc];
}


- (CBCompte *)compteDebiteur
{
	return compteDebiteur;
}

- (void)setCompteDebiteur:(CBCompte *)aCompteDebiteur
{
	[compteDebiteur autorelease];
	compteDebiteur = [aCompteDebiteur retain];
}

- (CBCompte *)compteCrediteur
{
	return compteCrediteur;
}

- (void)setCompteCrediteur:(CBCompte *)aCompteCrediteur
{
	[compteCrediteur autorelease];
	compteCrediteur = [aCompteCrediteur retain];
}

- (CBMouvement *)mouvement
{
	return mouvement;
}

- (void)genereVirement
{
	CBMouvement *myMouvement;
	
	// Ecriture du mouvement de débit
	myMouvement = [[CBMouvement alloc] init];
	[myMouvement copieParametresDepuis:mouvement];
	[myMouvement setOperation:CBTypeMouvementVirementDebiteur];
	[[compteDebiteur mouvements] addObject:myMouvement];
	[compteDebiteur calculeSoldes];
	[myMouvement release];

	// Ecriture du mouvement de crédit
	myMouvement = [[CBMouvement alloc] init];
	[myMouvement copieParametresDepuis:mouvement];
	[myMouvement setOperation:CBTypeMouvementVirementCrediteur];
	[[compteCrediteur mouvements] addObject:myMouvement];
	[compteCrediteur calculeSoldes];
	[myMouvement release];

}

@end
