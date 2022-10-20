//
//  CBXMLUnarchiver.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 15/02/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBXMLCoding.h"


@interface CBXMLUnarchiver : NSObject {
	NSXMLElement *currentElement;
	NSMutableDictionary *objectsDictionary;
}

- (id)initWithElement:(NSXMLElement *)anElement objectsDictionary:(NSMutableDictionary *)anObjectsDictionary;
- (id)initWithElement:(NSXMLElement *)anElement;

- (CBXMLUnarchiver *)derivedUnarchiverForKey:(NSString *)key;

- (NSArray *)derivedArrayOfUnarchiversForKey:(NSString *)key keyItem:(NSString *)keyItem;

- (void)archiveIDForObject:(id)anObject;
- (id)decodeObjectReferenceForKey:(NSString *)key;

- (NSArray *)arrayOfCalendarDatesForKey:(NSString *)key keyItem:(NSString *)keyItem;

- (BOOL)containsValueForKey:(NSString *)key;

- (NSString *)decodeStringForKey:(NSString *)key;
- (NSDecimalNumber *)decodeDecimalNumberForKey:(NSString *)key;
- (NSNumber *)decodeNumberForKey:(NSString *)key;
- (NSDate *)decodeCalendarDateForKey:(NSString *)key;
- (int)decodeIntForKey:(NSString *)key;
- (BOOL)decodeBoolForKey:(NSString *)key;

@end
