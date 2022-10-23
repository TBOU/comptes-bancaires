//
//  CBCompteController.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBCompteController.h"
#import "CBDocument.h"
#import "CBNombreFormatter.h"
#import "CBChaineFormatter.h"
#import "CBLibellePredefini.h"
#import "CBMouvementPeriodique.h"
#import "CBStatistiqueCategorie.h"
#import "CBVueImpressionCompte.h"
#import "CBGlobal.h"
#import "NSTableView+CBExtension.h"


@implementation CBCompteController

- (id)initWithPortefeuille:(CBPortefeuille *)aPortefeuille Compte:(CBCompte *)aCompte
{
	if (self = [super initWithWindowNibName:@"Compte"]) {
		managedPortefeuille = [aPortefeuille retain];
		managedCompte = [aCompte retain];

		NSDate *dateJour = [NSDate date];
		[self setDateDebutStatistiques:CBFirstDayOfYear(dateJour)];
		[self setDateFinStatistiques:dateJour];
		
		[self setImpressionTousMouvements:YES];
		[self setDateDebutImpression:dateJour];
		[self setDateFinImpression:dateJour];
		
		[self setShouldCascadeWindows:NO];
		[self setWindowFrameAutosaveName:@"CompteWindow"];
	}
	return self;
}

- (void)windowDidLoad
{
	[self appliqueFormateurs];

	[tableMouvements setDoubleAction:@selector(debutEditionMouvement:)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											selector:@selector(textDidChange:) 
											name:@"NSControlTextDidChangeNotification" 
											object:tableLibellesPredefinis];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											selector:@selector(tableViewSelectionDidChange:) 
											name:@"NSTableViewSelectionDidChangeNotification" 
											object:tableMouvements];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											selector:@selector(tableViewSelectionDidChange:) 
											name:@"NSTableViewSelectionDidChangeNotification" 
											object:tableLibellesPredefinis];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											selector:@selector(tableViewSelectionDidChange:) 
											name:@"NSTableViewSelectionDidChangeNotification" 
											object:tableMouvementsPeriodiques];
	
	NSSortDescriptor *mouvementsDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
	[mouvementsControler setSortDescriptors:[NSArray arrayWithObject:mouvementsDescriptor]];
	[mouvementsDescriptor release];

	if ([[mouvementsControler arrangedObjects] count] > 0)
		[mouvementsControler setSelectionIndex:[[mouvementsControler arrangedObjects] count] - 1];
    
    [tableMouvements cbRepairLayoutDeferred];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[managedPortefeuille release];
	[managedCompte release];
	[dateDebutStatistiques release];
	[dateFinStatistiques  release];
	[dateDebutImpression release];
	[dateFinImpression  release];
	[super dealloc];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	return [NSString stringWithFormat:NSLocalizedString(@"CBTitreFenetreCompte", nil), displayName, [[self managedCompte] numeroCompte], [[self managedCompte] banque]];
}

- (CBPortefeuille *)managedPortefeuille
{
	return managedPortefeuille;
}

- (CBCompte *)managedCompte
{
	return managedCompte;
}

- (NSDate *)dateDebutStatistiques
{
	return [[dateDebutStatistiques copy] autorelease];
}

- (void)setDateDebutStatistiques:(NSDate *)aDateDebutStatistiques
{
	[dateDebutStatistiques autorelease];
	dateDebutStatistiques = [aDateDebutStatistiques copy];

	// On s'assure que dateDebutStatistiques <= dateFinStatistiques
	if (CBDaysSinceReferenceDate(dateDebutStatistiques) > CBDaysSinceReferenceDate(dateFinStatistiques)) {
		[self setDateFinStatistiques:dateDebutStatistiques];
	}
}

- (NSDate *)dateFinStatistiques
{
	return [[dateFinStatistiques copy] autorelease];
}

- (void)setDateFinStatistiques:(NSDate *)aDateFinStatistiques
{
	[dateFinStatistiques autorelease];
	dateFinStatistiques = [aDateFinStatistiques copy];

	// On s'assure que dateDebutStatistiques <= dateFinStatistiques
	if (CBDaysSinceReferenceDate(dateDebutStatistiques) > CBDaysSinceReferenceDate(dateFinStatistiques)) {
		[self setDateDebutStatistiques:dateFinStatistiques];
	}
}

- (BOOL)impressionTousMouvements
{
	return impressionTousMouvements;
}

- (void)setImpressionTousMouvements:(BOOL)anImpressionTousMouvements
{
	impressionTousMouvements = anImpressionTousMouvements;
}

- (NSDate *)dateDebutImpression
{
	return [[dateDebutImpression copy] autorelease];
}

- (void)setDateDebutImpression:(NSDate *)aDateDebutImpression
{
	[dateDebutImpression autorelease];
	dateDebutImpression = [aDateDebutImpression copy];

	// On s'assure que dateDebutImpression <= dateFinImpression
	if (CBDaysSinceReferenceDate(dateDebutImpression) > CBDaysSinceReferenceDate(dateFinImpression)) {
		[self setDateFinImpression:dateDebutImpression];
	}
}

- (NSDate *)dateFinImpression
{
	return [[dateFinImpression copy] autorelease];
}

- (void)setDateFinImpression:(NSDate *)aDateFinImpression
{
	[dateFinImpression autorelease];
	dateFinImpression = [aDateFinImpression copy];

	// On s'assure que dateDebutImpression <= dateFinImpression
	if (CBDaysSinceReferenceDate(dateDebutImpression) > CBDaysSinceReferenceDate(dateFinImpression)) {
		[self setDateDebutImpression:dateFinImpression];
	}
}

- (void)appliqueFormateurs
{
	NSDateFormatter *dateFormateur = [[self document] dateFormateur];
	CBNombreFormatter *soldeFormateur = [[self document] soldeFormateur];
	CBNombreFormatter *montantFormateurAvecNil = [[self document] montantFormateurAvecNil];
	CBNombreFormatter *montantFormateur = [[self document] montantFormateur];
	CBNombreFormatter *numeroFormateur = [[self document] numeroFormateur];
	CBChaineFormatter *texteFormateur = [[self document] texteFormateur];
	
	[[champSoldeReel cell] setFormatter:soldeFormateur];
	[[champSoldeBanque cell] setFormatter:soldeFormateur];
	[[champSoldeCBEnCours cell] setFormatter:montantFormateur];
	[[champSoldeMouvementsFiltres cell] setFormatter:soldeFormateur];
	
	[[champBanque cell] setFormatter:texteFormateur];
	[[champNumeroCompte cell] setFormatter:texteFormateur];
	[[champSoldeInitial cell] setFormatter:soldeFormateur];
	[[champNumeroProchainCheque cell] setFormatter:numeroFormateur];
	[[champNumeroProchainChequeEmploiService cell] setFormatter:numeroFormateur];
	
	[[champLibelleMouvementSingle cell] setFormatter:texteFormateur];
	[[champNumeroChequeSingle cell] setFormatter:numeroFormateur];
	[[champNumeroChequeEmploiServiceSingle cell] setFormatter:numeroFormateur];
	[[champMontantMouvementSingle cell] setFormatter:montantFormateur];
	
	[[champLibelleMouvementMultiple cell] setFormatter:texteFormateur];
	[[champNumeroChequeMultiple cell] setFormatter:numeroFormateur];
	[[champNumeroChequeEmploiServiceMultiple cell] setFormatter:numeroFormateur];
	[[champMontantMouvementMultiple cell] setFormatter:montantFormateur];
	
	[[champTitreMouvementPeriodique cell] setFormatter:texteFormateur];
	[[champValeurPeriodicite cell] setFormatter:numeroFormateur];
	[[champJoursAnticipation cell] setFormatter:numeroFormateur];
	[[champLibelleMouvementPeriodique cell] setFormatter:texteFormateur];
	[[champMontantMouvementPeriodique cell] setFormatter:montantFormateur];
	[[champDateProchaineEcriture cell] setFormatter:dateFormateur];
	[[champNombreEcrituresEnSuspens cell] setFormatter:numeroFormateur];

	[[champStatistiquesDebitPeriode cell] setFormatter:montantFormateur];
	[[champStatistiquesDebitMensuel cell] setFormatter:montantFormateur];
	[[champStatistiquesCreditPeriode cell] setFormatter:montantFormateur];
	[[champStatistiquesCreditMensuel cell] setFormatter:montantFormateur];

	[[colonneDate dataCell] setFormatter:dateFormateur];
	[[colonneDebit dataCell] setFormatter:montantFormateur];
	[[colonneCredit dataCell] setFormatter:montantFormateur];
	[[colonneAvoir dataCell] setFormatter:soldeFormateur];
	
	[[colonneLibellePredefini dataCell] setFormatter:texteFormateur];
	[[colonneMontantPredefini dataCell] setFormatter:montantFormateurAvecNil];

	[[colonneStatistiquesSoldePeriode dataCell] setFormatter:soldeFormateur];
	[[colonneStatistiquesSoldeMensuel dataCell] setFormatter:soldeFormateur];
}

- (void)rearrangeMouvements
{
	[mouvementsControler rearrangeObjects];
}

- (IBAction)debutAjoutMouvement:(id)sender
{
	tempMouvement = [[CBMouvement alloc] init];
	[tempMouvement setOperation:(CBTypeMouvement)[sender tag]];
	[tempMouvement setNumeroCheque:[managedCompte numeroProchainCheque]];
	[tempMouvement setNumeroChequeEmploiService:[managedCompte numeroProchainChequeEmploiService]];

	[tempMouvementControler setContent:tempMouvement];
	
	[libellesPredefinisControler setOperation:[tempMouvement operation]];
	NSSortDescriptor *libellesPredefinisDescriptor = [[NSSortDescriptor alloc] initWithKey:@"libelle" ascending:YES];
	[libellesPredefinisControler setSortDescriptors:[NSArray arrayWithObject:libellesPredefinisDescriptor]];
	[libellesPredefinisDescriptor release];
	[libellesPredefinisControler rearrangeObjects];

	NSSortDescriptor *categoriesMouvementDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titre" ascending:YES];
	[categoriesMouvementControler setSortDescriptors:[NSArray arrayWithObject:categoriesMouvementDescriptor]];
	[categoriesMouvementDescriptor release];
	[categoriesMouvementControler rearrangeObjects];

	[fenetreEditerMouvementSingle makeFirstResponder:[fenetreEditerMouvementSingle initialFirstResponder]];
	[NSApp beginSheet:fenetreEditerMouvementSingle modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)debutEditionMouvement:(id)sender
{
	if( (sender != tableMouvements) || ([tableMouvements clickedRow] != -1 && [tableMouvements clickedColumn] != 5) ) {
		NSArray *selection = [mouvementsControler selectedObjects];
		if ([selection count] == 1) {

			tempMouvement = [[CBMouvement alloc] init];
			[tempMouvement copieParametresDepuis:(CBMouvement *)[selection objectAtIndex:0]];
			if (![tempMouvement isCheque])
				[tempMouvement setNumeroCheque:[managedCompte numeroProchainCheque]];
			if (![tempMouvement isChequeEmploiService])
				[tempMouvement setNumeroChequeEmploiService:[managedCompte numeroProchainChequeEmploiService]];

			[tempMouvementControler setContent:tempMouvement];
			
			[libellesPredefinisControler setOperation:[tempMouvement operation]];
			NSSortDescriptor *libellesPredefinisDescriptor = [[NSSortDescriptor alloc] initWithKey:@"libelle" ascending:YES];
			[libellesPredefinisControler setSortDescriptors:[NSArray arrayWithObject:libellesPredefinisDescriptor]];
			[libellesPredefinisDescriptor release];
			[libellesPredefinisControler rearrangeObjects];

			NSSortDescriptor *categoriesMouvementDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titre" ascending:YES];
			[categoriesMouvementControler setSortDescriptors:[NSArray arrayWithObject:categoriesMouvementDescriptor]];
			[categoriesMouvementDescriptor release];
			[categoriesMouvementControler rearrangeObjects];

			[fenetreEditerMouvementSingle makeFirstResponder:[fenetreEditerMouvementSingle initialFirstResponder]];
			[NSApp beginSheet:fenetreEditerMouvementSingle modalForWindow:[self window] 
										modalDelegate:self 
										didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
										contextInfo:(void  *)[selection objectAtIndex:0]];
		}
		else if ([selection count] > 1) {
			tempMouvementMultiple = [[CBMouvementMultiple alloc] init];
			[tempMouvementMultiple copieParametresDepuisArray:selection];
			if (![tempMouvementMultiple isCheque])
				[tempMouvementMultiple setNumeroCheque:[managedCompte numeroProchainCheque]];
			if (![tempMouvementMultiple isChequeEmploiService])
				[tempMouvementMultiple setNumeroChequeEmploiService:[managedCompte numeroProchainChequeEmploiService]];

			[tempMouvementMultipleControler setContent:tempMouvementMultiple];
			
			[libellesPredefinisControler setOperation:[tempMouvementMultiple operation]];
			NSSortDescriptor *libellesPredefinisDescriptor = [[NSSortDescriptor alloc] initWithKey:@"libelle" ascending:YES];
			[libellesPredefinisControler setSortDescriptors:[NSArray arrayWithObject:libellesPredefinisDescriptor]];
			[libellesPredefinisDescriptor release];
			[libellesPredefinisControler rearrangeObjects];

			NSSortDescriptor *categoriesMouvementDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titre" ascending:YES];
			[categoriesMouvementControler setSortDescriptors:[NSArray arrayWithObject:categoriesMouvementDescriptor]];
			[categoriesMouvementDescriptor release];
			[categoriesMouvementControler rearrangeObjects];

			[fenetreEditerMouvementMultiple makeFirstResponder:[fenetreEditerMouvementMultiple initialFirstResponder]];
			[NSApp beginSheet:fenetreEditerMouvementMultiple modalForWindow:[self window] 
										modalDelegate:self 
										didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
										contextInfo:(void  *)selection];
		}
		else {
			NSBeep();
		}
	}
}

- (IBAction)updateMontantMouvementSingle:(id)sender
{
	if ([sender indexOfSelectedItem] != -1) {
		NSDecimalNumber *montantPredefini = [[[libellesPredefinisControler arrangedObjects] 
																objectAtIndex:[sender indexOfSelectedItem]] montant];
		if (montantPredefini != nil)
			[tempMouvement setMontant:montantPredefini];
	}
}

- (IBAction)updateMontantMouvementMultiple:(id)sender
{
	if ([sender indexOfSelectedItem] != -1) {
		NSDecimalNumber *montantPredefini = [[[libellesPredefinisControler arrangedObjects] 
																objectAtIndex:[sender indexOfSelectedItem]] montant];
		if (montantPredefini != nil)
			[tempMouvementMultiple setMontant:montantPredefini];
	}
}

- (IBAction)updateMontantMouvementPeriodique:(id)sender
{
	if ([sender indexOfSelectedItem] != -1) {
		NSDecimalNumber *montantPredefini = [[[libellesPredefinisControler arrangedObjects] 
																objectAtIndex:[sender indexOfSelectedItem]] montant];
		if (montantPredefini != nil) {
			NSArray *selection = [mouvementsPeriodiquesControler selectedObjects];
			if ([selection count] == 1) {
				[(CBMouvementPeriodique *)[selection objectAtIndex:0] setMontant:montantPredefini];
			}
		}
	}
}

- (IBAction)finEditionMouvementSingle:(id)sender
{
	if ([tempMouvementControler commitEditing]) {
		[fenetreEditerMouvementSingle orderOut:sender];
		[NSApp endSheet:fenetreEditerMouvementSingle returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)finEditionMouvementMultiple:(id)sender
{
	if ([tempMouvementMultipleControler commitEditing]) {
		[fenetreEditerMouvementMultiple orderOut:sender];
		[NSApp endSheet:fenetreEditerMouvementMultiple returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)togglePointageMouvement:(id)sender
{
	NSArray *selection = [mouvementsControler selectedObjects];
	if ([selection count] >= 1) {
		NSEnumerator *enumerator = [selection objectEnumerator];
		CBMouvement *anObject;
		while (anObject = [enumerator nextObject]) {
			[anObject togglePointage];
		}
		[[self managedCompte] calculeSoldes];
		[[self managedPortefeuille] calculeSoldes];
		[[self document] updateChangeCount:NSChangeDone];
	}
}

- (IBAction)suppressionMouvement:(id)sender
{
	NSArray *selection = [mouvementsControler selectedObjects];
	if ([selection count] >= 1) {
		
		NSAlert *myAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"CBTitreAlertSuppressionMouvement", nil) 
								defaultButton:NSLocalizedString(@"CBBoutonAnnuler", nil) 
								alternateButton:NSLocalizedString(@"CBBoutonOK", nil) 
								otherButton:nil 
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertSuppressionMouvement", nil)];

		[myAlert beginSheetModalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(suppressionMouvementAlertDidEnd:returnCode:contextInfo:)
								contextInfo:NULL];
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutEditionParametresCompte:(id)sender
{
	tempCompte = [[CBCompte alloc] init];
	[tempCompte copieParametresDepuis:managedCompte];
	[tempCompteControler setContent:tempCompte];
	[fenetreParametres makeFirstResponder:[fenetreParametres initialFirstResponder]];
	[NSApp beginSheet:fenetreParametres modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)finEditionParametresCompte:(id)sender
{
	if ([tempCompteControler commitEditing]) {
		[fenetreParametres orderOut:sender];
		[NSApp endSheet:fenetreParametres returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutEditionMouvementsPeriodiques:(id)sender
{
	NSSortDescriptor *mouvementsPeriodiquesDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titre" ascending:YES];
	[mouvementsPeriodiquesControler setSortDescriptors:[NSArray arrayWithObject:mouvementsPeriodiquesDescriptor]];
	[mouvementsPeriodiquesDescriptor release];
	[mouvementsPeriodiquesControler rearrangeObjects];

	if ([[mouvementsPeriodiquesControler arrangedObjects] count] > 0)
		[mouvementsPeriodiquesControler setSelectionIndex:0];
	
	NSArray *selection = [mouvementsPeriodiquesControler selectedObjects];
	if ([selection count] == 1) {
		[libellesPredefinisControler setOperation:[(CBMouvementPeriodique *)[selection objectAtIndex:0] operation]];
	}
	else {
		[libellesPredefinisControler setOperation:CBTypeMouvementPrelevement];
	}
	NSSortDescriptor *libellesPredefinisDescriptor = [[NSSortDescriptor alloc] initWithKey:@"libelle" ascending:YES];
	[libellesPredefinisControler setSortDescriptors:[NSArray arrayWithObject:libellesPredefinisDescriptor]];
	[libellesPredefinisDescriptor release];
	[libellesPredefinisControler rearrangeObjects];

	NSSortDescriptor *categoriesMouvementDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titre" ascending:YES];
	[categoriesMouvementControler setSortDescriptors:[NSArray arrayWithObject:categoriesMouvementDescriptor]];
	[categoriesMouvementDescriptor release];
	[categoriesMouvementControler rearrangeObjects];

	[fenetreEditerMouvementsPeriodiques makeFirstResponder:[fenetreEditerMouvementsPeriodiques initialFirstResponder]];
    [tableMouvementsPeriodiques cbRepairLayoutDeferred];
	[NSApp beginSheet:fenetreEditerMouvementsPeriodiques modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)ajoutMouvementsPeriodiques:(id)sender
{
	CBMouvementPeriodique *tempMouvementPeriodique = [[CBMouvementPeriodique alloc] init];
	[mouvementsPeriodiquesControler addObject:tempMouvementPeriodique];
	[tempMouvementPeriodique release];
	[[self document] updateChangeCount:NSChangeDone];
}

- (IBAction)suppressionMouvementsPeriodiques:(id)sender
{
	NSArray *selection = [mouvementsPeriodiquesControler selectedObjects];
	if ([selection count] == 1) {
		
		NSAlert *myAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"CBTitreAlertSuppressionMouvementPeriodique", nil) 
								defaultButton:NSLocalizedString(@"CBBoutonAnnuler", nil) 
								alternateButton:NSLocalizedString(@"CBBoutonOK", nil) 
								otherButton:nil 
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertSuppressionMouvementPeriodique", nil), 
															[(CBMouvementPeriodique *)[selection objectAtIndex:0] titre]];

		[myAlert beginSheetModalForWindow:fenetreEditerMouvementsPeriodiques 
								modalDelegate:self 
								didEndSelector:@selector(suppressionMouvementsPeriodiquesAlertDidEnd:returnCode:contextInfo:)
								contextInfo:NULL];
	}
	else {
		NSBeep();
	}
}

- (IBAction)finEditionMouvementsPeriodiques:(id)sender
{
	if ([mouvementsPeriodiquesControler commitEditing]) {
		[[self document] updateChangeCount:NSChangeDone];
		[fenetreEditerMouvementsPeriodiques orderOut:sender];
		[NSApp endSheet:fenetreEditerMouvementsPeriodiques returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutEditionLibellesPredefinis:(id)sender
{
	[libellesPredefinisControler setOperation:(CBTypeMouvement)[sender tag]];
	[operationMenu selectItemWithTag:[sender tag]];
	NSSortDescriptor *libellesPredefinisDescriptor = [[NSSortDescriptor alloc] initWithKey:@"libelle" ascending:YES];
	[libellesPredefinisControler setSortDescriptors:[NSArray arrayWithObject:libellesPredefinisDescriptor]];
	[libellesPredefinisDescriptor release];
	[libellesPredefinisControler rearrangeObjects];

	if ([[libellesPredefinisControler arrangedObjects] count] > 0)
		[libellesPredefinisControler setSelectionIndex:0];
	
	[fenetreLibellesPredefinis makeFirstResponder:[fenetreLibellesPredefinis initialFirstResponder]];
    [tableLibellesPredefinis cbRepairLayoutDeferred];
	[NSApp beginSheet:fenetreLibellesPredefinis modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)ajoutLibellesPredefinis:(id)sender
{
	CBLibellePredefini *tempLibellePredefini = [[CBLibellePredefini alloc] init];
	[tempLibellePredefini setOperation:[libellesPredefinisControler operation]];
	[libellesPredefinisControler addObject:tempLibellePredefini];
	[tempLibellePredefini release];
	[[self document] updateChangeCount:NSChangeDone];
}

- (IBAction)suppressionLibellesPredefinis:(id)sender
{
	NSArray *selection = [libellesPredefinisControler selectedObjects];
	if ([selection count] == 1) {
		
		NSAlert *myAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"CBTitreAlertSuppressionLibellePredefini", nil) 
								defaultButton:NSLocalizedString(@"CBBoutonAnnuler", nil) 
								alternateButton:NSLocalizedString(@"CBBoutonOK", nil) 
								otherButton:nil 
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertSuppressionLibellePredefini", nil), 
															[(CBLibellePredefini *)[selection objectAtIndex:0] libelle]];

		[myAlert beginSheetModalForWindow:fenetreLibellesPredefinis 
								modalDelegate:self 
								didEndSelector:@selector(suppressionLibellePredefiniAlertDidEnd:returnCode:contextInfo:)
								contextInfo:NULL];
	}
	else {
		NSBeep();
	}
}

- (IBAction)finEditionLibellesPredefinis:(id)sender
{
	if ([libellesPredefinisControler commitEditing]) {
		[fenetreLibellesPredefinis orderOut:sender];
		[NSApp endSheet:fenetreLibellesPredefinis returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutStatistiques:(id)sender
{
	tempStatistiques = [[CBStatistiques alloc] init];
	[self calculeStatistiques:self];

	[tempStatistiquesControler setContent:tempStatistiques];
	
	NSSortDescriptor *statistiquesCategoriesDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categorie.titre" ascending:YES];
	[tempStatistiquesCategoriesControler setSortDescriptors:[NSArray arrayWithObject:statistiquesCategoriesDescriptor]];
	[statistiquesCategoriesDescriptor release];
	[tempStatistiquesCategoriesControler rearrangeObjects];

	if ([[tempStatistiquesCategoriesControler arrangedObjects] count] > 0)
		[tempStatistiquesCategoriesControler setSelectionIndex:0];

	[fenetreStatistiques makeFirstResponder:[fenetreStatistiques initialFirstResponder]];
    [tableTempStatistiquesCategories cbRepairLayoutDeferred];
	[NSApp beginSheet:fenetreStatistiques modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)calculeStatistiques:(id)sender
{
	NSDecimal nombreMoisPeriodeDecimal;
    NSDecimal soldeDebiteurPeriodeDecimal;
    NSDecimal soldeDebiteurMensuelDecimal;
    NSDecimal soldeCrediteurPeriodeDecimal;
    NSDecimal soldeCrediteurMensuelDecimal;
	BOOL afficheMoyenne;

	NSDecimal montant;
	NSDecimalNumber *montantAvecSigne;
	
	[[tempStatistiques statistiquesCategories] removeAllObjects];
	
	double nombreMoisPeriode = (CBDaysSinceReferenceDate(dateFinStatistiques) - CBDaysSinceReferenceDate(dateDebutStatistiques) + 1) * 12 / 365.25;
	nombreMoisPeriodeDecimal = [[NSNumber numberWithDouble:nombreMoisPeriode] decimalValue];
	
	double intervalleMinMoyenne = [[[NSUserDefaults standardUserDefaults] objectForKey:CBIntervalleMinMoyenneDefaultKey] doubleValue];
	if (nombreMoisPeriode >= intervalleMinMoyenne) {
		afficheMoyenne = YES;
	}
	else {
		afficheMoyenne = NO;
	}
	
	soldeDebiteurPeriodeDecimal = [[NSDecimalNumber zero] decimalValue];
	soldeCrediteurPeriodeDecimal = [[NSDecimalNumber zero] decimalValue];
	
	NSEnumerator *enumerator = [[managedCompte mouvements] objectEnumerator];
	CBMouvement *anObject;
	while (anObject = (CBMouvement *)[enumerator nextObject]) {
		
		if (CBDaysSinceReferenceDate([anObject date]) >= CBDaysSinceReferenceDate(dateDebutStatistiques) 
		 && CBDaysSinceReferenceDate([anObject date]) <= CBDaysSinceReferenceDate(dateFinStatistiques)) {

			montant = [[anObject montant] decimalValue];
			
			if (CBSignePourTypeMouvement([anObject operation]) == CBSigneMouvementDebit) {
				NSDecimalAdd(&soldeDebiteurPeriodeDecimal, &soldeDebiteurPeriodeDecimal, &montant, NSRoundPlain);
				montantAvecSigne = [[NSDecimalNumber zero] decimalNumberBySubtracting:[anObject montant]];
			}
			else if (CBSignePourTypeMouvement([anObject operation]) == CBSigneMouvementCredit) {
				NSDecimalAdd(&soldeCrediteurPeriodeDecimal, &soldeCrediteurPeriodeDecimal, &montant, NSRoundPlain);
				montantAvecSigne = [anObject montant];
			}
			else {
				montantAvecSigne = [NSDecimalNumber zero];
			}
			
			if ([anObject categorie] != nil) {

				if (afficheMoyenne) {
					[tempStatistiques ajouteMontant:montantAvecSigne pourCategorie:[anObject categorie] 
										nombreMoisPeriode:[NSDecimalNumber decimalNumberWithDecimal:nombreMoisPeriodeDecimal]];
				}
				else {
					[tempStatistiques ajouteMontant:montantAvecSigne pourCategorie:[anObject categorie] 
										nombreMoisPeriode:nil];
				}
			}
		}
	}
	
	[tempStatistiques setSoldeDebiteurPeriode:[NSDecimalNumber decimalNumberWithDecimal:soldeDebiteurPeriodeDecimal]];
	NSDecimalDivide(&soldeDebiteurMensuelDecimal, &soldeDebiteurPeriodeDecimal, &nombreMoisPeriodeDecimal, NSRoundPlain);
	if (afficheMoyenne) {
		[tempStatistiques setSoldeDebiteurMensuel:[NSDecimalNumber decimalNumberWithDecimal:soldeDebiteurMensuelDecimal]];
	}
	else {
		[tempStatistiques setSoldeDebiteurMensuel:nil];
	}

	[tempStatistiques setSoldeCrediteurPeriode:[NSDecimalNumber decimalNumberWithDecimal:soldeCrediteurPeriodeDecimal]];
	NSDecimalDivide(&soldeCrediteurMensuelDecimal, &soldeCrediteurPeriodeDecimal, &nombreMoisPeriodeDecimal, NSRoundPlain);
	if (afficheMoyenne) {
		[tempStatistiques setSoldeCrediteurMensuel:[NSDecimalNumber decimalNumberWithDecimal:soldeCrediteurMensuelDecimal]];
	}
	else {
		[tempStatistiques setSoldeCrediteurMensuel:nil];
	}

	[tempStatistiquesCategoriesControler rearrangeObjects];
}

- (IBAction)finStatistiques:(id)sender
{
	[fenetreStatistiques orderOut:sender];
	[NSApp endSheet:fenetreStatistiques returnCode:0];
	[tempStatistiquesControler setContent:nil];
	[tempStatistiques release];
}

- (IBAction)sauveFichierTXT:(id)sender
{
	NSSavePanel *mySavePanel = [NSSavePanel savePanel];
	[mySavePanel setExtensionHidden:NO];
	[mySavePanel setCanSelectHiddenExtension:NO];
    [mySavePanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];
    [mySavePanel setNameFieldStringValue:[[[self document] displayName] stringByDeletingPathExtension]];
	
    [mySavePanel beginSheetModalForWindow:[self window] 
                        completionHandler:^(NSInteger returnCode) {
                            
                            if (returnCode == NSOKButton) {
                                
                                NSMutableString *outputString = [NSMutableString stringWithCapacity:700];
                                CBNombreFormatter *soldeFormateur = [[self document] soldeFormateur];
                                NSDateFormatter *dateFormateur = [[self document] dateFormateur];
                                
                                [outputString appendFormat:NSLocalizedString(@"CBEnteteTXTCompte", nil), 
                                 [managedCompte numeroCompte], 
                                 [managedCompte banque], 
                                 [soldeFormateur stringForObjectValue:[managedCompte soldeReel]],
                                 [soldeFormateur stringForObjectValue:[managedCompte soldeBanque]],
                                 [soldeFormateur stringForObjectValue:[managedCompte soldeCBEnCours]]
                                 ];
                                
                                NSEnumerator *enumerator = [[mouvementsControler arrangedObjects] objectEnumerator];
                                CBMouvement *anObject;
                                while (anObject = (CBMouvement *)[enumerator nextObject]) {
                                    
                                    [outputString appendFormat:NSLocalizedString(@"CBLigneTXTCompte", nil), 
                                     [dateFormateur stringForObjectValue:[anObject date]],
                                     [anObject libelleOperation], 
                                     [anObject libelle], 
                                     [[anObject categorie] titre], 
                                     [soldeFormateur stringForObjectValue:[anObject debit]],
                                     [anObject pointage]?@"*":@"",
                                     [soldeFormateur stringForObjectValue:[anObject credit]],
                                     [soldeFormateur stringForObjectValue:[anObject avoir]]
                                     ];
                                    
                                }
                                
                                [outputString replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [outputString length])];
                                
                                NSError *outError = nil;
                                if (![outputString writeToURL:[mySavePanel URL] atomically:YES encoding:NSUTF8StringEncoding error:&outError] && outError != nil) {
                                    
                                    NSMutableDictionary *raisedErrorDict = [[[outError userInfo] mutableCopy] autorelease];
                                    NSString *titreErreur = [NSString stringWithString:NSLocalizedString(@"CBFichierTXTMessageErreur", nil)];
                                    [raisedErrorDict setObject:titreErreur forKey:NSLocalizedDescriptionKey];
                                    NSError *raisedError = [NSError errorWithDomain:[outError domain] code:[outError code] userInfo:raisedErrorDict];
                                    [mySavePanel orderOut:self];
                                    [self presentError:raisedError modalForWindow:[self window] 
                                              delegate:nil 
                                    didPresentSelector:NULL 
                                           contextInfo:NULL];
                                }
                                
                            }
                        }];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if (sheet == fenetreEditerMouvementSingle) {
		if (returnCode == 1) {

			if (![tempMouvement isCheque])
				[tempMouvement setNumeroCheque:[NSNumber numberWithLongLong:0]];
			if (![tempMouvement isChequeEmploiService])
				[tempMouvement setNumeroChequeEmploiService:[NSNumber numberWithLongLong:0]];

			if ([tempMouvement isCheque] && [[tempMouvement numeroCheque] isEqualToNumber:[managedCompte numeroProchainCheque]])
				[managedCompte augmenteNumeroProchainCheque];
			if ([tempMouvement isChequeEmploiService] && [[tempMouvement numeroChequeEmploiService] isEqualToNumber:[managedCompte numeroProchainChequeEmploiService]])
				[managedCompte augmenteNumeroProchainChequeEmploiService];

			if (contextInfo == NULL) {
				[mouvementsControler addObject:tempMouvement];
			}
			else {
				[(CBMouvement *)contextInfo copieParametresDepuis:tempMouvement];
			}
			[[self managedCompte] calculeSoldes];
			[[self managedPortefeuille] calculeSoldes];
			[[self document] updateChangeCount:NSChangeDone];
			[mouvementsControler rearrangeObjects];
		}
		[tempMouvementControler setContent:nil];
		[tempMouvement release];
	}

	else if (sheet == fenetreEditerMouvementMultiple) {
		if (returnCode == 1) {

			if (![tempMouvementMultiple isCheque])
				[tempMouvementMultiple setNumeroCheque:[NSNumber numberWithLongLong:0]];
			if (![tempMouvementMultiple isChequeEmploiService])
				[tempMouvementMultiple setNumeroChequeEmploiService:[NSNumber numberWithLongLong:0]];

			if ([tempMouvementMultiple isCheque] && [[tempMouvementMultiple numeroCheque] isEqualToNumber:[managedCompte numeroProchainCheque]])
				[managedCompte augmenteNumeroProchainCheque];
			if ([tempMouvementMultiple isChequeEmploiService] && [[tempMouvementMultiple numeroChequeEmploiService] isEqualToNumber:[managedCompte numeroProchainChequeEmploiService]])
				[managedCompte augmenteNumeroProchainChequeEmploiService];

			NSEnumerator *enumerator = [(NSArray *)contextInfo objectEnumerator];
			CBMouvement *anObject;
			while (anObject = [enumerator nextObject]) {
				[anObject copieParametresDepuisMultiple:tempMouvementMultiple];
			}

			[[self managedCompte] calculeSoldes];
			[[self managedPortefeuille] calculeSoldes];
			[[self document] updateChangeCount:NSChangeDone];
			[mouvementsControler rearrangeObjects];
		}
		[tempMouvementMultipleControler setContent:nil];
		[tempMouvementMultiple release];
	}
	
	else if (sheet == fenetreParametres) {
		if (returnCode == 1) {
			[managedCompte copieParametresDepuis:tempCompte];
			[[self managedCompte] calculeSoldes];
			[[self managedPortefeuille] calculeSoldes];
			[[self document] updateChangeCount:NSChangeDone];
		}
		[tempCompteControler setContent:nil];
		[tempCompte release];
	}
}

- (void)suppressionLibellePredefiniAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if (returnCode == NSAlertAlternateReturn) {
		[libellesPredefinisControler remove:self];
		[[self document] updateChangeCount:NSChangeDone];
	}
}

- (void)suppressionMouvementAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if (returnCode == NSAlertAlternateReturn) {
		[mouvementsControler remove:self];
		[[self managedCompte] calculeSoldes];
		[[self managedPortefeuille] calculeSoldes];
		[[self document] updateChangeCount:NSChangeDone];
		[mouvementsControler rearrangeObjects];
	}
}

- (void)suppressionMouvementsPeriodiquesAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if (returnCode == NSAlertAlternateReturn) {
		[mouvementsPeriodiquesControler remove:self];
		[[self document] updateChangeCount:NSChangeDone];
	}
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if ([menuItem action] == @selector(debutEditionMouvement:) && ![mouvementsControler canRemove])  {
		return NO;
	}
	if ([menuItem action] == @selector(togglePointageMouvement:) && ![mouvementsControler canRemove])  {
		return NO;
	}
	if ([menuItem action] == @selector(suppressionMouvement:) && ![mouvementsControler canRemove])  {
		return NO;
	}
	return YES;
}

- (void)textDidChange:(NSNotification *)aNotification
{
	[[self document] updateChangeCount:NSChangeDone];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[[aNotification object] scrollRowToVisible:[[aNotification object] selectedRow]];

	if ([aNotification object] == tableMouvementsPeriodiques) {
		NSArray *selection = [mouvementsPeriodiquesControler selectedObjects];
		if ([selection count] == 1) {
			[libellesPredefinisControler setOperation:[(CBMouvementPeriodique *)[selection objectAtIndex:0] operation]];
		}
		else {
			[libellesPredefinisControler setOperation:CBTypeMouvementPrelevement];
		}
		[libellesPredefinisControler rearrangeObjects];
	}
}

- (IBAction)pointageDidChange:(id)sender
{
	[[self managedCompte] calculeSoldes];
	[[self managedPortefeuille] calculeSoldes];
	[[self document] updateChangeCount:NSChangeDone];
}

- (void)keyDown:(NSEvent *)theEvent
{
	NSCharacterSet *carSetEnter = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C%C", (unichar)0x0003, (unichar)0x000D]];
	NSCharacterSet *carSetDel = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C", (unichar)0x007F]];
	
    if( [[theEvent characters] rangeOfCharacterFromSet:carSetEnter].location != NSNotFound && [mouvementsControler canRemove] ) {
		[self debutEditionMouvement:self];
	}
    else if( [[theEvent characters] rangeOfCharacterFromSet:carSetDel].location != NSNotFound && [mouvementsControler canRemove] ) {
		[self suppressionMouvement:self];
	}
	else {
		[super keyDown:theEvent];
	}
}

- (void)printDocument:(id)sender
{
	[NSApp runModalForWindow:fenetreDateImpression];
}

- (IBAction)lancerImpression:(id)sender
{
	[fenetreDateImpression orderOut:sender];
	[NSApp stopModal];
	
	NSMutableArray *mouvementsArray = [NSMutableArray arrayWithCapacity:700];
	NSEnumerator *enumerator = [[mouvementsControler arrangedObjects] objectEnumerator];
	CBMouvement *anObject;
	while (anObject = (CBMouvement *)[enumerator nextObject]) {
		
		if ( impressionTousMouvements || 
			(CBDaysSinceReferenceDate([anObject date]) >= CBDaysSinceReferenceDate(dateDebutImpression) 
		  && CBDaysSinceReferenceDate([anObject date]) <= CBDaysSinceReferenceDate(dateFinImpression)) ) {
			
			[mouvementsArray addObject:anObject];
			
		 }
	}
		
	NSPrintInfo *pInfo = [[self document] printInfo];
	
	CBVueImpressionCompte *myVue = [[CBVueImpressionCompte alloc] initWithCompte:managedCompte 
																				mouvements:mouvementsArray 
																				printInfo:pInfo 
																				nombreFormatter:[[self document] soldeFormateur] 
																				dateFormatter:[[self document] dateFormateur]];
	
	if (myVue == nil) {
	
		NSString *titre = [NSString stringWithString:NSLocalizedString(@"CBLargeurPapierTitreErreur", nil)];
		NSString *message = [NSString stringWithString:NSLocalizedString(@"CBLargeurPapierMessageErreur", nil)];
		NSDictionary *userInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:titre, NSLocalizedDescriptionKey, message, NSLocalizedRecoverySuggestionErrorKey, nil];
		NSError *raisedError = [NSError errorWithDomain:CBAppErrorDomain code:CBLargeurPapierErreur userInfo:userInfoDict];
		[self presentError:raisedError modalForWindow:[self window] 
											delegate:nil 
											didPresentSelector:NULL 
											contextInfo:NULL];
		
		return;
	}


	NSPrintOperation *op = [NSPrintOperation printOperationWithView:myVue printInfo:pInfo];
	[op runOperationModalForWindow:[self window] 
								delegate:nil 
								didRunSelector:NULL 
								contextInfo:NULL];
	
	[myVue release];
}

@end
