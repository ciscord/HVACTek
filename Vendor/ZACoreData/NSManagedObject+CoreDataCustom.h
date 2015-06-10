//
//  NSManagedObject+CoreData.h
//  OSM
//
//  Created by Andrei Zaharia on 2/10/14.
//  Copyright (c) 2014 Andrei Zaharia. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CoreDataCustom)

-(void) setUnkownValue: (id) value forKey: (NSString *) key;
-(void) setValue:(id)value forCustomMappedKey:(NSString *)key;
-(void) setPropertiesFromDictionary: (NSDictionary *) info;

-(void) setListToRelationName: (NSString *) relName list: (NSArray *) items clean: (BOOL) clean;


@end
