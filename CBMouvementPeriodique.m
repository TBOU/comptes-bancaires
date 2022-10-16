//
//  CBMouvementPeriodique.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 27/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBMouvementPeriodique.h"


@implementation CBMouvementPeriodique

+ (void)initialize {
	[self setKeys:[NSArray arrayWithObjects:@"dateDebut", nil] triggerChangeNotificationsForDependentKey:@"nombreEcrituresEnSuspens"];
}

- (id)init
{
    if (self = [super init]) {
		
		[self setOperation:CBTypeMouvementPrelevement];
		
		[self setTitre:NSLocalizedString(@"CBDefautTitreMouvementPeriodique", nil)];
		[self setDateDebut:[NSCalendarDate calendarDate]];
		[self setDateFinPresente:NO];
		[self setDateFin:nil];
		[self setValeurPeriodicite:[NSNumber numberWithLongLong:1]];
		[self setUnitePeriodicite:CBUnitePeriodiciteMois];
		[self setJoursAnticipation:[NSNumber numberWithLongLong:0]];
		[self setAnticipationDebutMois:NO];
		[self setDateProchaineEcriture:dateDebut];
		datesEcrituresEnSuspens = [[NSMutableArray alloc] initWithCapacity:7];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
		[self setTitre:[decoder decodeObjectForKey:@"titre"]];
		[self setDateDebut:[decoder decodeObjectForKey:@"dateDebut"]];
		[self setDateFinPresente:[decoder decodeBoolForKey:@"dateFinPresente"]];
		[self setDateFin:[decoder decodeObjectForKey:@"dateFin"]];
		[self setValeurPeriodicite:[decoder decodeObjectForKey:@"valeurPeriodicite"]];
		[self setUnitePeriodicite:[decoder decodeIntForKey:@"unitePeriodicite"]];
		[self setJoursAnticipation:[decoder decodeObjectForKey:@"joursAnticipation"]];
		[self setAnticipationDebutMois:[decoder decodeBoolForKey:@"anticipationDebutMois"]];
		[self setDateProchaineEcriture:[decoder decodeObjectForKey:@"dateProchaineEcriture"]];
		datesEcrituresEnSuspens = [[decoder decodeObjectForKey:@"datesEcrituresEnSuspens"] retain];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[super encodeWithCoder:encoder];
	[encoder encodeObject:titre forKey:@"titre"];
	[encoder encodeObject:dateDebut forKey:@"dateDebut"];
	[encoder encodeBool:dateFinPresente forKey:@"dateFinPresente"];
	[encoder encodeObject:dateFin forKey:@"dateFin"];
	[encoder encodeObject:valeurPeriodicite forKey:@"valeurPeriodicite"];
	[encoder encodeInt:unitePeriodicite forKey:@"unitePeriodicite"];
	[encoder encodeObject:joursAnticipation forKey:@"joursAnticipation"];
	[encoder encodeBool:anticipationDebutMois forKey:@"anticipationDebutMois"];
	[encoder encodeObject:dateProchaineEcriture forKey:@"dateProchaineEcriture"];
	[encoder encodeObject:datesEcrituresEnSuspens forKey:@"datesEcrituresEnSuspens"];
}

- (id)initWithXMLUnarchiver:(CBXMLUnarchiver *)xmlUnarchiver
{
	id decodedObject;
	int decodedInt;

    if (self = [super initWithXMLUnarchiver:xmlUnarchiver]) {

		decodedObject = [xmlUnarchiver decodeStringForKey:@"titre"];
		if (decodedObject != nil)
			[self setTitre:decodedObject];

		decodedObject = [xmlUnarchiver decodeCalendarDateForKey:@"dateDebut"];
		if (decodedObject != nil)
			[self setDateDebut:decodedObject];

		[self setDateFinPresente:[xmlUnarchiver decodeBoolForKey:@"dateFinPresente"]];

		decodedObject = [xmlUnarchiver decodeCalendarDateForKey:@"dateFin"];
		if (decodedObject != nil)
			[self setDateFin:decodedObject];

		decodedObject = [xmlUnarchiver decodeNumberForKey:@"valeurPeriodicite"];
		if (decodedObject != nil)
			[self setValeurPeriodicite:decodedObject];

		decodedInt = [xmlUnarchiver decodeIntForKey:@"unitePeriodicite"];
		if (CBUnitePeriodiciteCorrecte(decodedInt))
			[self setUnitePeriodicite:decodedInt];

		decodedObject = [xmlUnarchiver decodeNumberForKey:@"joursAnticipation"];
		if (decodedObject != nil)
			[self setJoursAnticipation:decodedObject];

		[self setAnticipationDebutMois:[xmlUnarchiver decodeBoolForKey:@"anticipationDebutMois"]];

		decodedObject = [xmlUnarchiver decodeCalendarDateForKey:@"dateProchaineEcriture"];
		if (decodedObject != nil)
			[self setDateProchaineEcriture:decodedObject];
		else
			[self setDateProchaineEcriture:nil];	// Pour gérer le cas où le mouvement périodique est terminé

		decodedObject = [xmlUnarchiver arrayOfCalendarDatesForKey:@"datesEcrituresEnSuspens" keyItem:@"datesEcrituresEnSuspensItem"];
		if (decodedObject != nil)
			[[self datesEcrituresEnSuspens] addObjectsFromArray:decodedObject];

    }
    return self;
}

- (void)encodeWithXMLArchiver:(CBXMLArchiver *)xmlArchiver
{
	[super encodeWithXMLArchiver:xmlArchiver];
	[xmlArchiver encodeString:titre forKey:@"titre"];
	[xmlArchiver encodeCalendarDate:dateDebut forKey:@"dateDebut"];
	[xmlArchiver encodeBool:dateFinPresente forKey:@"dateFinPresente"];
	[xmlArchiver encodeCalendarDate:dateFin forKey:@"dateFin"];
	[xmlArchiver encodeNumber:valeurPeriodicite forKey:@"valeurPeriodicite"];
	[xmlArchiver encodeInt:unitePeriodicite forKey:@"unitePeriodicite"];
	[xmlArchiver encodeNumber:joursAnticipation forKey:@"joursAnticipation"];
	[xmlArchiver encodeBool:anticipationDebutMois forKey:@"anticipationDebutMois"];
	[xmlArchiver encodeCalendarDate:dateProchaineEcriture forKey:@"dateProchaineEcriture"];
	[xmlArchiver encodeArrayOfCalendarDates:datesEcrituresEnSuspens forKey:@"datesEcrituresEnSuspens" keyItem:@"datesEcrituresEnSuspensItem"];
}

- (void)dealloc
{
	[titre release];
	[dateDebut release];
	[dateFin release];
	[valeurPeriodicite release];
	[joursAnticipation release];
	[dateProchaineEcriture release];
	[datesEcrituresEnSuspens release];
	[super dealloc];
}


- (NSString *)titre
{
	return [[titre copy] autorelease];
}

- (void)setTitre:(NSString *)aTitre
{
	[titre autorelease];
	titre = [aTitre copy];
}

- (NSCalendarDate *)dateDebut
{
	return [[dateDebut copy] autorelease];
}

- (void)setDateDebut:(NSCalendarDate *)aDateDebut
{
	[dateDebut autorelease];
	dateDebut = [aDateDebut copy];

	// On s'assure que dateDebut <= dateFin
	if (dateFin != nil && [dateDebut dayOfCommonEra] > [dateFin dayOfCommonEra]) {
		[self setDateFin:dateDebut];
	}
	
	// On réinitialise la gestion des écritures à générer
	[self setDateProchaineEcriture:dateDebut];
	[datesEcrituresEnSuspens removeAllObjects];
}

- (BOOL)dateFinPresente
{
	return dateFinPresente;
}

- (void)setDateFinPresente:(BOOL)aDateFinPresente
{
	// Si dateFin devient présente, on l'initialise à dateProchaineEcriture ou à dateDebut
	if (!dateFinPresente && aDateFinPresente) {
		
		if (dateProchaineEcriture != nil) {
			[self setDateFin:dateProchaineEcriture];
		}
		else {
			[self setDateFin:dateDebut];
		}
	}
	// Si dateFin devient absente, on la met à nil
	else if (dateFinPresente && !aDateFinPresente) {
		[self setDateFin:nil];
	}

	dateFinPresente = aDateFinPresente;
}

- (NSCalendarDate *)dateFin
{
	return [[dateFin copy] autorelease];
}

- (void)setDateFin:(NSCalendarDate *)aDateFin
{
	[dateFin autorelease];
	dateFin = [aDateFin copy];

	// On s'assure que dateProchaineEcriture <= dateFin
	if (dateFin != nil && dateProchaineEcriture != nil && [dateProchaineEcriture dayOfCommonEra] > [dateFin dayOfCommonEra]) {
		[self setDateProchaineEcriture:nil];
	}
	
	// On s'assure que dateDebut <= dateFin
	if (dateFin != nil && [dateDebut dayOfCommonEra] > [dateFin dayOfCommonEra]) {
		[self setDateDebut:dateFin];
	}
}

- (NSNumber *)valeurPeriodicite
{
	return [[valeurPeriodicite copy] autorelease];
}

- (void)setValeurPeriodicite:(NSNumber *)aValeurPeriodicite
{
	[valeurPeriodicite autorelease];
	valeurPeriodicite = [aValeurPeriodicite copy];
}

- (CBUnitePeriodicite)unitePeriodicite
{
	return unitePeriodicite;
}

- (void)setUnitePeriodicite:(CBUnitePeriodicite)anUnitePeriodicite
{
	unitePeriodicite = anUnitePeriodicite;
}

- (NSNumber *)joursAnticipation
{
	return [[joursAnticipation copy] autorelease];
}

- (void)setJoursAnticipation:(NSNumber *)aJoursAnticipation
{
	[joursAnticipation autorelease];
	joursAnticipation = [aJoursAnticipation copy];
}

- (BOOL)anticipationDebutMois
{
	return anticipationDebutMois;
}

- (void)setAnticipationDebutMois:(BOOL)anAnticipationDebutMois
{
	anticipationDebutMois = anAnticipationDebutMois;
}

- (NSCalendarDate *)dateProchaineEcriture
{
	return [[dateProchaineEcriture copy] autorelease];
}

- (void)setDateProchaineEcriture:(NSCalendarDate *)aDateProchaineEcriture
{
	[dateProchaineEcriture autorelease];
	dateProchaineEcriture = [aDateProchaineEcriture copy];
}

- (NSMutableArray *)datesEcrituresEnSuspens
{
	return datesEcrituresEnSuspens;
}

- (int)nombreEcrituresEnSuspens
{
	return [datesEcrituresEnSuspens count];
}

- (void)calculeDatesEcrituresEnSuspens:(NSCalendarDate *)dateJour
{
	if (dateProchaineEcriture != nil) {
		
		// Calcul de la date de référence
		NSCalendarDate *dateReference;
		if (anticipationDebutMois) {
			dateReference = [[NSCalendarDate dateWithYear:[dateJour yearOfCommonEra] month:[dateJour  monthOfYear] day:1 
																		hour:0 minute:0 second:0 timeZone:[dateJour timeZone]] 
									dateByAddingYears:0 months:1 days:-1 hours:0 minutes:0 seconds:0];
		}
		else {
			dateReference = [dateJour dateByAddingYears:0 months:0 days:[joursAnticipation intValue] hours:0 minutes:0 seconds:0];
		}
		
		// On génère toutes les dates d'écritures ne dépassant pas la date de référence
		while (dateProchaineEcriture != nil && [dateProchaineEcriture dayOfCommonEra] <= [dateReference dayOfCommonEra]) {
			
			[datesEcrituresEnSuspens addObject:[self dateProchaineEcriture]];
			
			if ([valeurPeriodicite intValue] == 0) {
				
				[self setDateProchaineEcriture:nil];
			}
			else {
				
				NSCalendarDate *nouvelleDateProchaineEcriture;
				
				if (unitePeriodicite == CBUnitePeriodiciteAnnee) {
					nouvelleDateProchaineEcriture = [dateProchaineEcriture dateByAddingYears:[valeurPeriodicite intValue] months:0 days:0 
																				hours:0 minutes:0 seconds:0];
				}
				else if (unitePeriodicite == CBUnitePeriodiciteJour) {
					nouvelleDateProchaineEcriture = [dateProchaineEcriture dateByAddingYears:0 months:0 days:[valeurPeriodicite intValue] 
																				hours:0 minutes:0 seconds:0];
				}
				else {
					nouvelleDateProchaineEcriture = [dateProchaineEcriture dateByAddingYears:0 months:[valeurPeriodicite intValue] days:0 
																				hours:0 minutes:0 seconds:0];
				}
				
				[self setDateProchaineEcriture:nouvelleDateProchaineEcriture];
				
				if (dateFin != nil && [dateProchaineEcriture dayOfCommonEra] > [dateFin dayOfCommonEra]) {
					[self setDateProchaineEcriture:nil];
				}
				
			}
		}
	}
}

@end
