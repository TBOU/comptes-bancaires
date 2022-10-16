//
//  CBXMLArchiver.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 15/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBXMLCoding.h"


@interface CBXMLArchiver : NSObject {
	NSXMLElement *currentElement;
	NSMutableArray *objectsArray;
}

- (id)initWithElement:(NSXMLElement *)anElement objectsArray:(NSMutableArray *)anObjectsArray;
- (id)initWithElement:(NSXMLElement *)anElement;

- (CBXMLArchiver *)derivedArchiverWithElement:(NSXMLElement *)anElement;

- (void)encodeXMLCodingObject:(id <CBXMLCoding>)objv forKey:(NSString *)key withID:(BOOL)isID;

- (void)encodeArrayOfXMLCodingObjects:(NSArray *)objv forKey:(NSString *)key keyItem:(NSString *)keyItem withID:(BOOL)isID;

- (void)encodeArrayOfCalendarDates:(NSArray *)objv forKey:(NSString *)key keyItem:(NSString *)keyItem;

- (void)encodeString:(NSString *)objv forKey:(NSString *)key;
- (void)encodeDecimalNumber:(NSDecimalNumber *)objv forKey:(NSString *)key;
- (void)encodeNumber:(NSNumber *)objv forKey:(NSString *)key;
- (void)encodeCalendarDate:(NSCalendarDate *)objv forKey:(NSString *)key;
- (void)encodeInt:(int)intv forKey:(NSString *)key;
- (void)encodeBool:(BOOL)boolv forKey:(NSString *)key;

@end
