//
//  NSDictionary+NSNullReplaceWithNil.h
//  HugeList
//
//  Created by Alexei on 25.03.2014.
//  Copyright (c) 2014 HugeList. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSNullReplaceWithNil)

- (id)objectForKeyNotNull:(id)key;

@end
