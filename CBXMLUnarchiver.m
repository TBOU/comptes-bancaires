//
//  CBXMLUnarchiver.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 15/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBXMLUnarchiver.h"
#import "CBGlobal.h"


@implementation CBXMLUnarchiver

- (id)initWithElement:(NSXMLElement *)anElement objectsDictionary:(NSMutableDictionary *)anObjectsDictionary
{
    if (self = [super init]) {
		currentElement = [anElement retain];
		objectsDictionary = [anObjectsDictionary retain];
    }
    return self;
}

- (id)initWithElement:(NSXMLElement *)anElement
{
	self = [self initWithElement:anElement objectsDictionary:[NSMutableDictionary dictionaryWithCapacity:7]];
    return self;
}

- (void)dealloc
{
	[currentElement release];
	[objectsDictionary release];
	[super dealloc];
}

- (CBXMLUnarchiver *)derivedUnarchiverForKey:(NSString *)key
{
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return nil;
	}
	
	return [[[CBXMLUnarchiver alloc] initWithElement:[myChildElements objectAtIndex:0] objectsDictionary:objectsDictionary] autorelease];
}

- (NSArray *)derivedArrayOfUnarchiversForKey:(NSString *)key keyItem:(NSString *)keyItem
{
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return nil;
	}
	
	NSMutableArray *myDerivedArray = [NSMutableArray arrayWithCapacity:7];
	NSArray *myChildItemElements = [[myChildElements objectAtIndex:0] elementsForName:keyItem];
	
	if (myChildItemElements != nil) {
		
		NSEnumerator *enumerator = [myChildItemElements objectEnumerator];
		id anObject;
		while (anObject = [enumerator nextObject]) {
			[myDerivedArray addObject:[[[CBXMLUnarchiver alloc] initWithElement:anObject objectsDictionary:objectsDictionary] autorelease]];
		}
	}
	
	return myDerivedArray;
}

- (void)archiveIDForObject:(id)anObject
{
	NSXMLNode *attributeNode = [currentElement attributeForName:@"ID"];
	NSString *stringID;
	
	if (attributeNode != nil) {
		stringID = [attributeNode stringValue];
	}
	else {
		stringID = nil;
	}
	
	if (stringID != nil)
		[objectsDictionary setObject:anObject forKey:stringID];
}

- (id)decodeObjectReferenceForKey:(NSString *)key
{
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return nil;
	}
	
	NSXMLNode *attributeNode = [[myChildElements objectAtIndex:0] attributeForName:@"IDREF"];
	
	if (attributeNode != nil) {
		return [objectsDictionary objectForKey:[attributeNode stringValue]];
	}
	else {
		return nil;
	}
	
}

- (NSArray *)arrayOfCalendarDatesForKey:(NSString *)key keyItem:(NSString *)keyItem
{
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return nil;
	}
	
	NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:7];
	NSArray *myChildItemElements = [[myChildElements objectAtIndex:0] elementsForName:keyItem];
	
	if (myChildItemElements != nil) {
		
		NSEnumerator *enumerator = [myChildItemElements objectEnumerator];
		id anObject;
		while (anObject = [enumerator nextObject]) {
			
			NSDate *myDate = CBDateFromString([anObject stringValue], @"yyyy-MM-dd");
			
			if (myDate != nil)
				[myArray addObject:myDate];
		}
	}
	
	return myArray;
}

- (NSString *)decodeStringForKey:(NSString *)key
{
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return nil;
	}
	
	NSString *myStringValue = [[myChildElements objectAtIndex:0] stringValue];

	if (myStringValue == nil || [myStringValue isEqualToString:@""]) {
		return nil;
	}

	return myStringValue;
}


- (NSDecimalNumber *)decodeDecimalNumberForKey:(NSString *)key
{
	double doubleValue;
	
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return nil;
	}
	
	NSScanner *myScanner = [NSScanner scannerWithString:[[myChildElements objectAtIndex:0] stringValue]];
	if ([myScanner scanDouble:&doubleValue]) {
		NSDecimal decimalValue = [[NSNumber numberWithDouble:doubleValue] decimalValue];
		NSDecimalRound(&decimalValue, &decimalValue, 2, NSRoundPlain);
		NSDecimalCompact(&decimalValue);
		return [NSDecimalNumber decimalNumberWithDecimal:decimalValue];
	}
	else {
		return nil;
	}
}

- (NSNumber *)decodeNumberForKey:(NSString *)key
{
	long long numberValue;
	
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return nil;
	}
	
	NSScanner *myScanner = [NSScanner scannerWithString:[[myChildElements objectAtIndex:0] stringValue]];
	if ([myScanner scanLongLong:&numberValue]) {
		return [NSNumber numberWithLongLong:numberValue];
	}
	else {
		return nil;
	}
}

- (NSDate *)decodeCalendarDateForKey:(NSString *)key
{
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return nil;
	}
	
	NSString *myStringValue = [[myChildElements objectAtIndex:0] stringValue];
	
	return CBDateFromString(myStringValue, @"yyyy-MM-dd");
}

- (int)decodeIntForKey:(NSString *)key
{
	int intValue;
	
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return 0;
	}
	
	NSScanner *myScanner = [NSScanner scannerWithString:[[myChildElements objectAtIndex:0] stringValue]];
	if ([myScanner scanInt:&intValue]) {
		return intValue;
	}
	else {
		return 0;
	}
}

- (BOOL)decodeBoolForKey:(NSString *)key
{
	NSArray *myChildElements = [currentElement elementsForName:key];

	if (myChildElements == nil || [myChildElements count] == 0) {
		return NO;
	}
	
	NSString *myStringValue = [[myChildElements objectAtIndex:0] stringValue];

	if (myStringValue != nil && [myStringValue isEqualToString:@"1"]) {
		return YES;
	}
	else {
		return NO;
	}
}

@end
