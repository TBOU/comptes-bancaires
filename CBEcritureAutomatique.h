//
//  CBEcritureAutomatique.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 01/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBCompte.h"
#import "CBMouvement.h"
#import "CBMouvementPeriodique.h"


@interface CBEcritureAutomatique : NSObject {
	CBCompte *compte;
	CBMouvementPeriodique *mouvementPeriodique;
	NSCalendarDate *dateEcriture;
	CBMouvement *mouvement;
}

- (id)initWithCompte:(CBCompte *)aCompte mouvementPeriodique:(CBMouvementPeriodique *)aMouvementPeriodique dateEcriture:(NSCalendarDate *)aDateEcriture;

- (CBCompte *)compte;

- (CBMouvement *)mouvement;

- (void)genereEcriture;

@end
