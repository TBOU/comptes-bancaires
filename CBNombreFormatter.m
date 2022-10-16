//
//  CBNombreFormatter.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 26/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBNombreFormatter.h"


@implementation CBNombreFormatter

- (id)initWithSymboleMonetaire:(NSString *)aSymboleMonetaire autoriseNil:(BOOL)anAutoriseNil autoriseMinus:(BOOL)anAutoriseMinus
{
    if (self = [super init]) {
		
		autoriseNil = anAutoriseNil;
		autoriseMinus = anAutoriseMinus;
		
		if (aSymboleMonetaire) {
			nombreDecimal = YES;
			delegateFormatter = [[NSNumberFormatter alloc] init];
			[delegateFormatter setFormatterBehavior:NSNumberFormatterBehavior10_0];
			[delegateFormatter setFormat:[NSString stringWithFormat:@"#,##0.00 %@;0%@00 %@;- #,##0.00 %@", aSymboleMonetaire, [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator], aSymboleMonetaire, aSymboleMonetaire]];
			[delegateFormatter setDecimalSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]];
			[delegateFormatter setThousandSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
			caracteresAutorises = [[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"+-0123456789%@", [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator]]] retain];
		}
		else {
			nombreDecimal = NO;
			delegateFormatter = nil;
			caracteresAutorises = [[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"+-0123456789"]] retain];
		}
    }
    return self;
}

- (void)dealloc
{
	[delegateFormatter release];
	[caracteresAutorises release];
	[super dealloc];
}

- (NSString *)chaineFiltree:(NSString *)chaineSaisie
{
	int i;
	unichar car;
	NSMutableString *myChaineFiltree = [[NSMutableString alloc] initWithCapacity:7];
	
	for (i = 0; i < [chaineSaisie length]; i++) {
		car = [chaineSaisie characterAtIndex:i];
		if ([caracteresAutorises characterIsMember:car])
			[myChaineFiltree appendString:[NSString stringWithCharacters:&car length:1]];
	}
	
	return [myChaineFiltree autorelease];
}

- (NSString *)stringForObjectValue:(id)anObject
{
	if (anObject == nil) {
		return nil;
	}
	
	if (nombreDecimal && [anObject isKindOfClass:[NSDecimalNumber class]]) {
		return [delegateFormatter stringForObjectValue:anObject];
	}
	else if (!nombreDecimal && [anObject isKindOfClass:[NSNumber class]]) {
		return [NSString stringWithFormat:@"%qi", [anObject  longLongValue]];
	}
	else {
		return nil;
	}
}


- (NSAttributedString *)attributedStringForObjectValue:(id)anObject withDefaultAttributes:(NSDictionary *)attributes
{
	NSString *myString = [self stringForObjectValue:anObject];
	if (myString) {

		NSMutableDictionary *md = [attributes mutableCopy];
		
		if (autoriseMinus && nombreDecimal && [anObject isKindOfClass:[NSDecimalNumber class]] && [anObject compare:[NSDecimalNumber zero]] == NSOrderedAscending) {
			NSColor *fgColor = [NSColor redColor];
			[md setObject:fgColor forKey:NSForegroundColorAttributeName];
		}
		
		NSAttributedString *atString = [[NSAttributedString alloc] initWithString:myString attributes:md];
		[md release];
		[atString autorelease];
		return atString;
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

	NSScanner *myScanner = [NSScanner localizedScannerWithString:[self chaineFiltree:string]];
	
	if (nombreDecimal) {
		double myValue;
		if ([myScanner scanDouble:&myValue]) {
			if ( autoriseMinus || myValue >= 0) {
				if (anObject) {
					NSDecimal myDecimal = [[NSNumber numberWithDouble:myValue] decimalValue];
					NSDecimalRound(&myDecimal, &myDecimal, 2, NSRoundPlain);
					NSDecimalCompact(&myDecimal);
					*anObject = [NSDecimalNumber decimalNumberWithDecimal:myDecimal];
					}
				return YES;
			}
			else {
				if (error)
					*error = NSLocalizedString(@"CBFormatageNegativeMessageErreur", nil);
				return NO;
			}
		}
		else {
			if (error)
				*error = NSLocalizedString(@"CBFormatageInvalideMessageErreur", nil);
			return NO;
		}
	}
	else {
		long long myValue;
		if ([myScanner scanLongLong:&myValue]) {
			if ( autoriseMinus || myValue >= 0) {
				if (anObject) {
					*anObject = [NSNumber numberWithLongLong:myValue];
				}
				return YES;
			}
			else {
				if (error)
					*error = NSLocalizedString(@"CBFormatageNegativeMessageErreur", nil);
				return NO;
			}
		}
		else {
			if (error)
				*error = NSLocalizedString(@"CBFormatageInvalideMessageErreur", nil);
			return NO;
		}
	}
}

@end
