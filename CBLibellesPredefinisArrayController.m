//
//  CBLibellesPredefinisArrayController.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 24/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBLibellesPredefinisArrayController.h"
#import "CBLibellePredefini.h"


@implementation CBLibellesPredefinisArrayController

- (void)awakeFromNib
{
	[self setOperation:CBTypeMouvementIndefini];
}

- (CBTypeMouvement)operation
{
	return operation;
}

- (void)setOperation:(CBTypeMouvement)anOperation
{
	operation = anOperation;
}

- (IBAction)filtreLibellesPredefinis:(id)sender;
{
	[self setOperation:[[sender selectedItem]tag]];
	[self rearrangeObjects];

	if ([[self arrangedObjects] count] > 0)
		[self setSelectionIndex:0];

}

- (NSArray *)arrangeObjects:(NSArray *)objects
{
	NSMutableArray *filteredObjects = [NSMutableArray arrayWithCapacity:[objects count]];
	NSEnumerator *objectsEnumerator = [objects objectEnumerator];
	CBLibellePredefini *item;

	while (item = (CBLibellePredefini *)[objectsEnumerator nextObject]) {
	
		if (operation == [item operation])
			[filteredObjects addObject:item];
	}
	return [super arrangeObjects:filteredObjects];
}

@end
