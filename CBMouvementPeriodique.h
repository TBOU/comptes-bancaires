//
//  CBMouvementPeriodique.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 27/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMouvement.h"
#import "CBGlobal.h"


@interface CBMouvementPeriodique : CBMouvement {
	NSString *titre;
	NSCalendarDate *dateDebut;
	BOOL dateFinPresente;
	NSCalendarDate *dateFin;
	NSNumber *valeurPeriodicite;
	CBUnitePeriodicite unitePeriodicite;
	NSNumber *joursAnticipation;
	BOOL anticipationDebutMois;
	NSCalendarDate *dateProchaineEcriture;
	NSMutableArray *datesEcrituresEnSuspens;
}

- (NSString *)titre;
- (void)setTitre:(NSString *)aTitre;

- (NSCalendarDate *)dateDebut;
- (void)setDateDebut:(NSCalendarDate *)aDateDebut;

- (BOOL)dateFinPresente;
- (void)setDateFinPresente:(BOOL)aDateFinPresente;

- (NSCalendarDate *)dateFin;
- (void)setDateFin:(NSCalendarDate *)aDateFin;

- (NSNumber *)valeurPeriodicite;
- (void)setValeurPeriodicite:(NSNumber *)aValeurPeriodicite;

- (CBUnitePeriodicite)unitePeriodicite;
- (void)setUnitePeriodicite:(CBUnitePeriodicite)anUnitePeriodicite;

- (NSNumber *)joursAnticipation;
- (void)setJoursAnticipation:(NSNumber *)aJoursAnticipation;

- (BOOL)anticipationDebutMois;
- (void)setAnticipationDebutMois:(BOOL)anAnticipationDebutMois;

- (NSCalendarDate *)dateProchaineEcriture;
- (void)setDateProchaineEcriture:(NSCalendarDate *)aDateProchaineEcriture;

- (NSMutableArray *)datesEcrituresEnSuspens;
- (int)nombreEcrituresEnSuspens;

- (void)calculeDatesEcrituresEnSuspens:(NSCalendarDate *)dateJour;

@end
