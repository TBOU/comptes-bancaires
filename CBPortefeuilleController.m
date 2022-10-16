//
//  CBPortefeuilleController.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import "CBPortefeuilleController.h"
#import "CBDocument.h"
#import "CBCompteController.h"
#import "CBNombreFormatter.h"
#import "CBChaineFormatter.h"
#import "CBMouvementPeriodique.h"
#import "CBMouvement.h"
#import "CBEcritureAutomatique.h"
#import "CBVueImpressionPortefeuille.h"
#import "CBGlobal.h"


@implementation CBPortefeuilleController

- (id)initWithPortefeuille:(CBPortefeuille *)aPortefeuille
{
	if (self = [super initWithWindowNibName:@"Portefeuille"]) {
		managedPortefeuille = [aPortefeuille retain];
		ecrituresAutomatiques = [[NSMutableArray alloc] initWithCapacity:7];
		dateCloture = [[NSDate date] retain];
		[self setShouldCloseDocument:YES];
		[self setShouldCascadeWindows:NO];
		[self setWindowFrameAutosaveName:@"PortefeuilleWindow"];
	}
	return self;
}

- (void)windowDidLoad
{
	[self appliqueFormateurs];

	[tableComptes setDoubleAction:@selector(editerCompte:)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											selector:@selector(textDidChange:) 
											name:@"NSControlTextDidChangeNotification" 
											object:tableCategoriesMouvement];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											selector:@selector(tableViewSelectionDidChange:) 
											name:@"NSTableViewSelectionDidChangeNotification" 
											object:tableComptes];

	[[NSNotificationCenter defaultCenter] addObserver:self 
											selector:@selector(tableViewSelectionDidChange:) 
											name:@"NSTableViewSelectionDidChangeNotification" 
											object:tableCategoriesMouvement];

	NSSortDescriptor *comptesDescriptor = [[NSSortDescriptor alloc] initWithKey:@"banque" ascending:YES];
	[comptesControler setSortDescriptors:[NSArray arrayWithObject:comptesDescriptor]];
	[comptesDescriptor release];
	
	if ([[comptesControler arrangedObjects] count] > 0)
		[comptesControler setSelectionIndex:0];
	
	[boutonVirement setEnabled:[[comptesControler  arrangedObjects] count] > 1];
	
	[self debutSelectionEcrituresAutomatiques:self];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[managedPortefeuille release];
	[ecrituresAutomatiques release];
	[dateCloture release];
	[super dealloc];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	return [NSString stringWithFormat:NSLocalizedString(@"CBTitreFenetrePortefeuille", nil), displayName];
}

- (CBPortefeuille *)managedPortefeuille
{
	return managedPortefeuille;
}

- (void)setManagedPortefeuille:(CBPortefeuille *)aPortefeuille
{
	[managedPortefeuille autorelease];
	managedPortefeuille = [aPortefeuille retain];
}

- (NSMutableArray *)ecrituresAutomatiques
{
	return ecrituresAutomatiques;
}

- (NSDate *)dateCloture
{
	return [[dateCloture copy] autorelease];
}

- (void)setDateCloture:(NSDate *)aDateCloture
{
	[dateCloture autorelease];
	dateCloture = [aDateCloture copy];
}

- (BOOL)sauvegardeCloture
{
	return sauvegardeCloture;
}

- (void)setSauvegardeCloture:(BOOL)aSauvegardeCloture
{
	sauvegardeCloture = aSauvegardeCloture;
}

- (void)appliqueFormateurs
{
	NSDateFormatter *dateFormateur = [[self document] dateFormateur];
	CBNombreFormatter *soldeFormateur = [[self document] soldeFormateur];
	CBNombreFormatter *montantFormateur = [[self document] montantFormateur];
	CBNombreFormatter *numeroFormateur = [[self document] numeroFormateur];
	CBChaineFormatter *texteFormateur = [[self document] texteFormateur];
	CBChaineFormatter *deviseFormateur = [[self document] deviseFormateur];
	
	[[champNom cell] setFormatter:texteFormateur];
	[[champPrenom cell] setFormatter:texteFormateur];
	[[champSymboleMonetaire cell] setFormatter:deviseFormateur];
	[[champSoldeTotalComptes cell] setFormatter:soldeFormateur];
	
	[[champBanque cell] setFormatter:texteFormateur];
	[[champNumeroCompte cell] setFormatter:texteFormateur];
	[[champSoldeInitial cell] setFormatter:soldeFormateur];
	[[champNumeroProchainCheque cell] setFormatter:numeroFormateur];
	[[champNumeroProchainChequeEmploiService cell] setFormatter:numeroFormateur];

	[[champLibelleVirement cell] setFormatter:texteFormateur];
	[[champMontantVirement cell] setFormatter:montantFormateur];

	[[colonneSoldeReel dataCell] setFormatter:soldeFormateur];
	[[colonneSoldeBanque dataCell] setFormatter:soldeFormateur];
	
	[[colonneTitreCategorie dataCell] setFormatter:texteFormateur];
	[[colonneNombreLiens dataCell] setFormatter:numeroFormateur];
	
	[[colonneDateEcritureAutomatique dataCell] setFormatter:dateFormateur];
	[[colonneMontantEcritureAutomatique dataCell] setFormatter:montantFormateur];
}

- (void)calculeEcrituresAutomatiques
{
	NSDate *dateJour = [NSDate date];
	[ecrituresAutomatiques removeAllObjects];
	
	NSEnumerator *comptesEnumerateur;
	CBCompte *myCompte;
	comptesEnumerateur = [[managedPortefeuille comptes] objectEnumerator];
	while (myCompte = (CBCompte *)[comptesEnumerateur nextObject]) {
		
		NSEnumerator *mouvementsPeriodiquesEnumerateur;
		CBMouvementPeriodique *myMouvementPeriodique;
		mouvementsPeriodiquesEnumerateur = [[myCompte mouvementsPeriodiques] objectEnumerator];
		while (myMouvementPeriodique = (CBMouvementPeriodique *)[mouvementsPeriodiquesEnumerateur nextObject]) {
			
			[myMouvementPeriodique calculeDatesEcrituresEnSuspens:dateJour];
			
			NSEnumerator *datesEnumerateur;
			NSDate *myDate;
			datesEnumerateur = [[myMouvementPeriodique datesEcrituresEnSuspens] objectEnumerator];
			while (myDate = (NSDate *)[datesEnumerateur nextObject]) {
				
				CBEcritureAutomatique *myEcritureAutomatique = [[CBEcritureAutomatique alloc] initWithCompte:myCompte 
																								mouvementPeriodique:myMouvementPeriodique 
																								dateEcriture:myDate];
				[ecrituresAutomatiques addObject:myEcritureAutomatique];
				[myEcritureAutomatique release];
			}
			
		}
		
	}
}

- (IBAction)debutSelectionEcrituresAutomatiques:(id)sender
{
	// On vérifie que les fenêtre de compte sont toutes fermées
	if ([[[self document] windowControllers] count] > 1) {
		
		NSAlert *myAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"CBTitreAlertFermerComptesEcritureAutomatique", nil) 
								defaultButton:NSLocalizedString(@"CBBoutonOK", nil) 
								alternateButton:nil 
								otherButton:nil 
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertFermerComptesEcritureAutomatique", nil)];
		[myAlert runModal];
		return;
	}
	
	
	// On calcule puis affiche les écritures automatiques
	[self calculeEcrituresAutomatiques];
	
	if ([ecrituresAutomatiques count] > 0) {
		
		NSSortDescriptor *desc1 = [[NSSortDescriptor alloc] initWithKey:@"compte.banque" ascending:YES];
		NSSortDescriptor *desc2 = [[NSSortDescriptor alloc] initWithKey:@"compte.numeroCompte" ascending:YES];
		NSSortDescriptor *desc3 = [[NSSortDescriptor alloc] initWithKey:@"mouvement.date" ascending:YES];
		[ecrituresAutomatiquesControler setSortDescriptors:[NSArray arrayWithObjects:desc1, desc2, desc3, nil]];
		[desc1 release];
		[desc2 release];
		[desc3 release];
		
		if ([[ecrituresAutomatiquesControler arrangedObjects] count] > 0)
			[ecrituresAutomatiquesControler setSelectionIndex:0];
		
		[fenetreEcrituresAutomatiques makeFirstResponder:[fenetreEcrituresAutomatiques initialFirstResponder]];
		
		[NSApp runModalForWindow:fenetreEcrituresAutomatiques];
	}
	else if (sender != self) {
		
		NSAlert *myAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"CBTitreAlertAucuneEcritureAutomatique", nil) 
								defaultButton:NSLocalizedString(@"CBBoutonOK", nil) 
								alternateButton:nil 
								otherButton:nil 
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertAucuneEcritureAutomatique", nil)];
		[myAlert runModal];
	}
}

- (IBAction)actionSelectionEcrituresAutomatiques:(id)sender
{
	if ([ecrituresAutomatiquesControler commitEditing]) {
		
		NSEnumerator *enumerator;
		
		if ([sender tag] == CBGenereEcritureAutomatique || [sender tag] == CBDiffereEcritureAutomatique) {
			enumerator = [[ecrituresAutomatiquesControler selectedObjects] objectEnumerator];
		}
		else {
			enumerator = [[ecrituresAutomatiquesControler arrangedObjects] objectEnumerator];
		}

		CBEcritureAutomatique *anObject;
		while (anObject = (CBEcritureAutomatique *)[enumerator nextObject]) {
			
			if ([sender tag] == CBGenereEcritureAutomatique || [sender tag] == CBGenereToutesEcrituresAutomatiques) {
				[anObject genereEcriture];
				[managedPortefeuille calculeSoldes];
				[[self document] updateChangeCount:NSChangeDone];
			}
			[ecrituresAutomatiquesControler removeObject:anObject];
		}
		
		[ecrituresAutomatiquesControler rearrangeObjects];
		
		if ([[ecrituresAutomatiquesControler arrangedObjects] count] == 0) {
		
			[fenetreEcrituresAutomatiques orderOut:sender];
			[NSApp stopModal];
		}
		
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutAjoutCompte:(id)sender
{
	tempCompte = [[CBCompte alloc] init];
	[tempCompteControler setContent:tempCompte];
	[fenetreAjouterCompte makeFirstResponder:[fenetreAjouterCompte initialFirstResponder]];
	[NSApp beginSheet:fenetreAjouterCompte modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)finAjoutCompte:(id)sender
{
	if ([tempCompteControler commitEditing]) {
		[fenetreAjouterCompte orderOut:sender];
		[NSApp endSheet:fenetreAjouterCompte returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)editerCompte:(id)sender
{
	if( (sender != tableComptes) || ([tableComptes clickedRow] != -1) ) {
		NSArray *selection = [comptesControler selectedObjects];
		if ([selection count] == 1) {
			[[self document] ouvreFenetreCompte:(CBCompte *)[selection objectAtIndex:0]];
		}
		else {
			NSBeep();
		}
	}
}

- (IBAction)suppressionCompte:(id)sender
{
	NSArray *selection = [comptesControler selectedObjects];
	if ([selection count] == 1) {
		
		NSAlert *myAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"CBTitreAlertSuppressionCompte", nil) 
								defaultButton:NSLocalizedString(@"CBBoutonAnnuler", nil) 
								alternateButton:NSLocalizedString(@"CBBoutonOK", nil) 
								otherButton:nil 
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertSuppressionCompte", nil), 
															[(CBCompte *)[selection objectAtIndex:0] numeroCompte], 
															[(CBCompte *)[selection objectAtIndex:0] banque]];

		[myAlert beginSheetModalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(suppressionCompteAlertDidEnd:returnCode:contextInfo:)
								contextInfo:(void  *)[selection objectAtIndex:0]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutVirement:(id)sender
{
	tempVirement = [[CBVirement alloc] init];
	[tempVirementControler setContent:tempVirement];
	
	[compteDebiteurControler setCompteExclu:nil];
	[compteDebiteurControler rearrangeObjects];
	
	[compteCrediteurControler setCompteExclu:nil];
	[compteCrediteurControler rearrangeObjects];

	[libellesPredefinisControler setOperation:CBTypeMouvementVirementDebiteur];
	NSSortDescriptor *libellesPredefinisDescriptor = [[NSSortDescriptor alloc] initWithKey:@"libelle" ascending:YES];
	[libellesPredefinisControler setSortDescriptors:[NSArray arrayWithObject:libellesPredefinisDescriptor]];
	[libellesPredefinisDescriptor release];

	NSSortDescriptor *categoriesMouvementDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titre" ascending:YES];
	[categoriesMouvementControler setSortDescriptors:[NSArray arrayWithObject:categoriesMouvementDescriptor]];
	[categoriesMouvementDescriptor release];

	[fenetreVirement makeFirstResponder:[fenetreVirement initialFirstResponder]];
	[NSApp beginSheet:fenetreVirement modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)updateMontantVirement:(id)sender
{
	if ([sender indexOfSelectedItem] != -1) {
		NSDecimalNumber *montantPredefini = [[[libellesPredefinisControler arrangedObjects] 
																objectAtIndex:[sender indexOfSelectedItem]] montant];
		if (montantPredefini != nil)
			[[tempVirement mouvement] setMontant:montantPredefini];
	}
}

- (IBAction)filtrePourCompteDebiteurVirement:(id)sender
{
	if ([sender indexOfSelectedItem] > 0) {
		[compteCrediteurControler setCompteExclu:[[compteDebiteurControler arrangedObjects] objectAtIndex:[sender indexOfSelectedItem]-1]];
	}
	else {
		[compteCrediteurControler setCompteExclu:nil];
	}
	[compteCrediteurControler rearrangeObjects];
}

- (IBAction)filtrePourCompteCrediteurVirement:(id)sender
{
	if ([sender indexOfSelectedItem] > 0) {
		[compteDebiteurControler setCompteExclu:[[compteCrediteurControler arrangedObjects] objectAtIndex:[sender indexOfSelectedItem]-1]];
	}
	else {
		[compteDebiteurControler setCompteExclu:nil];
	}
	[compteDebiteurControler rearrangeObjects];
}

- (IBAction)finVirement:(id)sender
{
	if ([tempVirementControler commitEditing]) {
		[fenetreVirement orderOut:sender];
		[NSApp endSheet:fenetreVirement returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutEditionParametres:(id)sender
{
	tempPortefeuille = [[CBPortefeuille alloc] init];
	[tempPortefeuille copieParametresDepuis:managedPortefeuille];
	[tempPortefeuilleControler setContent:tempPortefeuille];
	[fenetreParametres makeFirstResponder:[fenetreParametres initialFirstResponder]];
	[NSApp beginSheet:fenetreParametres modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)finEditionParametres:(id)sender
{
	if ([tempPortefeuilleControler commitEditing]) {
		[fenetreParametres orderOut:sender];
		[NSApp endSheet:fenetreParametres returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutEditionCategoriesMouvement:(id)sender
{
	NSSortDescriptor *categoriesMouvementDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titre" ascending:YES];
	[categoriesMouvementControler setSortDescriptors:[NSArray arrayWithObject:categoriesMouvementDescriptor]];
	[categoriesMouvementDescriptor release];

	if ([[categoriesMouvementControler arrangedObjects] count] > 0)
		[categoriesMouvementControler setSelectionIndex:0];
	
	[fenetreCategoriesMouvement makeFirstResponder:[fenetreCategoriesMouvement initialFirstResponder]];

	[NSApp beginSheet:fenetreCategoriesMouvement modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)ajoutCategoriesMouvement:(id)sender
{
	[categoriesMouvementControler add:self];
	[[self document] updateChangeCount:NSChangeDone];
}

- (IBAction)suppressionCategoriesMouvement:(id)sender
{
	NSArray *selection = [categoriesMouvementControler selectedObjects];
	if ([selection count] == 1) {
		
		NSAlert *myAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"CBTitreAlertSuppressionCategorieMouvement", nil) 
								defaultButton:NSLocalizedString(@"CBBoutonAnnuler", nil) 
								alternateButton:NSLocalizedString(@"CBBoutonOK", nil) 
								otherButton:nil 
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertSuppressionCategorieMouvement", nil), 
															[(CBCategorieMouvement *)[selection objectAtIndex:0] titre], 
															[(CBCategorieMouvement *)[selection objectAtIndex:0] utilisationMouvements]];

		[myAlert beginSheetModalForWindow:fenetreCategoriesMouvement 
								modalDelegate:self 
								didEndSelector:@selector(suppressionCategorieMouvementAlertDidEnd:returnCode:contextInfo:)
								contextInfo:(void  *)[selection objectAtIndex:0]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)finEditionCategoriesMouvement:(id)sender
{
	if ([categoriesMouvementControler commitEditing]) {
		[fenetreCategoriesMouvement orderOut:sender];
		[NSApp endSheet:fenetreCategoriesMouvement returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutClotureExercice:(id)sender
{
	// On vérifie que les fenêtre de compte sont toutes fermées
	if ([[[self document] windowControllers] count] > 1) {
		
		NSAlert *myAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"CBTitreAlertFermerComptesClotureExercice", nil) 
								defaultButton:NSLocalizedString(@"CBBoutonOK", nil) 
								alternateButton:nil 
								otherButton:nil 
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertFermerComptesClotureExercice", nil)];
		[myAlert runModal];
		return;
	}
	
	
	// On initialise les variables et on affiche la fenêtre de dialogue
	NSDate *dateJour = [NSDate date];
	[self setDateCloture:CBFirstDayOfYear(dateJour)];
	[self setSauvegardeCloture:YES];
	
	[fenetreCloturerExercice makeFirstResponder:[fenetreCloturerExercice initialFirstResponder]];
	[NSApp beginSheet:fenetreCloturerExercice modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (IBAction)finClotureExercice:(id)sender
{
	[fenetreCloturerExercice orderOut:sender];
	[NSApp endSheet:fenetreCloturerExercice returnCode:[sender tag]];
}

- (IBAction)sauveFichierTXT:(id)sender
{
	NSSavePanel *mySavePanel = [NSSavePanel savePanel];
	[mySavePanel setExtensionHidden:NO];
	[mySavePanel setCanSelectHiddenExtension:NO];
	[mySavePanel setRequiredFileType:@"txt"];
	
	[mySavePanel beginSheetForDirectory:nil file:[[[self document] displayName] stringByDeletingPathExtension]
								modalForWindow:[self window] 
								modalDelegate:self 
								didEndSelector:@selector(savePanelDidEnd:returnCode:contextInfo:) 
								contextInfo:NULL];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if (sheet == fenetreAjouterCompte) {
		if (returnCode == 1) {
			[tempCompte calculeSoldes];
			[comptesControler addObject:tempCompte];
			[boutonVirement setEnabled:[[comptesControler  arrangedObjects] count] > 1];
			[[self managedPortefeuille] calculeSoldes];
			[[self document] updateChangeCount:NSChangeDone];
			[comptesControler rearrangeObjects];
		}
		[tempCompteControler setContent:nil];
		[tempCompte release];
	}
	
	else if (sheet == fenetreVirement) {
		if (returnCode == 1) {
			[tempVirement genereVirement];
			// On met à jour l'affichage de la liste des mouvements dans les windows controllers des comptes concernés par le virement
			NSEnumerator *enumerateur;
			id anObject;
			enumerateur = [[[self document] windowControllers] objectEnumerator];
			while (anObject = [enumerateur nextObject]) {
				if ( [anObject respondsToSelector:@selector(managedCompte)] 
											&& ( [anObject managedCompte] == [tempVirement compteDebiteur] 
															|| [anObject managedCompte] == [tempVirement compteCrediteur] ) )  {
					[anObject rearrangeMouvements];
				}
			}
			
			[[self managedPortefeuille] calculeSoldes];
			[[self document] updateChangeCount:NSChangeDone];
		}
		[tempVirementControler setContent:nil];
		[tempVirement release];
	}
	
	else if (sheet == fenetreParametres) {
		if (returnCode == 1) {
			[managedPortefeuille copieParametresDepuis:tempPortefeuille];
			[[self document] updateFormateurs];
			[[self document] updateChangeCount:NSChangeDone];
		}
		[tempPortefeuilleControler setContent:nil];
		[tempPortefeuille release];
	}
	
	else if (sheet == fenetreCloturerExercice && returnCode == 1) {

		if([self sauvegardeCloture]) {
			
			NSString *nomFichier;
			nomFichier = [NSString stringWithString:@"~"];
			nomFichier = [nomFichier stringByAppendingPathComponent:@"Desktop"];
			nomFichier = [nomFichier stringByAppendingPathComponent:[[[self document] displayName] stringByDeletingPathExtension]];
			nomFichier = [nomFichier stringByAppendingString:CBStringFromDate([self dateCloture], @"_dd_MM_yyyy")];
			nomFichier = [nomFichier stringByAppendingPathExtension:@"cba"];
			nomFichier = [nomFichier stringByExpandingTildeInPath];
			
			NSError *outError = nil;
			if (![[self document] writeToURL:[NSURL fileURLWithPath:nomFichier] ofType:CBTypeDocumentBinaire error:&outError] && outError != nil) {
				
				NSMutableDictionary *raisedErrorDict = [[[outError userInfo] mutableCopy] autorelease];
				NSString *titreErreur = [NSString stringWithString:NSLocalizedString(@"CBFichierSauvegardeMessageErreur", nil)];
				[raisedErrorDict setObject:titreErreur forKey:NSLocalizedDescriptionKey];
				NSError *raisedError = [NSError errorWithDomain:[outError domain] code:[outError code] userInfo:raisedErrorDict];
				[self presentError:raisedError modalForWindow:[self window] 
													delegate:nil 
													didPresentSelector:NULL 
													contextInfo:NULL];
				return;
			}
		}

		NSEnumerator *comptesEnumerateur;
		CBCompte *myCompte;
		comptesEnumerateur = [[managedPortefeuille comptes] objectEnumerator];
		while (myCompte = (CBCompte *)[comptesEnumerateur nextObject]) {
			
			[myCompte clotureExercicePourDate:[self dateCloture]];
			[myCompte calculeSoldes];
		}
		
		[[self managedPortefeuille] calculeSoldes];
		[[self document] updateChangeCount:NSChangeDone];
	}
}

- (void)suppressionCategorieMouvementAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if (returnCode == NSAlertAlternateReturn) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"CBCategorieMouvementWillDeallocNotification" 
												object:(CBCategorieMouvement *)contextInfo];
		[categoriesMouvementControler remove:self];
		[[self document] updateChangeCount:NSChangeDone];
	}
}

- (void)suppressionCompteAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if (returnCode == NSAlertAlternateReturn) {

		// On ferme la fenêtre du compte si elle est encore ouverte
		NSEnumerator *enumerateur;
		id anObject;
		enumerateur = [[[self document] windowControllers] objectEnumerator];
		while (anObject = [enumerateur nextObject]) {
			if ( [anObject respondsToSelector:@selector(managedCompte)] && [anObject managedCompte] == (CBCompte *)contextInfo)  {
				[anObject close];
			}
		}

		[comptesControler remove:self];
		[boutonVirement setEnabled:[[comptesControler  arrangedObjects] count] > 1];
		[[self managedPortefeuille] calculeSoldes];
		[[self document] updateChangeCount:NSChangeDone];
	}
}

- (void)savePanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if (returnCode == NSOKButton) {
		
		NSMutableString *outputString = [NSMutableString stringWithCapacity:700];
		CBNombreFormatter *soldeFormateur = [[self document] soldeFormateur];
		
		[outputString appendFormat:NSLocalizedString(@"CBEnteteTXTPortefeuille", nil), 
						[managedPortefeuille nomPrenom], 
						[soldeFormateur stringForObjectValue:[managedPortefeuille soldeTotalComptes]]
					];

		NSEnumerator *enumerator = [[comptesControler arrangedObjects] objectEnumerator];
		CBCompte *anObject;
		while (anObject = (CBCompte *)[enumerator nextObject]) {

			[outputString appendFormat:NSLocalizedString(@"CBLigneTXTPortefeuille", nil), 
							[anObject banque], 
							[anObject numeroCompte], 
							[soldeFormateur stringForObjectValue:[anObject soldeReel]],
							[soldeFormateur stringForObjectValue:[anObject soldeBanque]]
						];

		}

		[outputString replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [outputString length])];

		NSError *outError = nil;
		if (![outputString writeToFile:[sheet filename] atomically:YES encoding:NSUTF8StringEncoding error:&outError] && outError != nil) {
			
			NSMutableDictionary *raisedErrorDict = [[[outError userInfo] mutableCopy] autorelease];
			NSString *titreErreur = [NSString stringWithString:NSLocalizedString(@"CBFichierTXTMessageErreur", nil)];
			[raisedErrorDict setObject:titreErreur forKey:NSLocalizedDescriptionKey];
			NSError *raisedError = [NSError errorWithDomain:[outError domain] code:[outError code] userInfo:raisedErrorDict];
			[sheet orderOut:self];
			[self presentError:raisedError modalForWindow:[self window] 
												delegate:nil 
												didPresentSelector:NULL 
												contextInfo:NULL];
		}

	}
}

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem
{
	if ([menuItem action] == @selector(editerCompte:) && ![comptesControler canRemove])  {
		return NO;
	}
	if ([menuItem action] == @selector(suppressionCompte:) && ![comptesControler canRemove])  {
		return NO;
	}
	if ([menuItem action] == @selector(debutVirement:) && [[comptesControler  arrangedObjects] count] < 2) {
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

}

- (void)keyDown:(NSEvent *)theEvent
{
	NSCharacterSet *carSetEnter = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C%C", 0x0003, 0x000D]];
	NSCharacterSet *carSetDel = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C", 0x007F]];
	
    if( [[theEvent characters] rangeOfCharacterFromSet:carSetEnter].location != NSNotFound && [comptesControler canRemove] ) {
		[self editerCompte:self];
	}
    else if( [[theEvent characters] rangeOfCharacterFromSet:carSetDel].location != NSNotFound && [comptesControler canRemove] ) {
		[self suppressionCompte:self];
	}
	else {
		[super keyDown:theEvent];
	}
}

- (void)printDocument:(id)sender
{
	NSPrintInfo *pInfo = [[self document] printInfo];
	
	CBVueImpressionPortefeuille *myVue = [[CBVueImpressionPortefeuille alloc] initWithPortefeuille:managedPortefeuille 
																				comptes:[comptesControler arrangedObjects] 
																				printInfo:pInfo 
																				nombreFormatter:[[self document] soldeFormateur]];
	
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
