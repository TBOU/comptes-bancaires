//
//  CBGlobal.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright Thierry Boudière 2007 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	CBTypeMouvementIndefini = 0,
	CBTypeMouvementCarteBleue,
	CBTypeMouvementPrelevement,
	CBTypeMouvementCheque,
	CBTypeMouvementChequeEmploiService,
	CBTypeMouvementVirementDebiteur,
	CBTypeMouvementVirementCrediteur,
	CBTypeMouvementDepot
} CBTypeMouvement;


typedef enum {
	CBSigneMouvementDebit = -1,
	CBSigneMouvementIndefini = 0,
	CBSigneMouvementCredit = +1,
} CBSigneMouvement;


typedef enum {
	CBUnitePeriodiciteJour = 1,
	CBUnitePeriodiciteMois,
	CBUnitePeriodiciteAnnee
} CBUnitePeriodicite;


enum {
	CBGenereEcritureAutomatique = 1,
	CBGenereToutesEcrituresAutomatiques,
	CBDiffereEcritureAutomatique,
	CBDiffereToutesEcrituresAutomatiques
};


enum {
	CBTypeDocumentErreur = 1,
	CBContenuFichierErreur = 2,
	CBLargeurPapierErreur = 3
};


extern NSString *CBIntervalleMinMoyenneDefaultKey;

extern NSString *CBAppArchiveVersion;
extern NSString *CBAppErrorDomain;

extern NSString *CBTypeDocumentBinaire;
extern NSString *CBTypeDocumentXML;

extern CBSigneMouvement CBSignePourTypeMouvement(CBTypeMouvement typeMouvement);
extern BOOL CBTypeMouvementCorrect(int typeMouvement);
extern BOOL CBUnitePeriodiciteCorrecte(int unitePeriodicite);
extern NSString *CBLibellePourTypeMouvement(CBTypeMouvement typeMouvement, NSNumber *numeroCheque, NSNumber *numeroChequeEmploiService);
extern NSString *CBStringFromDate(NSDate *aDate, NSString *aFormat);
extern NSDate *CBDateFromString(NSString *aString, NSString *aFormat);
extern int CBDaysSinceReferenceDate(NSDate *aDate);
extern NSDate *CBFirstDayOfYear(NSDate *aDate);
extern NSDate *CBFirstDayOfMonth(NSDate *aDate);
extern NSDate *CBDateByAddingYearsMonthsDays(NSDate *aDate, int years, int months, int days);

