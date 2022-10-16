//
//  Mouvement.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on Mon Dec 17 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import "Mouvement.h"


@implementation Mouvement

- (id)initWithDate:(NSCalendarDate *)date operation:(NSString *)operation libelle:(NSString *)libelle 
                            montant:(NSDecimalNumber *)montant numeroCheque:(NSDecimalNumber *)numeroCheque
{
    self = [super init];
    if (self) {
        _date = [date copyWithZone:[self zone]];
        _operation = [[NSString allocWithZone:[self zone]] initWithString:operation];
        _libelle = [[NSString allocWithZone:[self zone]] initWithString:libelle];
        _pointage = [[NSString allocWithZone:[self zone]] initWithString:@" "];
        _avoir = [[NSDecimalNumber allocWithZone:[self zone]] initWithString:@"0"];
        _numeroCheque = [numeroCheque copyWithZone:[self zone]];
        
        if([operation isEqualToString:@"Carte Bleue"] 
                     /*   || [operation isEqualToString:@"Prélèvement"] 
                                        || [operation isEqualToString:@"Chèque"]*/) {
                                                                
            _debit = [montant copyWithZone:[self zone]];
            _credit = [[NSDecimalNumber allocWithZone:[self zone]] initWithString:@"0"];
            
        }
        else {
        
            _credit = [montant copyWithZone:[self zone]];
            _debit = [[NSDecimalNumber allocWithZone:[self zone]] initWithString:@"0"];
            
        }
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _date = [[coder decodeObject] retain];
        _operation = [[coder decodeObject] retain];
        _libelle = [[coder decodeObject] retain];
        _debit = [[coder decodeObject] retain];
        _pointage = [[coder decodeObject] retain];
        _credit = [[coder decodeObject] retain];
        _avoir = [[coder decodeObject] retain];
        _numeroCheque = [[coder decodeObject] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_date];
    [coder encodeObject:_operation];
    [coder encodeObject:_libelle];
    [coder encodeObject:_debit];
    [coder encodeObject:_pointage];
    [coder encodeObject:_credit];
    [coder encodeObject:_avoir];
    [coder encodeObject:_numeroCheque];
}

- (void)dealloc
{
    [_date release];
    [_operation release];
    [_libelle release];
    [_debit release];
    [_pointage release];
    [_credit release];
    [_avoir release];
    [_numeroCheque release];
    
    [super dealloc];
}

- (NSCalendarDate *)date
{
     return _date;
}

- (NSString *)operation
{
     return _operation;
}

- (NSString *)libelle
{
     return _libelle;
}

- (NSDecimalNumber *)debit
{
     return _debit;
}

- (NSString *)pointage
{
     return _pointage;
}

- (NSDecimalNumber *)credit
{
     return _credit;
}

- (NSDecimalNumber *)avoir
{
     return _avoir;
}

- (NSDecimalNumber *)numeroCheque
{
    return _numeroCheque;
}

@end
