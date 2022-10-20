//
//  CBChoixCompteArrayController.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 04/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBCompte.h"


@interface CBChoixCompteArrayController : NSArrayController {
	CBCompte *compteExclu;
}

- (CBCompte *)compteExclu;
- (void)setCompteExclu:(CBCompte *)aCompteExclu;

@end
