//
//  JSONAPIResource.h
//  JSONAPI
//
//  Created by Josh Holtz on 12/24/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIMDictionaryMapperResource : NSObject<NSCoding>

+ (NSArray*)resourcesFromArray:(NSArray*)array;
+ (NSArray*)resourcesFromArray:(NSArray*)array withClass:(Class)resourceObjectClass;

+ (id)resourceFromDictionary:(NSDictionary*)dictionary;
+ (id)resourceFromDictionary:(NSDictionary*)dictionary withClass:(Class)resourceObjectClass;

- (id)initWithDictionary:(NSDictionary*)dict;

- (NSDictionary *)mapKeysToProperties;

@end
