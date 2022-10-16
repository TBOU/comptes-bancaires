//
//  CBCompte.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBCompte.h"
#import "CBMouvement.h"
#import "Mouvement.h"
#import "CBLibellePredefini.h"
#import "ListeLibelles.h"
#import "CBMouvementPeriodique.h"
#import "CBGlobal.h"


@implementation CBCompte

+ (void)initialize {
	[self setKeys:[NSArray arrayWithObjects:@"banque", @"numeroCompte", nil] triggerChangeNotificationsForDependentKey:@"numeroCompteBanque"];
}

- (id)init
{
    if (self = [super init]) {
		[self setBanque:NSLocalizedString(@"CBDefautBanqueCompte", nil)];
		[self setNumeroCompte:NSLocalizedString(@"CBDefautNumeroCompte", nil)];
		[self setSoldeInitial:[NSDecimalNumber zero]];
		[self setNumeroProchainCheque:[NSNumber numberWithLongLong:0]];
		[self setNumeroProchainChequeEmploiService:[NSNumber numberWithLongLong:0]];
		libellesPredefinis = [[NSMutableArray alloc] initWithCapacity:7];
		mouvementsPeriodiques = [[NSMutableArray alloc] initWithCapacity:7];
		mouvements = [[NSMutableArray alloc] initWithCapacity:7];
		[self setSoldeReel:[NSDecimalNumber zero]];
		[self setSoldeBanque:[NSDecimalNumber zero]];
		[self setSoldeCBEnCours:[NSDecimalNumber zero]];
    }
    return self;
}

- (id)initAvecAncienCompte:(Compte *)ancienCompte
{
    if (self = [self init]) {
		[self setBanque:[ancienCompte banque]];
		[self setNumeroCompte:[ancienCompte numeroCompte]];
		[self setNumeroProchainCheque:[NSNumber numberWithLongLong:[[ancienCompte numeroProchainCheque] longLongValue]]];
		[self setSoldeInitial:[ancienCompte soldeInitial]];
		//[self setSoldeReel:[ancienCompte soldeCompte]];
		//[self setSoldeBanque:[ancienCompte soldeCalcule]];
		//[self setSoldeCBEnCours:[ancienCompte soldeCBEnCours]];
		
		// On récupère les mouvements
		NSEnumerator *enumerator = [[ancienCompte mouvements] objectEnumerator];
		id anObject;
		while (anObject = [enumerator nextObject]) {
			CBMouvement *myMouvement = [[CBMouvement alloc] initAvecAncienMouvement:(Mouvement *)anObject];
			[[self mouvements] addObject:myMouvement];
			[myMouvement release];
		}
		
		
		// On récupère les libellés prédéfinis
		CBTypeMouvement myTypeMouvement;
		CBTypeMouvement myTableauTypeMouvement [] = {	CBTypeMouvementCarteBleue, 
														CBTypeMouvementPrelevement, 
														CBTypeMouvementCheque, 
														CBTypeMouvementVirementCrediteur, 
														CBTypeMouvementDepot
														};
		
		ListeLibelles *myListeLibelles;
		ListeLibelles *myTableauListeLibelles [] = {	[ancienCompte sourceLibellesCarteBleue], 
														[ancienCompte sourceLibellesPrelevement], 
														[ancienCompte sourceLibellesCheque], 
														[ancienCompte sourceLibellesVirement], 
														[ancienCompte sourceLibellesDepot]
														};
		
		NSArray *myLibelles;
		NSArray *myMontants;
		int k, i;

		for (k = 0; k < 5; k++) {
			myTypeMouvement = myTableauTypeMouvement[k];
			myListeLibelles = myTableauListeLibelles[k];
			myLibelles = [myListeLibelles libelles];
			myMontants = [myListeLibelles montants];
			for (i = 0; i < [myLibelles count]; i++) {
				CBLibellePredefini *myLibellePredefini = [[CBLibellePredefini alloc] init];
				[myLibellePredefini setOperation:myTypeMouvement];
				[myLibellePredefini setLibelle:[myLibelles objectAtIndex:i]];
				NSDecimalNumber *montant = [myMontants objectAtIndex:i];
				if (montant != nil && ![montant isEqualToNumber:[NSDecimalNumber zero]])
					[myLibellePredefini setMontant:montant];
				[[self libellesPredefinis] addObject:myLibellePredefini];
				[myLibellePredefini release];
			}
		}
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
		[self setBanque:[decoder decodeObjectForKey:@"banque"]];
		[self setNumeroCompte:[decoder decodeObjectForKey:@"numeroCompte"]];
		[self setSoldeInitial:[decoder decodeObjectForKey:@"soldeInitial"]];
		[self setNumeroProchainCheque:[decoder decodeObjectForKey:@"numeroProchainCheque"]];
		[self setNumeroProchainChequeEmploiService:[decoder decodeObjectForKey:@"numeroProchainChequeEmploiService"]];
		libellesPredefinis = [[decoder decodeObjectForKey:@"libellesPredefinis"] retain];
		mouvementsPeriodiques = [[decoder decodeObjectForKey:@"mouvementsPeriodiques"] retain];
		mouvements = [[decoder decodeObjectForKey:@"mouvements"] retain];
		[self setSoldeReel:[decoder decodeObjectForKey:@"soldeReel"]];
		[self setSoldeBanque:[decoder decodeObjectForKey:@"soldeBanque"]];
		[self setSoldeCBEnCours:[decoder decodeObjectForKey:@"soldeCBEnCours"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:banque forKey:@"banque"];
	[encoder encodeObject:numeroCompte forKey:@"numeroCompte"];
	[encoder encodeObject:soldeInitial forKey:@"soldeInitial"];
	[encoder encodeObject:numeroProchainCheque forKey:@"numeroProchainCheque"];
	[encoder encodeObject:numeroProchainChequeEmploiService forKey:@"numeroProchainChequeEmploiService"];
	[encoder encodeObject:libellesPredefinis forKey:@"libellesPredefinis"];
	[encoder encodeObject:mouvementsPeriodiques forKey:@"mouvementsPeriodiques"];
	[encoder encodeObject:mouvements forKey:@"mouvements"];
	[encoder encodeObject:soldeReel forKey:@"soldeReel"];
	[encoder encodeObject:soldeBanque forKey:@"soldeBanque"];
	[encoder encodeObject:soldeCBEnCours forKey:@"soldeCBEnCours"];
}

- (id)initWithXMLUnarchiver:(CBXMLUnarchiver *)xmlUnarchiver
{
	id decodedObject;
	
    if (self = [self init]) {
	
		decodedObject = [xmlUnarchiver decodeStringForKey:@"banque"];
		if (decodedObject != nil)
			[self setBanque:decodedObject];
		
		decodedObject = [xmlUnarchiver decodeStringForKey:@"numeroCompte"];
		if (decodedObject != nil)
			[self setNumeroCompte:decodedObject];

		decodedObject = [xmlUnarchiver decodeDecimalNumberForKey:@"soldeInitial"];
		if (decodedObject != nil)
			[self setSoldeInitial:decodedObject];

		decodedObject = [xmlUnarchiver decodeNumberForKey:@"numeroProchainCheque"];
		if (decodedObject != nil)
			[self setNumeroProchainCheque:decodedObject];

		decodedObject = [xmlUnarchiver decodeNumberForKey:@"numeroProchainChequeEmploiService"];
		if (decodedObject != nil)
			[self setNumeroProchainChequeEmploiService:decodedObject];


		NSArray *array;
		NSEnumerator *enumerator;
		id anObject;
		
		// On récupère les libellés prédéfinis
		array = [xmlUnarchiver derivedArrayOfUnarchiversForKey:@"libellesPredefinis" keyItem:@"libellesPredefinisItem"];
		if (array != nil) {
			enumerator = [array objectEnumerator];
			while (anObject = [enumerator nextObject]) {
				CBLibellePredefini *myLibellePredefini = [[CBLibellePredefini alloc] initWithXMLUnarchiver:(CBXMLUnarchiver *)anObject];
				[[self libellesPredefinis] addObject:myLibellePredefini];
				[myLibellePredefini release];
			}
		}

		// On récupère les mouvements périodiques
		array = [xmlUnarchiver derivedArrayOfUnarchiversForKey:@"mouvementsPeriodiques" keyItem:@"mouvementsPeriodiquesItem"];
		if (array != nil) {
			enumerator = [array objectEnumerator];
			while (anObject = [enumerator nextObject]) {
				CBMouvementPeriodique *myMouvementPeriodique = [[CBMouvementPeriodique alloc] initWithXMLUnarchiver:(CBXMLUnarchiver *)anObject];
				[[self mouvementsPeriodiques] addObject:myMouvementPeriodique];
				[myMouvementPeriodique release];
			}
		}

		// On récupère les mouvements
		array = [xmlUnarchiver derivedArrayOfUnarchiversForKey:@"mouvements" keyItem:@"mouvementsItem"];
		if (array != nil) {
			enumerator = [array objectEnumerator];
			while (anObject = [enumerator nextObject]) {
				CBMouvement *myMouvement = [[CBMouvement alloc] initWithXMLUnarchiver:(CBXMLUnarchiver *)anObject];
				[[self mouvements] addObject:myMouvement];
				[myMouvement release];
			}
		}

    }
    return self;
}

- (void)encodeWithXMLArchiver:(CBXMLArchiver *)xmlArchiver
{
	[xmlArchiver encodeString:banque forKey:@"banque"];
	[xmlArchiver encodeString:numeroCompte forKey:@"numeroCompte"];
	[xmlArchiver encodeDecimalNumber:soldeInitial forKey:@"soldeInitial"];
	[xmlArchiver encodeNumber:numeroProchainCheque forKey:@"numeroProchainCheque"];
	[xmlArchiver encodeNumber:numeroProchainChequeEmploiService forKey:@"numeroProchainChequeEmploiService"];
	[xmlArchiver encodeArrayOfXMLCodingObjects:libellesPredefinis forKey:@"libellesPredefinis" keyItem:@"libellesPredefinisItem" withID:NO];
	[xmlArchiver encodeArrayOfXMLCodingObjects:mouvementsPeriodiques forKey:@"mouvementsPeriodiques" keyItem:@"mouvementsPeriodiquesItem" withID:NO];
	[xmlArchiver encodeArrayOfXMLCodingObjects:mouvements forKey:@"mouvements" keyItem:@"mouvementsItem" withID:NO];
	[xmlArchiver encodeDecimalNumber:soldeReel forKey:@"soldeReel"];
	[xmlArchiver encodeDecimalNumber:soldeBanque forKey:@"soldeBanque"];
	[xmlArchiver encodeDecimalNumber:soldeCBEnCours forKey:@"soldeCBEnCours"];
}

- (void)dealloc
{
	[banque release];
	[numeroCompte release];
	[soldeInitial release];
	[numeroProchainCheque release];
	[numeroProchainChequeEmploiService release];
	[libellesPredefinis release];
	[mouvementsPeriodiques release];
	[mouvements release];
	[soldeReel release];
	[soldeBanque release];
	[soldeCBEnCours release];
	[super dealloc];
}

- (NSString *)banque
{
	return [[banque copy] autorelease];
}

- (void)setBanque:(NSString *)aBanque
{
	[banque autorelease];
	banque = [aBanque copy];
}

- (NSString *)numeroCompte
{
	return [[numeroCompte copy] autorelease];
}

- (void)setNumeroCompte:(NSString *)aNumeroCompte
{
	[numeroCompte autorelease];
	numeroCompte = [aNumeroCompte copy];
}

- (NSString *)numeroCompteBanque
{
	return [NSString stringWithFormat:@"%@ (%@)", numeroCompte, banque];
}

- (NSDecimalNumber *)soldeInitial
{
	return [[soldeInitial copy] autorelease];
}

- (void)setSoldeInitial:(NSDecimalNumber *)aSoldeInitial
{
	[soldeInitial autorelease];
	soldeInitial = [aSoldeInitial copy];
}

- (NSNumber *)numeroProchainCheque
{
	return [[numeroProchainCheque copy] autorelease];
}

- (void)setNumeroProchainCheque:(NSNumber *)aNumeroProchainCheque
{
	[numeroProchainCheque autorelease];
	numeroProchainCheque = [aNumeroProchainCheque copy];
}

- (void)augmenteNumeroProchainCheque
{
	[self setNumeroProchainCheque:[NSNumber numberWithLongLong:[[self numeroProchainCheque] longLongValue] + 1]];
}

- (NSNumber *)numeroProchainChequeEmploiService
{
	return [[numeroProchainChequeEmploiService copy] autorelease];
}

- (void)setNumeroProchainChequeEmploiService:(NSNumber *)aNumeroProchainChequeEmploiService
{
	[numeroProchainChequeEmploiService autorelease];
	numeroProchainChequeEmploiService = [aNumeroProchainChequeEmploiService copy];
}

- (void)augmenteNumeroProchainChequeEmploiService
{
	[self setNumeroProchainChequeEmploiService:[NSNumber numberWithLongLong:[[self numeroProchainChequeEmploiService] longLongValue] + 1]];
}

- (NSMutableArray *)libellesPredefinis
{
	return libellesPredefinis;
}

- (NSMutableArray *)mouvementsPeriodiques
{
	return mouvementsPeriodiques;
}

- (NSMutableArray *)mouvements
{
	return mouvements;
}

- (NSDecimalNumber *)soldeReel
{
	return [[soldeReel copy] autorelease];
}

- (void)setSoldeReel:(NSDecimalNumber *)aSoldeReel
{
	[soldeReel autorelease];
	soldeReel = [aSoldeReel copy];
}

- (NSDecimalNumber *)soldeBanque
{
	return [[soldeBanque copy] autorelease];
}

- (void)setSoldeBanque:(NSDecimalNumber *)aSoldeBanque
{
	[soldeBanque autorelease];
	soldeBanque = [aSoldeBanque copy];
}

- (NSDecimalNumber *)soldeCBEnCours
{
	return [[soldeCBEnCours copy] autorelease];
}

- (void)setSoldeCBEnCours:(NSDecimalNumber *)aSoldeCBEnCours
{
	[soldeCBEnCours autorelease];
	soldeCBEnCours = [aSoldeCBEnCours copy];
}

- (void)copieParametresDepuis:(CBCompte *)aCompte
{
	[self setBanque:[aCompte banque]];
	[self setNumeroCompte:[aCompte numeroCompte]];
	[self setSoldeInitial:[aCompte soldeInitial]];
	[self setNumeroProchainCheque:[aCompte numeroProchainCheque]];
	[self setNumeroProchainChequeEmploiService:[aCompte numeroProchainChequeEmploiService]];
}

- (void)calculeSoldes
{
    NSDecimal soldeReelDecimal;
    NSDecimal soldeBanqueDecimal;
    NSDecimal soldeCBEnCoursDecimal;
	NSArray *mouvementsTries;
	NSDecimal montant;
	NSDecimal montantAvecSigne;
	
	soldeReelDecimal = [[self soldeInitial] decimalValue];
	soldeBanqueDecimal = [[self soldeInitial] decimalValue];
	soldeCBEnCoursDecimal = [[NSDecimalNumber zero] decimalValue];
	
	NSSortDescriptor *mouvementsDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
	mouvementsTries =[[self mouvements] sortedArrayUsingDescriptors:[NSArray arrayWithObject:mouvementsDescriptor]];
	[mouvementsDescriptor release];
	
	NSEnumerator *enumerator = [mouvementsTries objectEnumerator];
	CBMouvement *anObject;
	while (anObject = (CBMouvement *)[enumerator nextObject]) {

		montant = [[anObject montant] decimalValue];
		
		if (CBSignePourTypeMouvement([anObject operation]) == CBSigneMouvementDebit)
			montantAvecSigne = [[[NSDecimalNumber zero] decimalNumberBySubtracting:[anObject montant]] decimalValue];
		else if (CBSignePourTypeMouvement([anObject operation]) == CBSigneMouvementCredit)
			montantAvecSigne = [[anObject montant] decimalValue];
		else
			montantAvecSigne = [[NSDecimalNumber zero] decimalValue];
		
		NSDecimalAdd(&soldeReelDecimal, &soldeReelDecimal, &montantAvecSigne, NSRoundPlain);

		NSDecimalCompact(&soldeReelDecimal);
		[anObject setAvoir:[NSDecimalNumber decimalNumberWithDecimal:soldeReelDecimal]];
		
		if ([anObject pointage])
			NSDecimalAdd(&soldeBanqueDecimal, &soldeBanqueDecimal, &montantAvecSigne, NSRoundPlain);
		
		if ([anObject operation] == CBTypeMouvementCarteBleue && ![anObject pointage])
			NSDecimalAdd(&soldeCBEnCoursDecimal, &soldeCBEnCoursDecimal, &montant, NSRoundPlain);
	}
	
	NSDecimalCompact(&soldeReelDecimal);
	[self setSoldeReel:[NSDecimalNumber decimalNumberWithDecimal:soldeReelDecimal]];
	NSDecimalCompact(&soldeBanqueDecimal);
	[self setSoldeBanque:[NSDecimalNumber decimalNumberWithDecimal:soldeBanqueDecimal]];
	NSDecimalCompact(&soldeCBEnCoursDecimal);
	[self setSoldeCBEnCours:[NSDecimalNumber decimalNumberWithDecimal:soldeCBEnCoursDecimal]];
}

- (void)clotureExercicePourDate:(NSDate *)dateCloture
{
	NSDecimal soldeInitialDecimal;
	NSDecimal montantAvecSigne;
	
	soldeInitialDecimal = [[self soldeInitial] decimalValue];

	NSEnumerator *enumerator = [[self mouvements] objectEnumerator];
	CBMouvement *anObject;
	NSMutableIndexSet *myIndexSet = [[NSMutableIndexSet alloc] init];
	
	// On parcourt les mouvements
	while (anObject = (CBMouvement *)[enumerator nextObject]) {
		
		if ([anObject pointage] && CBDaysSinceReferenceDate([anObject date]) < CBDaysSinceReferenceDate(dateCloture)) {
			
			if (CBSignePourTypeMouvement([anObject operation]) == CBSigneMouvementDebit)
				montantAvecSigne = [[[NSDecimalNumber zero] decimalNumberBySubtracting:[anObject montant]] decimalValue];
			else if (CBSignePourTypeMouvement([anObject operation]) == CBSigneMouvementCredit)
				montantAvecSigne = [[anObject montant] decimalValue];
			else
				montantAvecSigne = [[NSDecimalNumber zero] decimalValue];
			
			NSDecimalAdd(&soldeInitialDecimal, &soldeInitialDecimal, &montantAvecSigne, NSRoundPlain);
			
			[myIndexSet addIndex:[[self mouvements] indexOfObjectIdenticalTo:anObject]];
		}
	}
	
	// On efface les mouvements archivés et on met à jour le solde initial
	[[self mouvements] removeObjectsAtIndexes:myIndexSet];
	[myIndexSet release];
	NSDecimalCompact(&soldeInitialDecimal);
	[self setSoldeInitial:[NSDecimalNumber decimalNumberWithDecimal:soldeInitialDecimal]];
	
}

@end
