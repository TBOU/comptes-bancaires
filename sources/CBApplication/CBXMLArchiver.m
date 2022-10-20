//
//  CBXMLArchiver.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 15/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBXMLArchiver.h"
#import "CBGlobal.h"


@implementation CBXMLArchiver

- (id)initWithElement:(NSXMLElement *)anElement objectsArray:(NSMutableArray *)anObjectsArray
{
    if (self = [super init]) {
		currentElement = [anElement retain];
		objectsArray = [anObjectsArray retain];
    }
    return self;
}

- (id)initWithElement:(NSXMLElement *)anElement
{
	self = [self initWithElement:anElement objectsArray:[NSMutableArray arrayWithCapacity:7]];
    return self;
}

- (void)dealloc
{
	[currentElement release];
	[objectsArray release];
	[super dealloc];
}

- (CBXMLArchiver *)derivedArchiverWithElement:(NSXMLElement *)anElement
{
	return [[[CBXMLArchiver alloc] initWithElement:anElement objectsArray:objectsArray] autorelease];
}

- (void)encodeXMLCodingObject:(id <CBXMLCoding>)objv forKey:(NSString *)key withID:(BOOL)isID
{
	NSXMLElement *myElement;
	
	if (objv == nil)
		return;
	
	myElement = [[NSXMLElement alloc] initWithName:key];

	NSUInteger index = [objectsArray indexOfObjectIdenticalTo:objv];
	if (index != NSNotFound) {
		[myElement addAttribute:[NSXMLNode attributeWithName:@"IDREF" stringValue:[NSString stringWithFormat:@"%d", (int)index]]];
	}
	else if (isID) {
		[objectsArray addObject:objv];
		index = [objectsArray indexOfObjectIdenticalTo:objv];
		[myElement addAttribute:[NSXMLNode attributeWithName:@"ID" stringValue:[NSString stringWithFormat:@"%d", (int)index]]];
	}
	
	[currentElement addChild:myElement];
	CBXMLArchiver *myDerivedArchiver = [self derivedArchiverWithElement:myElement];
	[objv encodeWithXMLArchiver:myDerivedArchiver];
	[myElement release];
}

- (void)encodeArrayOfXMLCodingObjects:(NSArray *)objv forKey:(NSString *)key keyItem:(NSString *)keyItem withID:(BOOL)isID
{
	NSXMLElement *myElement;
	
	if (objv == nil)
		return;
	
	myElement = [[NSXMLElement alloc] initWithName:key];
	[currentElement addChild:myElement];
	CBXMLArchiver *myDerivedArchiver = [self derivedArchiverWithElement:myElement];

	NSEnumerator *enumerator = [objv objectEnumerator];
	id <CBXMLCoding> anItem;
	while (anItem = [enumerator nextObject]) {
		[myDerivedArchiver encodeXMLCodingObject:anItem forKey:keyItem withID:isID];
	}
	
	[myElement release];
}

- (void)encodeArrayOfCalendarDates:(NSArray *)objv forKey:(NSString *)key keyItem:(NSString *)keyItem
{
	NSXMLElement *myElement;
	
	if (objv == nil)
		return;
	
	myElement = [[NSXMLElement alloc] initWithName:key];
	[currentElement addChild:myElement];
	CBXMLArchiver *myDerivedArchiver = [self derivedArchiverWithElement:myElement];

	NSEnumerator *enumerator = [objv objectEnumerator];
	NSDate *anItem;
	while (anItem = [enumerator nextObject]) {
		[myDerivedArchiver encodeCalendarDate:anItem forKey:keyItem];
	}
	
	[myElement release];
}

- (void)encodeString:(NSString *)objv forKey:(NSString *)key
{
	NSString *myValue;
	NSXMLElement *myElement;
	
	if (objv == nil)
		return;
	
	myValue = [NSString stringWithString:objv];
	myElement = [[NSXMLElement alloc] initWithName:key stringValue:myValue];
	[currentElement addChild:myElement];
	[myElement release];
}

- (void)encodeDecimalNumber:(NSDecimalNumber *)objv forKey:(NSString *)key
{
	NSString *myValue;
	NSXMLElement *myElement;
	
	if (objv == nil)
		return;
	
	myValue = [NSString stringWithFormat:@"%f", [objv  doubleValue]];
	myElement = [[NSXMLElement alloc] initWithName:key stringValue:myValue];
	[currentElement addChild:myElement];
	[myElement release];
}

- (void)encodeNumber:(NSNumber *)objv forKey:(NSString *)key
{
	NSString *myValue;
	NSXMLElement *myElement;
	
	if (objv == nil)
		return;
	
	myValue = [NSString stringWithFormat:@"%qi", [objv  longLongValue]];
	myElement = [[NSXMLElement alloc] initWithName:key stringValue:myValue];
	[currentElement addChild:myElement];
	[myElement release];
}

- (void)encodeCalendarDate:(NSDate *)objv forKey:(NSString *)key
{
	NSString *myValue;
	NSXMLElement *myElement;
	
	if (objv == nil)
		return;
	
	myValue = CBStringFromDate(objv, @"yyyy-MM-dd");
	myElement = [[NSXMLElement alloc] initWithName:key stringValue:myValue];
	[currentElement addChild:myElement];
	[myElement release];
}

- (void)encodeInt:(int)intv forKey:(NSString *)key
{
	NSString *myValue;
	NSXMLElement *myElement;
	
	myValue = [NSString stringWithFormat:@"%d", intv];
	myElement = [[NSXMLElement alloc] initWithName:key stringValue:myValue];
	[currentElement addChild:myElement];
	[myElement release];
}

- (void)encodeBool:(BOOL)boolv forKey:(NSString *)key
{
	NSString *myValue;
	NSXMLElement *myElement;
	
	if (boolv)
		myValue = @"1";
	else
		myValue = @"0";
	myElement = [[NSXMLElement alloc] initWithName:key stringValue:myValue];
	[currentElement addChild:myElement];
	[myElement release];
}

@end
