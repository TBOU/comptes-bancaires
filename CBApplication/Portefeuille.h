//
//  Portefeuille.h
//  Comptes Bancaires
//
//  Created by thierry on Wed Nov 28 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "Compte.h"


@interface Portefeuille : NSObject <NSCoding>
{
@private
    NSString *_nom;
    NSString *_prenom;
    NSDecimalNumber *_soldeTotalComptes;
    NSMutableArray *_comptes;
}

- (NSString *)nom;
- (NSString *)prenom;
- (NSDecimalNumber *)soldeTotalComptes;
- (NSMutableArray *)comptes;

@end
