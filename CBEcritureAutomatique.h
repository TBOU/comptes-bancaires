//
//  CBEcritureAutomatique.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 01/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBCompte.h"
#import "CBMouvement.h"
#import "CBMouvementPeriodique.h"


@interface CBEcritureAutomatique : NSObject {
	CBCompte *compte;
	CBMouvementPeriodique *mouvementPeriodique;
	NSDate *dateEcriture;
	CBMouvement *mouvement;
}

- (id)initWithCompte:(CBCompte *)aCompte mouvementPeriodique:(CBMouvementPeriodique *)aMouvementPeriodique dateEcriture:(NSDate *)aDateEcriture;

- (CBCompte *)compte;

- (CBMouvement *)mouvement;

- (void)genereEcriture;

@end
