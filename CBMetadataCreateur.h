//
//  CBMetadataCreateur.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on 17/02/06.
//  Copyright 2006 Thierry Boudière. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CBMetadataCreateur : NSObject {
	NSMutableSet *metadataSet;
}

- (void)ajouteString:(NSString *)aString;
- (NSString *)metadataString;

@end
