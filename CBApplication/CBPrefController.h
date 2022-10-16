//
//  CBPrefController.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 08/01/06.
//  Copyright 2007 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CBPrefController : NSWindowController {

	IBOutlet NSTextField *champIntervalleMinMoyenne;
}

- (IBAction)sauveModificationsPreferences:(id)sender;
- (IBAction)valeursParDefautPreferences:(id)sender;
- (IBAction)annuleModificationsPreferences:(id)sender;

- (void)updateUIFromPreferences;
- (void)updatePreferencesFromUI;
- (BOOL)commitEditing;

@end
