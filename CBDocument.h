//
//  CBDocument.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright Thierry Boudière 2007 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "CBPortefeuille.h"
#import "CBCompte.h"
#import "CBNombreFormatter.h"
#import "CBChaineFormatter.h"


@interface CBDocument : NSDocument {
	NSPrintInfo *documentPrintInfo;
	CBPortefeuille *portefeuille;
	
	NSDateFormatter *dateFormateur;
	CBNombreFormatter *soldeFormateur;
	CBNombreFormatter *montantFormateurAvecNil;
	CBNombreFormatter *montantFormateur;
	CBNombreFormatter *numeroFormateur;
	CBChaineFormatter *texteFormateur;
	CBChaineFormatter *deviseFormateur;
}

- (void)updateWindowControllers;

- (NSDateFormatter *)dateFormateur;
- (CBNombreFormatter *)soldeFormateur;
- (CBNombreFormatter *)montantFormateurAvecNil;
- (CBNombreFormatter *)montantFormateur;
- (CBNombreFormatter *)numeroFormateur;
- (CBChaineFormatter *)texteFormateur;
- (CBChaineFormatter *)deviseFormateur;

- (void)creeFormateursAvecSymboleMonetaire:(NSString *)aSymboleMonetaire;
- (void)updateFormateurs;
- (void)ouvreFenetreCompte:(CBCompte *)aCompte;

- (NSString *)generateMetadata;

@end
