//
//  CBCompte.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Compte.h"
#import "CBXMLCoding.h"
#import "CBXMLArchiver.h"
#import "CBXMLUnarchiver.h"


@interface CBCompte : NSObject <NSCoding, CBXMLCoding> {
    NSString *banque;
    NSString *numeroCompte;
    NSDecimalNumber *soldeInitial;
    NSNumber *numeroProchainCheque;
    NSNumber *numeroProchainChequeEmploiService;
	NSMutableArray *libellesPredefinis;
    NSMutableArray *mouvementsPeriodiques;
    NSMutableArray *mouvements;
    NSDecimalNumber *soldeReel;
    NSDecimalNumber *soldeBanque;
    NSDecimalNumber *soldeCBEnCours;
}

- (id)initAvecAncienCompte:(Compte *)ancienCompte;

- (NSString *)banque;
- (void)setBanque:(NSString *)aBanque;

- (NSString *)numeroCompte;
- (void)setNumeroCompte:(NSString *)aNumeroCompte;

- (NSString *)numeroCompteBanque;

- (NSDecimalNumber *)soldeInitial;
- (void)setSoldeInitial:(NSDecimalNumber *)aSoldeInitial;

- (NSNumber *)numeroProchainCheque;
- (void)setNumeroProchainCheque:(NSNumber *)aNumeroProchainCheque;
- (void)augmenteNumeroProchainCheque;

- (NSNumber *)numeroProchainChequeEmploiService;
- (void)setNumeroProchainChequeEmploiService:(NSNumber *)aNumeroProchainChequeEmploiService;
- (void)augmenteNumeroProchainChequeEmploiService;

- (NSMutableArray *)libellesPredefinis;

- (NSMutableArray *)mouvementsPeriodiques;

- (NSMutableArray *)mouvements;

- (NSDecimalNumber *)soldeReel;
- (void)setSoldeReel:(NSDecimalNumber *)aSoldeReel;

- (NSDecimalNumber *)soldeBanque;
- (void)setSoldeBanque:(NSDecimalNumber *)aSoldeBanque;

- (NSDecimalNumber *)soldeCBEnCours;
- (void)setSoldeCBEnCours:(NSDecimalNumber *)aSoldeCBEnCours;

- (void)copieParametresDepuis:(CBCompte *)aCompte;

- (void)calculeSoldes;

- (void)clotureExercicePourDate:(NSCalendarDate *)dateCloture;

@end
