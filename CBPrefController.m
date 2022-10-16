//
//  CBPrefController.m
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import "CBPrefController.h"
#import "CBGlobal.h"
#import "CBNombreFormatter.h"


@implementation CBPrefController

- (id)init
{
	self = [super initWithWindowNibName:@"Pref"];
	return self;
}

- (void)windowDidLoad
{
	CBNombreFormatter *numeroFormateur = [[CBNombreFormatter alloc] initWithSymboleMonetaire:nil autoriseNil:NO autoriseMinus:NO];
	[[champIntervalleMinMoyenne cell] setFormatter:numeroFormateur];
	[numeroFormateur release];
	[self updateUIFromPreferences];
}

- (IBAction)sauveModificationsPreferences:(id)sender
{
	if ([self  commitEditing]) {
		[[self window] orderOut:sender];
		[self updatePreferencesFromUI];
	}
	else {
		NSBeep();
	}
}

- (IBAction)valeursParDefautPreferences:(id)sender
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:CBIntervalleMinMoyenneDefaultKey];
	[self updateUIFromPreferences];
}

- (IBAction)annuleModificationsPreferences:(id)sender
{
	[[self window] orderOut:sender];
	[self updateUIFromPreferences];
}

- (void)updateUIFromPreferences
{
	[champIntervalleMinMoyenne setObjectValue:[[NSUserDefaults standardUserDefaults] objectForKey:CBIntervalleMinMoyenneDefaultKey]];
}

- (void)updatePreferencesFromUI
{
	[[NSUserDefaults standardUserDefaults] setObject:[champIntervalleMinMoyenne objectValue] forKey:CBIntervalleMinMoyenneDefaultKey];
}

- (BOOL)commitEditing
{
	if ([champIntervalleMinMoyenne objectValue] == nil)
		return NO;

	return YES;
}

@end
