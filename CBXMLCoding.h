//
//  CBXMLCoding.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright Thierry Boudière 2006 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CBXMLUnarchiver;
@class CBXMLArchiver;

@protocol CBXMLCoding

- (id)initWithXMLUnarchiver:(CBXMLUnarchiver *)xmlUnarchiver;

- (void)encodeWithXMLArchiver:(CBXMLArchiver *)xmlArchiver;

@end
