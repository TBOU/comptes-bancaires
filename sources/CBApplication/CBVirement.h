//
//  CBVirement.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 03/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBCompte.h"
#import "CBMouvement.h"


@interface CBVirement : NSObject {
	CBCompte *compteDebiteur;
	CBCompte *compteCrediteur;
	CBMouvement *mouvement;
}

- (CBCompte *)compteDebiteur;
- (void)setCompteDebiteur:(CBCompte *)aCompteDebiteur;

- (CBCompte *)compteCrediteur;
- (void)setCompteCrediteur:(CBCompte *)aCompteCrediteur;

- (CBMouvement *)mouvement;

- (void)genereVirement;

@end
