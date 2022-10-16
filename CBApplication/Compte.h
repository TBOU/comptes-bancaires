//
//  Compte.h
//  Comptes Bancaires
//
//  Created by thierry on Wed Nov 28 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListeLibelles.h"


@interface Compte : NSObject <NSCoding>
{
@private
    NSString *_banque;
    NSString *_numeroCompte;
    NSDecimalNumber *_numeroProchainCheque;
    NSDecimalNumber *_soldeInitial;
    NSDecimalNumber *_soldeCompte;
    NSDecimalNumber *_soldeCalcule;
    NSDecimalNumber *_soldeCBEnCours;
    ListeLibelles *_listeCarteBleue;
    ListeLibelles *_listeCheque;
    ListeLibelles *_listeDepot;
    ListeLibelles *_listePrelevement;
    ListeLibelles *_listeVirement;
    NSMutableArray *_mouvements;
}

- (id)initWithBanque:(NSString *)banque numeroCompte:(NSString *)numeroCompte 
            numeroProchainCheque:(NSDecimalNumber *)numeroProchainCheque soldeInitial:(NSDecimalNumber *)soldeInitial;
- (NSString *)banque;
- (NSString *)numeroCompte;
- (NSDecimalNumber *)numeroProchainCheque;
- (NSDecimalNumber *)soldeInitial;
- (NSDecimalNumber *)soldeCompte;
- (NSDecimalNumber *)soldeCalcule;
- (NSDecimalNumber *)soldeCBEnCours;
- (ListeLibelles *)sourceLibellesCarteBleue;
- (ListeLibelles *)sourceLibellesCheque;
- (ListeLibelles *)sourceLibellesDepot;
- (ListeLibelles *)sourceLibellesPrelevement;
- (ListeLibelles *)sourceLibellesVirement;
- (NSMutableArray *)mouvements;

@end
