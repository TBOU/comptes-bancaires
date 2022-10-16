//
//  Mouvement.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on Mon Dec 17 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Mouvement : NSObject <NSCoding>
{
@private
    NSDate *_date;
    NSString *_operation;
    NSString *_libelle;
    NSDecimalNumber *_debit;
    NSString *_pointage;
    NSDecimalNumber *_credit;
    NSDecimalNumber *_avoir;
    NSDecimalNumber *_numeroCheque;

}

- (id)initWithDate:(NSDate *)date operation:(NSString *)operation libelle:(NSString *)libelle 
                                montant:(NSDecimalNumber *)montant numeroCheque:(NSDecimalNumber *)numeroCheque;
- (NSDate *)date;
- (NSString *)operation;
- (NSString *)libelle;
- (NSDecimalNumber *)debit;
- (NSString *)pointage;
- (NSDecimalNumber *)credit;
- (NSDecimalNumber *)avoir;
- (NSDecimalNumber *)numeroCheque;

@end
