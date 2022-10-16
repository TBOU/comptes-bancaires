//
//  ListeLibelles.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on Mon Dec 17 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import "ListeLibelles.h"


@implementation ListeLibelles

- (id)init
{
    self = [super init];
    if (self) {
        _libelles = [[NSMutableArray allocWithZone:[self zone]] initWithCapacity:7];
        _montants = [[NSMutableArray allocWithZone:[self zone]] initWithCapacity:7];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _libelles = [[coder decodeObject] retain];
        _montants = [[coder decodeObject] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_libelles];
    [coder encodeObject:_montants];
}

- (void)dealloc
{
    [_libelles release];
    [_montants release];
    
    [super dealloc];
}

- (NSMutableArray *)libelles
{
	return _libelles;
}

- (NSMutableArray *)montants
{
	return _montants;
}

@end
