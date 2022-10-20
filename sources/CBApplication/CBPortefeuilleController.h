//
//  CBPortefeuilleController.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBPortefeuille.h"
#import "CBCompte.h"
#import "CBCategorieMouvement.h"
#import "CBLibellesPredefinisArrayController.h"
#import "CBVirement.h"
#import "CBChoixCompteArrayController.h"


@interface CBPortefeuilleController : NSWindowController {
	CBPortefeuille *managedPortefeuille;
	NSMutableArray *ecrituresAutomatiques;
	
	NSDate *dateCloture;
	BOOL sauvegardeCloture;

	CBPortefeuille *tempPortefeuille;
	CBCompte *tempCompte;
	CBVirement *tempVirement;
	
	IBOutlet NSObjectController *portefeuilleControler;
	IBOutlet NSObjectController *tempPortefeuilleControler;
	IBOutlet NSArrayController *comptesControler;
	IBOutlet NSArrayController *categoriesMouvementControler;
	IBOutlet NSObjectController *tempCompteControler;
	IBOutlet NSArrayController *ecrituresAutomatiquesControler;
	IBOutlet NSObjectController *tempVirementControler;
	IBOutlet CBChoixCompteArrayController *compteDebiteurControler;
	IBOutlet CBChoixCompteArrayController *compteCrediteurControler;
	IBOutlet CBLibellesPredefinisArrayController *libellesPredefinisControler;

	IBOutlet NSButton *boutonVirement;
	IBOutlet NSTableView *tableComptes;
	IBOutlet NSTableView *tableCategoriesMouvement;
    IBOutlet NSTableView *tableEcrituresAutomatiques;
	
	// Eléments nécessitant un formateur
	IBOutlet NSTextField *champNom;
	IBOutlet NSTextField *champPrenom;
	IBOutlet NSTextField *champSymboleMonetaire;
	IBOutlet NSTextField *champSoldeTotalComptes;
	
	IBOutlet NSTextField *champBanque;
	IBOutlet NSTextField *champNumeroCompte;
	IBOutlet NSTextField *champSoldeInitial;
	IBOutlet NSTextField *champNumeroProchainCheque;
	IBOutlet NSTextField *champNumeroProchainChequeEmploiService;
	
	IBOutlet NSTextField *champLibelleVirement;
	IBOutlet NSTextField *champMontantVirement;
	
	IBOutlet NSTableColumn *colonneSoldeReel;
	IBOutlet NSTableColumn *colonneSoldeBanque;
	
	IBOutlet NSTableColumn *colonneTitreCategorie;
	IBOutlet NSTableColumn *colonneNombreLiens;
	
	IBOutlet NSTableColumn *colonneDateEcritureAutomatique;
	IBOutlet NSTableColumn *colonneMontantEcritureAutomatique;


    IBOutlet NSWindow *fenetreParametres;
    IBOutlet NSWindow *fenetreCategoriesMouvement;
    IBOutlet NSWindow *fenetreAjouterCompte;
    IBOutlet NSWindow *fenetreCloturerExercice;
	IBOutlet NSWindow *fenetreEcrituresAutomatiques;
	IBOutlet NSWindow *fenetreVirement;
}

- (id)initWithPortefeuille:(CBPortefeuille *)aPortefeuille;

- (CBPortefeuille *)managedPortefeuille;
- (void)setManagedPortefeuille:(CBPortefeuille *)aPortefeuille;

- (NSMutableArray *)ecrituresAutomatiques;

- (NSDate *)dateCloture;
- (void)setDateCloture:(NSDate *)aDateCloture;

- (BOOL)sauvegardeCloture;
- (void)setSauvegardeCloture:(BOOL)aSauvegardeCloture;

- (void)appliqueFormateurs;

- (void)calculeEcrituresAutomatiques;
- (IBAction)debutSelectionEcrituresAutomatiques:(id)sender;
- (IBAction)actionSelectionEcrituresAutomatiques:(id)sender;

- (IBAction)debutAjoutCompte:(id)sender;
- (IBAction)finAjoutCompte:(id)sender;

- (IBAction)editerCompte:(id)sender;

- (IBAction)suppressionCompte:(id)sender;

- (IBAction)debutVirement:(id)sender;
- (IBAction)updateMontantVirement:(id)sender;
- (IBAction)filtrePourCompteDebiteurVirement:(id)sender;
- (IBAction)filtrePourCompteCrediteurVirement:(id)sender;
- (IBAction)finVirement:(id)sender;

- (IBAction)debutEditionParametres:(id)sender;
- (IBAction)finEditionParametres:(id)sender;

- (IBAction)debutEditionCategoriesMouvement:(id)sender;
- (IBAction)ajoutCategoriesMouvement:(id)sender;
- (IBAction)suppressionCategoriesMouvement:(id)sender;
- (IBAction)finEditionCategoriesMouvement:(id)sender;

- (IBAction)debutClotureExercice:(id)sender;
- (IBAction)finClotureExercice:(id)sender;

- (IBAction)sauveFichierTXT:(id)sender;

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
- (void)suppressionCategorieMouvementAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
- (void)suppressionCompteAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;
- (void)textDidChange:(NSNotification *)aNotification;
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;

@end
