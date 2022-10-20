//
//  CBChoixCompteArrayController.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 04/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBChoixCompteArrayController.h"


@implementation CBChoixCompteArrayController

- (void)awakeFromNib
{
	[self setCompteExclu:nil];
}

- (void)dealloc
{
	[compteExclu release];
	[super dealloc];
}

- (CBCompte *)compteExclu
{
	return compteExclu;
}

- (void)setCompteExclu:(CBCompte *)aCompteExclu
{
	[compteExclu autorelease];
	compteExclu = [aCompteExclu retain];
}

- (NSArray *)arrangeObjects:(NSArray *)objects
{
	NSMutableArray *filteredObjects = [NSMutableArray arrayWithCapacity:[objects count]];
	NSEnumerator *objectsEnumerator = [objects objectEnumerator];
	CBCompte *item;

	while (item = (CBCompte *)[objectsEnumerator nextObject]) {
	
		if (item != compteExclu)
			[filteredObjects addObject:item];
	}
	return [super arrangeObjects:filteredObjects];
}

@end
