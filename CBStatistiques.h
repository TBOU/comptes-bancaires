//
//  CBStatistiques.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 04/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBCategorieMouvement.h"


@interface CBStatistiques : NSObject {
	NSDecimalNumber *soldeDebiteurPeriode;
	NSDecimalNumber *soldeDebiteurMensuel;
	NSDecimalNumber *soldeCrediteurPeriode;
	NSDecimalNumber *soldeCrediteurMensuel;
	NSMutableArray *statistiquesCategories;
}

- (void)ajouteMontant:(NSDecimalNumber *)aMontant pourCategorie:(CBCategorieMouvement *)aCategorie 
													nombreMoisPeriode:(NSDecimalNumber *)aNombreMoisPeriode;

- (NSDecimalNumber *)soldeDebiteurPeriode;
- (void)setSoldeDebiteurPeriode:(NSDecimalNumber *)aSoldeDebiteurPeriode;

- (NSDecimalNumber *)soldeDebiteurMensuel;
- (void)setSoldeDebiteurMensuel:(NSDecimalNumber *)aSoldeDebiteurMensuel;

- (NSDecimalNumber *)soldeCrediteurPeriode;
- (void)setSoldeCrediteurPeriode:(NSDecimalNumber *)aSoldeCrediteurPeriode;

- (NSDecimalNumber *)soldeCrediteurMensuel;
- (void)setSoldeCrediteurMensuel:(NSDecimalNumber *)aSoldeCrediteurMensuel;

- (NSMutableArray *)statistiquesCategories;

@end
