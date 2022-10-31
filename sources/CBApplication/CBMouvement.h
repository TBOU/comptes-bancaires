//
//  CBMouvement.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBGlobal.h"
#import "CBCategorieMouvement.h"
#import "CBXMLCoding.h"
#import "CBXMLArchiver.h"
#import "CBXMLUnarchiver.h"

@class CBMouvementMultiple;


@interface CBMouvement : NSObject <NSCoding, CBXMLCoding> {
	NSDate *date;
	CBTypeMouvement operation;
	NSString *libelle;
	CBCategorieMouvement *categorie;
	NSDecimalNumber *montant;
	BOOL pointage;
	NSDecimalNumber *avoir;
	NSNumber *numeroCheque;
	NSNumber *numeroChequeEmploiService;
}

- (NSDate *)date;
- (void)setDate:(NSDate *)aDate;

- (CBTypeMouvement)operation;
- (void)setOperation:(CBTypeMouvement)anOperation;
- (NSString *)libelleOperation;

- (NSString *)libelle;
- (void)setLibelle:(NSString *)aLibelle;

- (CBCategorieMouvement *)categorie;
- (void)setCategorie:(CBCategorieMouvement *)aCategorie;

- (NSDecimalNumber *)montant;
- (void)setMontant:(NSDecimalNumber *)aMontant;
- (NSDecimalNumber *)debit;
- (NSDecimalNumber *)credit;

- (BOOL)pointage;
- (void)setPointage:(BOOL)aPointage;
- (void)togglePointage;

- (NSDecimalNumber *)avoir;
- (void)setAvoir:(NSDecimalNumber *)anAvoir;

- (NSNumber *)numeroCheque;
- (void)setNumeroCheque:(NSNumber *)aNumeroCheque;
- (BOOL)isCheque;

- (NSNumber *)numeroChequeEmploiService;
- (void)setNumeroChequeEmploiService:(NSNumber *)aNumeroChequeEmploiService;
- (BOOL)isChequeEmploiService;

- (void)setNilValueForKey:(NSString *)theKey;

- (void)copieParametresDepuis:(CBMouvement *)aMouvement;
- (void)copieParametresDepuisMultiple:(CBMouvementMultiple *)aMouvementMultiple;

- (void)categorieMouvementWillDealloc:(NSNotification *)aNotification;


@end
