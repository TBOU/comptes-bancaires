//
//  CBGlobal.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright Thierry Boudière 2007 . All rights reserved.
//

#import "CBGlobal.h"

NSString *CBIntervalleMinMoyenneDefaultKey = @"CBIntervalleMinMoyenneDefaultKey";

NSString *CBAppArchiveVersion = @"2.1";
NSString *CBAppErrorDomain = @"com.thierryboudiere.ComptesBancaires.ErrorDomain";

NSString *CBTypeDocumentBinaire = @"Comptes Bancaires";
NSString *CBTypeDocumentXML = @"Comptes Bancaires XML";


CBSigneMouvement CBSignePourTypeMouvement(CBTypeMouvement typeMouvement)
{
	switch (typeMouvement) {

		case CBTypeMouvementCarteBleue :
			return CBSigneMouvementDebit;

		case CBTypeMouvementPrelevement :
			return CBSigneMouvementDebit;

		case CBTypeMouvementCheque :
			return CBSigneMouvementDebit;

		case CBTypeMouvementChequeEmploiService :
			return CBSigneMouvementDebit;

		case CBTypeMouvementVirementDebiteur :
			return CBSigneMouvementDebit;

		case CBTypeMouvementVirementCrediteur :
			return CBSigneMouvementCredit;

		case CBTypeMouvementDepot :
			return CBSigneMouvementCredit;

		default :
			return CBSigneMouvementIndefini;
	}
}

BOOL CBTypeMouvementCorrect(int typeMouvement)
{
	switch (typeMouvement) {

		case CBTypeMouvementCarteBleue :
			return YES;

		case CBTypeMouvementPrelevement :
			return YES;

		case CBTypeMouvementCheque :
			return YES;

		case CBTypeMouvementChequeEmploiService :
			return YES;

		case CBTypeMouvementVirementDebiteur :
			return YES;

		case CBTypeMouvementVirementCrediteur :
			return YES;

		case CBTypeMouvementDepot :
			return YES;

		default :
			return NO;
	}
}

BOOL CBUnitePeriodiciteCorrecte(int unitePeriodicite)
{
	switch (unitePeriodicite) {

		case CBUnitePeriodiciteJour :
			return YES;

		case CBUnitePeriodiciteMois :
			return YES;

		case CBUnitePeriodiciteAnnee :
			return YES;

		default :
			return NO;
	}
}

NSString *CBLibellePourTypeMouvement(CBTypeMouvement typeMouvement, NSNumber *numeroCheque, NSNumber *numeroChequeEmploiService)
{
	NSString *key = [NSString stringWithFormat:@"CBLibellePourTypeMouvement%d", typeMouvement];

	if (typeMouvement == CBTypeMouvementCheque)
		return [NSString stringWithFormat:NSLocalizedString(key, nil), numeroCheque];
		
	else if (typeMouvement == CBTypeMouvementChequeEmploiService)
		return [NSString stringWithFormat:NSLocalizedString(key, nil), numeroChequeEmploiService];

	else
		return [NSString stringWithString:NSLocalizedString(key, nil)];
}

NSString *CBStringFromDate(NSDate *aDate, NSString *aFormat)
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:aFormat];
	return [dateFormatter stringFromDate:aDate];
}

NSDate *CBDateFromString(NSString *aString, NSString *aFormat)
{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:aFormat];
	return [dateFormatter dateFromString:aString];
}

int CBDaysSinceReferenceDate(NSDate *aDate)
{
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:aDate];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	NSDate *normalizedDate = [gregorian dateFromComponents:comps];

	unitFlags = NSDayCalendarUnit;
	comps = [gregorian components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:0.0]  toDate:normalizedDate  options:0];
	return [comps day];
}

extern NSDate *CBFirstDayOfYear(NSDate *aDate)
{
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:aDate];
	
	[comps setMonth:1];
	[comps setDay:1];
	
	return [gregorian dateFromComponents:comps];
}

extern NSDate *CBFirstDayOfMonth(NSDate *aDate)
{
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:aDate];
	
	[comps setDay:1];
	
	return [gregorian dateFromComponents:comps];
}

NSDate *CBDateByAddingYearsMonthsDays(NSDate *aDate, int years, int months, int days)
{
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSDateComponents *comps = [[[NSDateComponents alloc] init] autorelease];
	[comps setYear:years];
	[comps setMonth:months];
	[comps setDay:days];
	[comps setHour:0];
	[comps setMinute:0];
	[comps setSecond:0];
	return [gregorian dateByAddingComponents:comps toDate:aDate  options:0];
}
