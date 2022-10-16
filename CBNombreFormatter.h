//
//  CBNombreFormatter.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 26/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CBNombreFormatter : NSFormatter {
	BOOL autoriseNil;
	BOOL autoriseMinus;
	BOOL nombreDecimal;
	NSNumberFormatter *delegateFormatter;
	NSCharacterSet *caracteresAutorises;
}

- (id)initWithSymboleMonetaire:(NSString *)aSymboleMonetaire autoriseNil:(BOOL)anAutoriseNil autoriseMinus:(BOOL)anAutoriseMinus;

- (NSString *)chaineFiltree:(NSString *)chaineSaisie;

@end
