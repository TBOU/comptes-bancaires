//
//  CBCompteController.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBPortefeuille.h"
#import "CBCompte.h"
#import "CBMouvement.h"
#import "CBMouvementMultiple.h"
#import "CBMouvementsArrayController.h"
#import "CBLibellesPredefinisArrayController.h"
#import "CBStatistiques.h"


@interface CBCompteController : NSWindowController {
	CBPortefeuille *managedPortefeuille;
	CBCompte *managedCompte;
	
	NSCalendarDate *dateDebutStatistiques;
	NSCalendarDate *dateFinStatistiques;

	BOOL impressionTousMouvements;
	NSCalendarDate *dateDebutImpression;
	NSCalendarDate *dateFinImpression;
	
	CBCompte *tempCompte;
	CBMouvement *tempMouvement;
	CBMouvementMultiple *tempMouvementMultiple;
	CBStatistiques *tempStatistiques;

	IBOutlet NSObjectController *compteControler;
	IBOutlet NSObjectController *tempCompteControler;
	IBOutlet CBMouvementsArrayController *mouvementsControler;
	IBOutlet CBLibellesPredefinisArrayController *libellesPredefinisControler;
	IBOutlet NSArrayController *categoriesMouvementControler;
	IBOutlet NSObjectController *tempMouvementControler;
	IBOutlet NSObjectController *tempMouvementMultipleControler;
	IBOutlet NSArrayController *mouvementsPeriodiquesControler;
	IBOutlet NSObjectController *tempStatistiquesControler;
	IBOutlet NSArrayController *tempStatistiquesCategoriesControler;

	IBOutlet NSPopUpButton *operationMenu;
	IBOutlet NSTableView *tableMouvements;
	IBOutlet NSTableView *tableLibellesPredefinis;
	IBOutlet NSTableView *tableMouvementsPeriodiques;
	
	// Eléments nécessitant un formateur
	IBOutlet NSTextField *champSoldeReel;
	IBOutlet NSTextField *champSoldeBanque;
	IBOutlet NSTextField *champSoldeCBEnCours;
	IBOutlet NSTextField *champSoldeMouvementsFiltres;
	
	IBOutlet NSTextField *champBanque;
	IBOutlet NSTextField *champNumeroCompte;
	IBOutlet NSTextField *champSoldeInitial;
	IBOutlet NSTextField *champNumeroProchainCheque;
	IBOutlet NSTextField *champNumeroProchainChequeEmploiService;
	
	IBOutlet NSTextField *champLibelleMouvementSingle;
	IBOutlet NSTextField *champNumeroChequeSingle;
	IBOutlet NSTextField *champNumeroChequeEmploiServiceSingle;
	IBOutlet NSTextField *champMontantMouvementSingle;
	
	IBOutlet NSTextField *champLibelleMouvementMultiple;
	IBOutlet NSTextField *champNumeroChequeMultiple;
	IBOutlet NSTextField *champNumeroChequeEmploiServiceMultiple;
	IBOutlet NSTextField *champMontantMouvementMultiple;
	
	IBOutlet NSTextField *champTitreMouvementPeriodique;
	IBOutlet NSTextField *champValeurPeriodicite;
	IBOutlet NSTextField *champJoursAnticipation;
	IBOutlet NSTextField *champLibelleMouvementPeriodique;
	IBOutlet NSTextField *champMontantMouvementPeriodique;
	IBOutlet NSTextField *champDateProchaineEcriture;
	IBOutlet NSTextField *champNombreEcrituresEnSuspens;
	
	IBOutlet NSTextField *champStatistiquesDebitPeriode;
	IBOutlet NSTextField *champStatistiquesDebitMensuel;
	IBOutlet NSTextField *champStatistiquesCreditPeriode;
	IBOutlet NSTextField *champStatistiquesCreditMensuel;
	
	IBOutlet NSTableColumn *colonneDate;
	IBOutlet NSTableColumn *colonneDebit;
	IBOutlet NSTableColumn *colonneCredit;
	IBOutlet NSTableColumn *colonneAvoir;
	
	IBOutlet NSTableColumn *colonneLibellePredefini;
	IBOutlet NSTableColumn *colonneMontantPredefini;
	
	IBOutlet NSTableColumn *colonneStatistiquesSoldePeriode;
	IBOutlet NSTableColumn *colonneStatistiquesSoldeMensuel;

    IBOutlet NSWindow *fenetreParametres;
    IBOutlet NSWindow *fenetreLibellesPredefinis;
    IBOutlet NSWindow *fenetreEditerMouvementSingle;
    IBOutlet NSWindow *fenetreEditerMouvementMultiple;
	IBOutlet NSWindow *fenetreEditerMouvementsPeriodiques;
	IBOutlet NSWindow *fenetreStatistiques;
	IBOutlet NSWindow *fenetreDateImpression;
}

- (id)initWithPortefeuille:(CBPortefeuille *)aPortefeuille Compte:(CBCompte *)aCompte;

- (CBPortefeuille *)managedPortefeuille;
- (CBCompte *)managedCompte;

- (NSCalendarDate *)dateDebutStatistiques;
- (void)setDateDebutStatistiques:(NSCalendarDate *)aDateDebutStatistiques;

- (NSCalendarDate *)dateFinStatistiques;
- (void)setDateFinStatistiques:(NSCalendarDate *)aDateFinStatistiques;

- (BOOL)impressionTousMouvements;
- (void)setImpressionTousMouvements:(BOOL)anImpressionTousMouvements;

- (NSCalendarDate *)dateDebutImpression;
- (void)setDateDebutImpression:(NSCalendarDate *)aDateDebutImpression;

- (NSCalendarDate *)dateFinImpression;
- (void)setDateFinImpression:(NSCalendarDate *)aDateFinImpression;

- (void)appliqueFormateurs;

- (void)rearrangeMouvements;

- (IBAction)debutAjoutMouvement:(id)sender;
- (IBAction)debutEditionMouvement:(id)sender;
- (IBAction)updateMontantMouvementSingle:(id)sender;
- (IBAction)updateMontantMouvementMultiple:(id)sender;
- (IBAction)updateMontantMouvementPeriodique:(id)sender;
- (IBAction)finEditionMouvementSingle:(id)sender;
- (IBAction)finEditionMouvementMultiple:(id)sender;

- (IBAction)togglePointageMouvement:(id)sender;

- (IBAction)suppressionMouvement:(id)sender;

- (IBAction)debutEditionParametresCompte:(id)sender;
- (IBAction)finEditionParametresCompte:(id)sender;

- (IBAction)debutEditionMouvementsPeriodiques:(id)sender;
- (IBAction)ajoutMouvementsPeriodiques:(id)sender;
- (IBAction)suppressionMouvementsPeriodiques:(id)sender;
- (IBAction)finEditionMouvementsPeriodiques:(id)sender;

- (IBAction)debutEditionLibellesPredefinis:(id)sender;
- (IBAction)ajoutLibellesPredefinis:(id)sender;
- (IBAction)suppressionLibellesPredefinis:(id)sender;
- (IBAction)finEditionLibellesPredefinis:(id)sender;

- (IBAction)debutStatistiques:(id)sender;
- (IBAction)calculeStatistiques:(id)sender;
- (IBAction)finStatistiques:(id)sender;

- (IBAction)sauveFichierTXT:(id)sender;

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
- (void)suppressionLibellePredefiniAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
- (void)suppressionMouvementAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
- (void)suppressionMouvementsPeriodiquesAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
- (void)savePanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem;
- (void)textDidChange:(NSNotification *)aNotification;
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
- (IBAction)pointageDidChange:(id)sender;

- (void)printDocument:(id)sender;
- (IBAction)lancerImpression:(id)sender;

@end
