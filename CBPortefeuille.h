//
//  CBPortefeuille.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Portefeuille.h"
#import "CBXMLCoding.h"
#import "CBXMLArchiver.h"
#import "CBXMLUnarchiver.h"


@interface CBPortefeuille : NSObject <NSCoding, CBXMLCoding> {
    NSString *nom;
    NSString *prenom;
    NSString *symboleMonetaire;
    NSMutableArray *categoriesMouvement;
    NSMutableArray *comptes;
    NSDecimalNumber *soldeTotalComptes;
}

- (id)initAvecAncienPortefeuille:(Portefeuille *)ancienPortefeuille;

- (NSString *)nom;
- (void)setNom:(NSString *)aNom;
- (NSString *)prenom;
- (void)setPrenom:(NSString *)aPrenom;
- (NSString *)nomPrenom;

- (NSString *)symboleMonetaire;
- (void)setSymboleMonetaire:(NSString *)aSymboleMonetaire;

- (NSMutableArray *)categoriesMouvement;

- (NSMutableArray *)comptes;

- (NSDecimalNumber *)soldeTotalComptes;
- (void)setSoldeTotalComptes:(NSDecimalNumber *)aSoldeTotalComptes;

- (void)copieParametresDepuis:(CBPortefeuille *)aPortefeuille;

- (void)calculeSoldes;

@end
