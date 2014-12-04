//
//  JSONAPIResource.m
//  JSONAPI
//
//  Created by Josh Holtz on 12/24/13.
//  Copyright (c) 2013 Josh Holtz. All rights reserved.
//

#import "SIMDictionaryMapperResource.h"

#import "SIMDictionaryMapperResourceFormatter.h"

#import <objc/runtime.h>
#import <objc/message.h>

#pragma mark - JSONAPIResource

@interface SIMDictionaryMapperResource()

@property (nonatomic, strong) NSMutableDictionary *__dictionary;

@end

@implementation SIMDictionaryMapperResource

#pragma mark -
#pragma mark - Class Methods

+ (NSArray*)resourcesFromArray:(NSArray*)array {
    return [SIMDictionaryMapperResource resourcesFromArray:array withClass:[self class]];
}

+ (NSArray*)resourcesFromArray:(NSArray*)array withClass:(Class)resourceObjectClass {
    if (resourceObjectClass == nil) {
        resourceObjectClass = [self class];
    }
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        [mutableArray addObject:[[resourceObjectClass alloc] initWithDictionary:dict]];
    }
    
    return mutableArray;
}

+ (id)resourceFromDictionary:(NSDictionary*)dictionary {
    return [SIMDictionaryMapperResource resourceFromDictionary:dictionary withClass:[self class]];
}

+ (id)resourceFromDictionary:(NSDictionary*)dictionary withClass:(Class)resourceObjectClass {
    if (resourceObjectClass == nil) {
        resourceObjectClass = [self class];
    }
    
    return [[resourceObjectClass alloc] initWithDictionary:dictionary];
}

#pragma mark -
#pragma mark - Instance Methods

- (id)initWithDictionary:(NSDictionary*)dict {
    self = [self init];
    if (self) {
        [self setWithDictionary:dict];
        
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    [self.__dictionary setValue:value forKey:key];
}

- (NSDictionary *)mapKeysToProperties {
    return [[NSDictionary alloc] init];
}

- (void)setWithDictionary:(NSDictionary*)dict {
    self.__dictionary = [dict mutableCopy];
    
    // Loops through all keys to map to propertiess
    NSDictionary *map = [self mapKeysToProperties];
    
    for (NSString *key in [map allKeys]) {
        
        // Checks if the key to map is in the dictionary to map
        if ([dict objectForKey:key] != nil && [dict objectForKey:key] != [NSNull null]) {
            
            NSString *property = [map objectForKey:key];
            
            NSRange formatRange = [property rangeOfString:@":"];
            
            @try {
                if (formatRange.location != NSNotFound) {
                    NSString *formatFunction = [property substringToIndex:formatRange.location];
                    property = [property substringFromIndex:(formatRange.location+1)];
                    
                    [self setValue:[SIMDictionaryMapperResourceFormatter performFormatBlock:[dict objectForKey:key] withName:formatFunction] forKey:property ];
                } else {
                    [self setValue:[dict objectForKey:key] forKey:property ];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"JSONAPIResource Warning - %@", [exception description]);
            }
            
        } else {
            
        }
        
    }
}

#pragma mark - NSCoding

- (NSArray *)propertyKeys {
    
    NSMutableArray *array = [NSMutableArray array];
    Class class = [self class];
    while (class != [NSObject class]) {
        
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
        for (int i = 0; i < propertyCount; i++) {
            
            //get property
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            
            //check if read-only
            BOOL readonly = NO;
            const char *attributes = property_getAttributes(property);
            NSString *encoding = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
            if ([[encoding componentsSeparatedByString:@","] containsObject:@"R"]) {
                
                readonly = YES;
                
                //see if there is a backing ivar with a KVC-compliant name
                NSRange iVarRange = [encoding rangeOfString:@",V"];
                if (iVarRange.location != NSNotFound) {
                    
                    NSString *iVarName = [encoding substringFromIndex:iVarRange.location + 2];
                    if ([iVarName isEqualToString:key] ||
                        [iVarName isEqualToString:[@"_" stringByAppendingString:key]]) {
                        
                        //setValue:forKey: will still work
                        readonly = NO;
                    }
                }
            }
            
            if (!readonly) {
                
                //exclude read-only properties
                [array addObject:key];
            }
        }
        free(properties);
        class = [class superclass];
    }
    return array;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [self init])) {
        for (NSString *key in [self propertyKeys]) {
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    for (NSString *key in [self propertyKeys]) {
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}

@end
