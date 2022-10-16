//
//  CBStatistiqueCategorie.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 04/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBStatistiqueCategorie.h"
#import "CBCategorieMouvement.h"


@interface CBStatistiqueCategorie : NSObject {
	CBCategorieMouvement *categorie;
	NSDecimalNumber *soldePeriode;
	NSDecimalNumber *nombreMoisPeriode;
	NSDecimalNumber *soldeMensuel;
}

- (id)initWithCategorie:(CBCategorieMouvement *)aCategorie nombreMoisPeriode:(NSDecimalNumber *)aNombreMoisPeriode;

- (void)ajouteMontant:(NSDecimalNumber *)aMontant;

- (CBCategorieMouvement *)categorie;

- (NSDecimalNumber *)soldePeriode;
- (void)setSoldePeriode:(NSDecimalNumber *)aSoldePeriode;

- (NSDecimalNumber *)soldeMensuel;
- (void)setSoldeMensuel:(NSDecimalNumber *)aSoldeMensuel;

@end
