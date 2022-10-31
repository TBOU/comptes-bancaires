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
#import "NSTableView+CBExtension.h"
#import "NSAlert+CBExtension.h"


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
	
    if ([managedPortefeuille verifieEcrituresAutomatiquesEnSuspens]) {
        [self debutSelectionEcrituresAutomatiques:self];
    }
    
    [tableComptes cbRepairLayoutDeferred];
	[[self window] makeKeyAndOrderFront:self];
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
		
		NSAlert *myAlert = [NSAlert cbAlertWithMessageText:NSLocalizedString(@"CBTitreAlertFermerComptesEcritureAutomatique", nil)
								firstButton:NSLocalizedString(@"CBBoutonOK", nil)
								secondButton:nil
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
		[ecrituresAutomatiquesControler rearrangeObjects];
		
		if ([[ecrituresAutomatiquesControler arrangedObjects] count] > 0)
			[ecrituresAutomatiquesControler setSelectionIndex:0];
		
		[fenetreEcrituresAutomatiques makeFirstResponder:[fenetreEcrituresAutomatiques initialFirstResponder]];
		[tableEcrituresAutomatiques cbRepairLayoutDeferred];
		[NSApp runModalForWindow:fenetreEcrituresAutomatiques];
	}
	else if (sender != self) {
		
		NSAlert *myAlert = [NSAlert cbAlertWithMessageText:NSLocalizedString(@"CBTitreAlertAucuneEcritureAutomatique", nil)
								firstButton:NSLocalizedString(@"CBBoutonOK", nil)
								secondButton:nil
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
		NSMutableArray *ecrituresToRemove = [NSMutableArray array];
		while (anObject = (CBEcritureAutomatique *)[enumerator nextObject]) {
			
			if ([sender tag] == CBGenereEcritureAutomatique || [sender tag] == CBGenereToutesEcrituresAutomatiques) {
				[anObject genereEcriture];
				[managedPortefeuille calculeSoldes];
				[[self document] updateChangeCount:NSChangeDone];
			}
			[ecrituresToRemove addObject:anObject];
		}
		
		[ecrituresAutomatiquesControler removeObjects:ecrituresToRemove];
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
    [[self window] beginSheet:fenetreAjouterCompte completionHandler:^(NSModalResponse returnCode) {
        
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
    }];
}

- (IBAction)finAjoutCompte:(id)sender
{
	if ([tempCompteControler commitEditing]) {
		[fenetreAjouterCompte orderOut:sender];
		[[self window] endSheet:fenetreAjouterCompte returnCode:[sender tag]];
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
		
		NSAlert *myAlert = [NSAlert cbAlertWithMessageText:NSLocalizedString(@"CBTitreAlertSuppressionCompte", nil) 
								firstButton:NSLocalizedString(@"CBBoutonAnnuler", nil)
								secondButton:NSLocalizedString(@"CBBoutonOK", nil)
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertSuppressionCompte", nil), 
															[(CBCompte *)[selection objectAtIndex:0] numeroCompte], 
															[(CBCompte *)[selection objectAtIndex:0] banque]];

        [myAlert beginSheetModalForWindow:[self window] completionHandler:^(NSModalResponse returnCode) {
            
            if (returnCode == NSAlertSecondButtonReturn) {

                // On ferme la fenêtre du compte si elle est encore ouverte
                NSEnumerator *enumerateur;
                id anObject;
                enumerateur = [[[self document] windowControllers] objectEnumerator];
                while (anObject = [enumerateur nextObject]) {
                    if ( [anObject respondsToSelector:@selector(managedCompte)] && [anObject managedCompte] == (CBCompte *)[selection objectAtIndex:0])  {
                        [anObject close];
                    }
                }

                [comptesControler remove:self];
                [boutonVirement setEnabled:[[comptesControler  arrangedObjects] count] > 1];
                [[self managedPortefeuille] calculeSoldes];
                [[self document] updateChangeCount:NSChangeDone];
            }
        }];
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
	[libellesPredefinisControler rearrangeObjects];

	NSSortDescriptor *categoriesMouvementDescriptor = [[NSSortDescriptor alloc] initWithKey:@"titre" ascending:YES];
	[categoriesMouvementControler setSortDescriptors:[NSArray arrayWithObject:categoriesMouvementDescriptor]];
	[categoriesMouvementDescriptor release];
	[categoriesMouvementControler rearrangeObjects];

	[fenetreVirement makeFirstResponder:[fenetreVirement initialFirstResponder]];
    [[self window] beginSheet:fenetreVirement completionHandler:^(NSModalResponse returnCode) {
        
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
    }];
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
		[[self window] endSheet:fenetreVirement returnCode:[sender tag]];
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
    [[self window] beginSheet:fenetreParametres completionHandler:^(NSModalResponse returnCode) {
        
        if (returnCode == 1) {
            [managedPortefeuille copieParametresDepuis:tempPortefeuille];
            [[self document] updateFormateurs];
            [[self document] updateChangeCount:NSChangeDone];
        }
        [tempPortefeuilleControler setContent:nil];
        [tempPortefeuille release];
    }];
}

- (IBAction)finEditionParametres:(id)sender
{
	if ([tempPortefeuilleControler commitEditing]) {
		[fenetreParametres orderOut:sender];
		[[self window] endSheet:fenetreParametres returnCode:[sender tag]];
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
	[categoriesMouvementControler rearrangeObjects];

	if ([[categoriesMouvementControler arrangedObjects] count] > 0)
		[categoriesMouvementControler setSelectionIndex:0];
	
	[fenetreCategoriesMouvement makeFirstResponder:[fenetreCategoriesMouvement initialFirstResponder]];
    [tableCategoriesMouvement cbRepairLayoutDeferred];
    [[self window] beginSheet:fenetreCategoriesMouvement completionHandler:NULL];
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
		
		NSAlert *myAlert = [NSAlert cbAlertWithMessageText:NSLocalizedString(@"CBTitreAlertSuppressionCategorieMouvement", nil)
								firstButton:NSLocalizedString(@"CBBoutonAnnuler", nil)
								secondButton:NSLocalizedString(@"CBBoutonOK", nil)
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertSuppressionCategorieMouvement", nil),
															[(CBCategorieMouvement *)[selection objectAtIndex:0] titre], 
															[(CBCategorieMouvement *)[selection objectAtIndex:0] utilisationMouvements]];

        [myAlert beginSheetModalForWindow:fenetreCategoriesMouvement completionHandler:^(NSModalResponse returnCode) {
            
            if (returnCode == NSAlertSecondButtonReturn) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CBCategorieMouvementWillDeallocNotification"
                                                        object:(CBCategorieMouvement *)[selection objectAtIndex:0]];
                [categoriesMouvementControler remove:self];
                [[self document] updateChangeCount:NSChangeDone];
            }
        }];
	}
	else {
		NSBeep();
	}
}

- (IBAction)finEditionCategoriesMouvement:(id)sender
{
	if ([categoriesMouvementControler commitEditing]) {
		[fenetreCategoriesMouvement orderOut:sender];
		[[self window] endSheet:fenetreCategoriesMouvement returnCode:[sender tag]];
	}
	else {
		NSBeep();
	}
}

- (IBAction)debutClotureExercice:(id)sender
{
	// On vérifie que les fenêtre de compte sont toutes fermées
	if ([[[self document] windowControllers] count] > 1) {
		
		NSAlert *myAlert = [NSAlert cbAlertWithMessageText:NSLocalizedString(@"CBTitreAlertFermerComptesClotureExercice", nil)
								firstButton:NSLocalizedString(@"CBBoutonOK", nil)
								secondButton:nil
								informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertFermerComptesClotureExercice", nil)];
		[myAlert runModal];
		return;
	}
	
	
	// On initialise les variables et on affiche la fenêtre de dialogue
	NSDate *dateJour = [NSDate date];
	[self setDateCloture:CBFirstDayOfYear(dateJour)];
	[self setSauvegardeCloture:YES];
	
	[fenetreCloturerExercice makeFirstResponder:[fenetreCloturerExercice initialFirstResponder]];
    [[self window] beginSheet:fenetreCloturerExercice completionHandler:^(NSModalResponse returnCode) {
        
        if (returnCode == 1) {

            if([self sauvegardeCloture]) {
                
                NSString *nomFichier;
                nomFichier = @"~";
                nomFichier = [nomFichier stringByAppendingPathComponent:@"Desktop"];
                nomFichier = [nomFichier stringByAppendingPathComponent:[[[self document] displayName] stringByDeletingPathExtension]];
                nomFichier = [nomFichier stringByAppendingString:CBStringFromDate([self dateCloture], @"_dd_MM_yyyy")];
                nomFichier = [nomFichier stringByAppendingPathExtension:@"cba"];
                nomFichier = [nomFichier stringByExpandingTildeInPath];
                
                BOOL flag = [managedPortefeuille verifieEcrituresAutomatiquesEnSuspens];
                [managedPortefeuille setVerifieEcrituresAutomatiquesEnSuspens:NO];
                
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
                    
                    [managedPortefeuille setVerifieEcrituresAutomatiquesEnSuspens:flag];
                    return;
                }
                
                [managedPortefeuille setVerifieEcrituresAutomatiquesEnSuspens:flag];
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
    }];
}

- (IBAction)finClotureExercice:(id)sender
{
	[fenetreCloturerExercice orderOut:sender];
	[[self window] endSheet:fenetreCloturerExercice returnCode:[sender tag]];
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
                            
                            if (returnCode == NSModalResponseOK) {
                                
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

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
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
	NSCharacterSet *carSetEnter = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C%C", (unichar)0x0003, (unichar)0x000D]];
	NSCharacterSet *carSetDel = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%C", (unichar)0x007F]];
	
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
