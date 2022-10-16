//
//  CBEcritureAutomatique.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 01/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBEcritureAutomatique.h"


@implementation CBEcritureAutomatique

- (id)initWithCompte:(CBCompte *)aCompte mouvementPeriodique:(CBMouvementPeriodique *)aMouvementPeriodique dateEcriture:(NSDate *)aDateEcriture
{
	if (self = [super init]) {
		compte = [aCompte retain];
		mouvementPeriodique = [aMouvementPeriodique retain];
		dateEcriture = [aDateEcriture retain];
		mouvement = [[CBMouvement alloc] init];
		[mouvement copieParametresDepuis:mouvementPeriodique];
		[mouvement setDate:dateEcriture];
	}
	return self;
}

- (void)dealloc
{
	[compte release];
	[mouvementPeriodique release];
	[dateEcriture release];
	[mouvement release];
	[super dealloc];
}

- (CBCompte *)compte
{
	return compte;
}

- (CBMouvement *)mouvement
{
	return mouvement;
}

- (void)genereEcriture
{
	[[compte mouvements] addObject:mouvement];
	[compte calculeSoldes];
	[[mouvementPeriodique datesEcrituresEnSuspens] removeObjectIdenticalTo:dateEcriture];
}

@end
