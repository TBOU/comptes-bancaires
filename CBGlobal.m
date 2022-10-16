//
//  CBGlobal.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright Thierry Boudière 2006 . All rights reserved.
//

#import "CBGlobal.h"

NSString *CBIntervalleMinMoyenneDefaultKey = @"CBIntervalleMinMoyenneDefaultKey";

NSString *CBAppArchiveVersion = @"2.0";
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

