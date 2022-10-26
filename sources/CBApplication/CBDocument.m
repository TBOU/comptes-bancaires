//
//  CBDocument.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright Thierry Boudière 2007 . All rights reserved.
//

#import "CBDocument.h"
#import "CBPortefeuilleController.h"
#import "CBCompteController.h"
#import "CBXMLArchiver.h"
#import "CBXMLUnarchiver.h"
#import "CBMetadataCreateur.h"


@implementation CBDocument

- (id)init
{
    if (self = [super init]) {
		[self setPrintInfo:[NSPrintInfo sharedPrintInfo]];
		portefeuille = [[CBPortefeuille alloc] init];
		[self creeFormateursAvecSymboleMonetaire:[portefeuille symboleMonetaire]];
    }
    return self;
}

- (void)dealloc
{
	[documentPrintInfo release];
	[portefeuille release];
	[dateFormateur release];
	[soldeFormateur release];
	[montantFormateurAvecNil release];
	[montantFormateur release];
	[numeroFormateur release];
	[texteFormateur release];
	[deviseFormateur release];
	[super dealloc];
}

- (void)makeWindowControllers
{
	CBPortefeuilleController *portefeuilleController = [[CBPortefeuilleController alloc] initWithPortefeuille:portefeuille];
	[self addWindowController:portefeuilleController];
	[portefeuilleController release];
}

- (void)updateWindowControllers
{
	NSEnumerator *enumerateur;
	id anObject;
	enumerateur = [[self windowControllers] objectEnumerator];
	while (anObject = [enumerateur nextObject]) {
		if ([anObject respondsToSelector:@selector(setManagedPortefeuille:)])  {
			[anObject setManagedPortefeuille:portefeuille];
		}
		else {
			[anObject close];
		}
	}
}

- (NSDateFormatter *)dateFormateur
{
	return dateFormateur;
}

- (CBNombreFormatter *)soldeFormateur
{
	return soldeFormateur;
}

- (CBNombreFormatter *)montantFormateurAvecNil
{
	return montantFormateurAvecNil;
}

- (CBNombreFormatter *)montantFormateur
{
	return montantFormateur;
}

- (CBNombreFormatter *)numeroFormateur
{
	return numeroFormateur;
}

- (CBChaineFormatter *)texteFormateur
{
	return texteFormateur;
}

- (CBChaineFormatter *)deviseFormateur
{
	return deviseFormateur;
}

- (void)creeFormateursAvecSymboleMonetaire:(NSString *)aSymboleMonetaire
{
	[dateFormateur release];
	dateFormateur = [[NSDateFormatter alloc] initWithDateFormat:@"%d/%m/%Y" allowNaturalLanguage:NO];
	
	[soldeFormateur release];
	soldeFormateur = [[CBNombreFormatter alloc] initWithSymboleMonetaire:aSymboleMonetaire autoriseNil:NO autoriseMinus:YES];
	
	[montantFormateurAvecNil release];
    montantFormateurAvecNil = [[CBNombreFormatter alloc] initWithSymboleMonetaire:aSymboleMonetaire autoriseNil:YES autoriseMinus:NO];
	
	[montantFormateur release];
    montantFormateur = [[CBNombreFormatter alloc] initWithSymboleMonetaire:aSymboleMonetaire autoriseNil:NO autoriseMinus:NO];
	
	[numeroFormateur release];
	numeroFormateur = [[CBNombreFormatter alloc] initWithSymboleMonetaire:nil autoriseNil:NO autoriseMinus:NO];
	
	[texteFormateur release];
	texteFormateur = [[CBChaineFormatter alloc] initWithAutoriseNil:NO caracteresInterdits:nil];
	
	[deviseFormateur release];
	deviseFormateur = [[CBChaineFormatter alloc] initWithAutoriseNil:NO caracteresInterdits:[NSCharacterSet characterSetWithCharactersInString:@";"]];
}

- (void)updateFormateurs
{
	[self creeFormateursAvecSymboleMonetaire:[portefeuille symboleMonetaire]];

	NSEnumerator *enumerateur;
	id anObject;
	enumerateur = [[self windowControllers] objectEnumerator];
	while (anObject = [enumerateur nextObject]) {
		if ([anObject respondsToSelector:@selector(appliqueFormateurs)])  {
			[anObject appliqueFormateurs];
			[[anObject window] display];
		}
	}
}

- (void)ouvreFenetreCompte:(CBCompte *)aCompte
{
	// On vérifie que la fenêtre du compte n'est pas déjà ouverte
	NSEnumerator *enumerateur;
	id anObject;
	enumerateur = [[self windowControllers] objectEnumerator];
	while (anObject = [enumerateur nextObject]) {
		if ([anObject respondsToSelector:@selector(managedCompte)] && [anObject managedCompte] == aCompte)  {
			[anObject showWindow:self];
			return;
		}
	}

	CBCompteController *compteController = [[CBCompteController alloc] initWithPortefeuille:portefeuille Compte:aCompte];
	[self addWindowController:compteController];
	[compteController showWindow:self];
	[compteController release];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    if ([typeName isEqualToString:CBTypeDocumentBinaire]) {
		
		NSData *data;
        
		NSKeyedArchiver *keyedArchiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
		[keyedArchiver encodeObject:CBAppArchiveVersion forKey:@"version"];
		[keyedArchiver encodeObject:[self generateMetadata] forKey:@"metadata"];
		[keyedArchiver encodeObject:[self printInfo] forKey:@"printInfo"];
		[keyedArchiver encodeObject:portefeuille forKey:@"portefeuille"];
		[keyedArchiver finishEncoding];
        data = [keyedArchiver encodedData];
		[keyedArchiver release];
		return data;
    }

    else if ([typeName isEqualToString:CBTypeDocumentXML]) {
		
		NSData *data;
		
		NSXMLDocument *myXMLDocument = [[NSXMLDocument alloc] initWithRootElement:[[[NSXMLElement alloc] initWithName:@"ComptesBancaires"] autorelease]];
		[myXMLDocument setVersion:@"1.0"];
		[myXMLDocument setCharacterEncoding:@"UTF-8"];
		[myXMLDocument setStandalone:YES];
		
		CBXMLArchiver *myXMLArchiver = [[CBXMLArchiver alloc] initWithElement:[myXMLDocument rootElement]];
		[myXMLArchiver encodeString:CBAppArchiveVersion forKey:@"version"];
		[myXMLArchiver encodeString:[self generateMetadata] forKey:@"metadata"];
		[myXMLArchiver encodeXMLCodingObject:portefeuille forKey:@"portefeuille" withID:NO];
		[myXMLArchiver release];
		
		data = [myXMLDocument XMLData];
		[myXMLDocument release];
		return data;
	}

	if (outError) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"CBTypeDocumentMessageErreur", nil), typeName];
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedRecoverySuggestionErrorKey];
        *outError = [NSError errorWithDomain:CBAppErrorDomain code:CBTypeDocumentErreur userInfo:userInfoDict];
    }
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    if ([typeName isEqualToString:CBTypeDocumentBinaire]) {
		
		@try {
			
            NSError *outError = nil;
            NSKeyedUnarchiver *keyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&outError];
            if (outError != nil) {
                [NSException raise:[outError domain] format:@"%@", [outError localizedDescription]];
            }
            [keyedUnarchiver setRequiresSecureCoding:NO];
            [keyedUnarchiver setDecodingFailurePolicy:NSDecodingFailurePolicyRaiseException];
			NSPrintInfo *pInfo = [keyedUnarchiver decodeObjectForKey:@"printInfo"];
			if (pInfo != nil) {
				[self setPrintInfo:pInfo];
			}
			[portefeuille release];
			portefeuille = [[keyedUnarchiver decodeObjectForKey:@"portefeuille"] retain];
			[self updateWindowControllers];
			[self updateFormateurs];
			[keyedUnarchiver finishDecoding];
			[keyedUnarchiver release];
			return YES;
		}
		@catch (NSException *exception) {
				
				NSUnarchiver *unarchiver = [[NSUnarchiver alloc] initForReadingWithData:data];
				id ancienPortefeuille = [unarchiver decodeObject];
				if (ancienPortefeuille != nil) {
				
					NSAlert *myAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"CBTitreAlertConversionAncienFichier", nil) 
											defaultButton:NSLocalizedString(@"CBBoutonOK", nil) 
											alternateButton:nil 
											otherButton:nil 
											informativeTextWithFormat:NSLocalizedString(@"CBContenuAlertConversionAncienFichier", nil)];
					[myAlert runModal];

					[portefeuille release];
					portefeuille = [[CBPortefeuille alloc] initAvecAncienPortefeuille:ancienPortefeuille];
					[self updateWindowControllers];
					[self updateFormateurs];
					[portefeuille calculeSoldes];
					[self updateChangeCount:NSChangeDone];
					[unarchiver release];
					return YES;
				}
				else {
				
					NSString *message = [NSString stringWithString:NSLocalizedString(@"CBContenuFichierMessageErreur", nil)];
					NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedRecoverySuggestionErrorKey];
					*outError = [NSError errorWithDomain:CBAppErrorDomain code:CBContenuFichierErreur userInfo:userInfoDict];
					[unarchiver release];
					return NO;
				}
		}
		
    }

    else if ([typeName isEqualToString:CBTypeDocumentXML]) {
		
		NSXMLDocument *myXMLDocument = [[NSXMLDocument alloc] initWithData:data options:0 error:outError];
		
		if (myXMLDocument == nil) {
			NSString *message = [NSString stringWithString:NSLocalizedString(@"CBContenuFichierMessageErreur", nil)];
			NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedRecoverySuggestionErrorKey];
			*outError = [NSError errorWithDomain:CBAppErrorDomain code:CBContenuFichierErreur userInfo:userInfoDict];
			return NO;
		}
		
		CBXMLUnarchiver *myXMLUnarchiver = [[CBXMLUnarchiver alloc] initWithElement:[myXMLDocument rootElement]];
		
		[portefeuille release];
		portefeuille = [[CBPortefeuille alloc] initWithXMLUnarchiver:[myXMLUnarchiver derivedUnarchiverForKey:@"portefeuille"]];
		[self updateWindowControllers];
		[self updateFormateurs];
		[portefeuille calculeSoldes];

		[myXMLUnarchiver release];

		[myXMLDocument release];
		return YES;
	}
    
    if (outError) {
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"CBTypeDocumentMessageErreur", nil), typeName];
        NSDictionary *userInfoDict = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedRecoverySuggestionErrorKey];
        *outError = [NSError errorWithDomain:CBAppErrorDomain code:CBTypeDocumentErreur userInfo:userInfoDict];
    }
	return NO;
}

- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem
{
	if ([anItem action] == @selector(saveDocument:) && ![self isDocumentEdited])  {
		return NO;
	}
	if ([anItem action] == @selector(revertDocumentToSaved:) && ![self isDocumentEdited])  {
		return NO;
	}
	return [super validateUserInterfaceItem:anItem];
}

- (NSString *)generateMetadata
{
	CBMetadataCreateur *myMetadataCreateur = [[CBMetadataCreateur alloc] init];
	
	[myMetadataCreateur ajouteString:[portefeuille nom]];
	[myMetadataCreateur ajouteString:[portefeuille prenom]];
	
	NSEnumerator *comptesEnumerator = [[portefeuille comptes] objectEnumerator];
	CBCompte *aCompte;
	while (aCompte = (CBCompte *)[comptesEnumerator nextObject]) {
		
		[myMetadataCreateur ajouteString:[aCompte banque]];
		[myMetadataCreateur ajouteString:[aCompte numeroCompte]];

		NSEnumerator *mouvementsEnumerator = [[aCompte mouvements] objectEnumerator];
		CBMouvement *aMouvement;
		while (aMouvement = (CBMouvement *)[mouvementsEnumerator nextObject]) {
			
			[myMetadataCreateur ajouteString:[aMouvement libelle]];
			[myMetadataCreateur ajouteString:[[aMouvement categorie] titre]];
		}

	}

	NSString *returnString = [myMetadataCreateur metadataString];
	[myMetadataCreateur release];
	
	return returnString;
}

- (NSPrintInfo *)printInfo
{
	return documentPrintInfo;
}

- (void)setPrintInfo:(NSPrintInfo *)printInfo
{
	[documentPrintInfo autorelease];
	documentPrintInfo = [printInfo copy];
}

- (BOOL)shouldChangePrintInfo:(NSPrintInfo *)newPrintInfo
{
	[self updateChangeCount:NSChangeDone];
	return YES;
}

@end
