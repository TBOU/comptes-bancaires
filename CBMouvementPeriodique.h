//
//  CBMouvementPeriodique.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 27/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBMouvement.h"
#import "CBGlobal.h"


@interface CBMouvementPeriodique : CBMouvement {
	NSString *titre;
	NSDate *dateDebut;
	BOOL dateFinPresente;
	NSDate *dateFin;
	NSNumber *valeurPeriodicite;
	CBUnitePeriodicite unitePeriodicite;
	NSNumber *joursAnticipation;
	BOOL anticipationDebutMois;
	NSDate *dateProchaineEcriture;
	NSMutableArray *datesEcrituresEnSuspens;
}

- (NSString *)titre;
- (void)setTitre:(NSString *)aTitre;

- (NSDate *)dateDebut;
- (void)setDateDebut:(NSDate *)aDateDebut;

- (BOOL)dateFinPresente;
- (void)setDateFinPresente:(BOOL)aDateFinPresente;

- (NSDate *)dateFin;
- (void)setDateFin:(NSDate *)aDateFin;

- (NSNumber *)valeurPeriodicite;
- (void)setValeurPeriodicite:(NSNumber *)aValeurPeriodicite;

- (CBUnitePeriodicite)unitePeriodicite;
- (void)setUnitePeriodicite:(CBUnitePeriodicite)anUnitePeriodicite;

- (NSNumber *)joursAnticipation;
- (void)setJoursAnticipation:(NSNumber *)aJoursAnticipation;

- (BOOL)anticipationDebutMois;
- (void)setAnticipationDebutMois:(BOOL)anAnticipationDebutMois;

- (NSDate *)dateProchaineEcriture;
- (void)setDateProchaineEcriture:(NSDate *)aDateProchaineEcriture;

- (NSMutableArray *)datesEcrituresEnSuspens;
- (int)nombreEcrituresEnSuspens;

- (void)calculeDatesEcrituresEnSuspens:(NSDate *)dateJour;

@end
