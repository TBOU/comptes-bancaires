//
//  CBPortefeuille.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBXMLCoding.h"
#import "CBXMLArchiver.h"
#import "CBXMLUnarchiver.h"


@interface CBPortefeuille : NSObject <NSCoding, CBXMLCoding> {
    NSString *nom;
    NSString *prenom;
    NSString *symboleMonetaire;
    BOOL verifieEcrituresAutomatiquesEnSuspens;
    NSMutableArray *categoriesMouvement;
    NSMutableArray *comptes;
    NSDecimalNumber *soldeTotalComptes;
}

- (NSString *)nom;
- (void)setNom:(NSString *)aNom;
- (NSString *)prenom;
- (void)setPrenom:(NSString *)aPrenom;
- (NSString *)nomPrenom;

- (NSString *)symboleMonetaire;
- (void)setSymboleMonetaire:(NSString *)aSymboleMonetaire;

- (BOOL)verifieEcrituresAutomatiquesEnSuspens;
- (void)setVerifieEcrituresAutomatiquesEnSuspens:(BOOL)aVerifieEcrituresAutomatiquesEnSuspens;

- (NSMutableArray *)categoriesMouvement;

- (NSMutableArray *)comptes;

- (NSDecimalNumber *)soldeTotalComptes;
- (void)setSoldeTotalComptes:(NSDecimalNumber *)aSoldeTotalComptes;

- (void)copieParametresDepuis:(CBPortefeuille *)aPortefeuille;

- (void)calculeSoldes;

@end
