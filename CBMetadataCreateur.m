//
//  CBMetadataCreateur.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 17/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBMetadataCreateur.h"


@implementation CBMetadataCreateur

- (id)init
{
    if (self = [super init]) {
		metadataSet = [[NSMutableSet alloc] initWithCapacity:700];
	}
    return self;
}

- (void)dealloc
{
	[metadataSet release];
	[super dealloc];
}

- (void)ajouteString:(NSString *)aString
{
	if (aString != nil && [aString length] > 1) {
		
		NSArray *subStrings = [aString componentsSeparatedByString:@" "];

		NSEnumerator *enumerator = [subStrings objectEnumerator];
		id value;
		while (value = [enumerator nextObject]) {
			
			if ([value length] > 1) {
				
				NSString *elementString = [value stringByTrimmingCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
				
				if (elementString != nil && [elementString length] > 1) {
					[metadataSet addObject:elementString];
				}
			}
		}
	}
}

- (NSString *)metadataString
{
	NSMutableString *returnString = [NSMutableString stringWithCapacity:7000];
	
	NSEnumerator *enumerator = [metadataSet objectEnumerator];
	id value;
	while (value = [enumerator nextObject]) {
		
		[returnString appendFormat:@"%@ ", value];
	}
	
	return returnString;
}

@end
