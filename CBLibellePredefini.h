//
//  CBLibellePredefini.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 11/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBGlobal.h"
#import "CBXMLCoding.h"
#import "CBXMLArchiver.h"
#import "CBXMLUnarchiver.h"


@interface CBLibellePredefini : NSObject <NSCoding, CBXMLCoding> {
	CBTypeMouvement operation;
	NSString *libelle;
	NSDecimalNumber *montant;
}

- (CBTypeMouvement)operation;
- (void)setOperation:(CBTypeMouvement)anOperation;

- (NSString *)libelle;
- (void)setLibelle:(NSString *)aLibelle;

- (NSDecimalNumber *)montant;
- (void)setMontant:(NSDecimalNumber *)aMontant;

@end
