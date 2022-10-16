//
//  ListeLibelles.h
//  Comptes Bancaires
//
//  Created by Thierry Boudière on Mon Dec 17 2001.
//  Copyright (c) 2001 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>


@interface ListeLibelles : NSObject <NSCoding>
{
@private
    NSMutableArray *_libelles;
    NSMutableArray *_montants;
}

- (NSMutableArray *)libelles;
- (NSMutableArray *)montants;

@end
