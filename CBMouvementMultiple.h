//
//  CBMouvementMultiple.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 27/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMouvement.h"


@interface CBMouvementMultiple : CBMouvement {
	BOOL dateUpdate;
	BOOL operationUpdate;
	BOOL libelleUpdate;
	BOOL categorieUpdate;
	BOOL montantUpdate;
	BOOL pointageUpdate;
}

- (BOOL)dateUpdate;
- (void)setDateUpdate:(BOOL)aDateUpdate;

- (BOOL)isOperationIndefinie;
- (BOOL)operationUpdate;
- (void)setOperationUpdate:(BOOL)anOperationUpdate;

- (BOOL)libelleUpdate;
- (void)setLibelleUpdate:(BOOL)aLibelleUpdate;

- (BOOL)categorieUpdate;
- (void)setCategorieUpdate:(BOOL)aCategorieUpdate;

- (BOOL)montantUpdate;
- (void)setMontantUpdate:(BOOL)aMontantUpdate;

- (BOOL)pointageUpdate;
- (void)setPointageUpdate:(BOOL)aPointageUpdate;

- (void)copieParametresDepuisArray:(NSArray *)aMouvementsArray;

@end
