//
//  CBChaineFormatter.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 04/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CBChaineFormatter : NSFormatter {
	BOOL autoriseNil;
	NSCharacterSet *caracteresInterdits;
}

- (id)initWithAutoriseNil:(BOOL)anAutoriseNil caracteresInterdits:(NSCharacterSet *)aCaracteresInterdits;

@end
