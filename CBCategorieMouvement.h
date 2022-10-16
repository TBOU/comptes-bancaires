//
//  CBCategorieMouvement.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 11/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBXMLCoding.h"
#import "CBXMLArchiver.h"
#import "CBXMLUnarchiver.h"

@class CBMouvement;


@interface CBCategorieMouvement : NSObject <NSCoding, CBXMLCoding> {
    NSString *titre;
	NSNumber *utilisationMouvements;
}

- (NSString *)titre;
- (void)setTitre:(NSString *)aTitre;

- (NSNumber *)utilisationMouvements;
- (void)setUtilisationMouvements:(NSNumber *)anUtilisationMouvements;

- (void)registerLien:(CBMouvement *)aMouvement;
- (void)unregisterLien:(CBMouvement *)aMouvement;

@end
