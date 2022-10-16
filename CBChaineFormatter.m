//
//  CBChaineFormatter.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 04/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBChaineFormatter.h"


@implementation CBChaineFormatter

- (id)initWithAutoriseNil:(BOOL)anAutoriseNil caracteresInterdits:(NSCharacterSet *)aCaracteresInterdits
{
    if (self = [super init]) {
		
		autoriseNil = anAutoriseNil;
		caracteresInterdits = [aCaracteresInterdits copy];
    }
    return self;
}

- (void)dealloc
{
	[caracteresInterdits release];
	[super dealloc];
}

- (NSString *)stringForObjectValue:(id)anObject
{
	if (anObject == nil) {
		return nil;
	}
	
	if ([anObject isKindOfClass:[NSString class]]) {
		return [NSString stringWithString:anObject];
	}
	else {
		return nil;
	}
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error
{
	if (string == nil || [string isEqualToString:@""]) {
		if (autoriseNil) {
			if (anObject)
				*anObject = nil;
			return YES;
		}
		else {
			if (error)
				*error = NSLocalizedString(@"CBFormatageNilMessageErreur", nil);
			return NO;
		}
	}
	
	if (caracteresInterdits != nil) {
		if ([string rangeOfCharacterFromSet:caracteresInterdits].location != NSNotFound) {
			if (error)
				*error = NSLocalizedString(@"CBFormatageCaracteresInterditsMessageErreur", nil);
			return NO;
		}
	}
	
	if (anObject)
		*anObject = [NSString stringWithString:string];
	return YES;
}

@end
