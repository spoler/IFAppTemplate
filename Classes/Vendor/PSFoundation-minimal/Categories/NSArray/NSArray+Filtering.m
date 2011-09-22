//
//  NSArray+Filtering.m
//  PSFoundation
//
//  Includes code by the following:
//   - Erica Sadun.       2009.  Public domain.
//   - Peter Steinberger. 2009.  MIT.
//   - Matthias Tretter.  2010.  MIT.
//

#import "NSArray+Filtering.h"
#import "NSMutableArray+PSFoundation.h"
#import "NSArray+PSFoundation.h"
#import <time.h>
#import <stdarg.h>

#pragma mark UtilityExtensions
@implementation NSArray (PSArrayAlgebra)

- (id)uniqueMembers {
    return [NSArray arrayWithArray:[NSSet setWithArray:self]];
}

- (id)unionWithArray:(NSArray *)anArray {
	if (!anArray) return self;
	return [[self arrayByAddingObjectsFromArray:anArray] uniqueMembers];
}

- (id)intersectionWithArray:(NSArray *)anArray {
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
		if (![anArray containsObject:object])
			[copy removeObjectIdenticalTo:object];
    NSArray *ret = [copy uniqueMembers];
    [copy release];
    return ret;
}

- (id)intersectionWithSet:(NSSet *)anSet {
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
		if (![anSet containsObject:object])
			[copy removeObjectIdenticalTo:object];
    NSArray *ret = [copy uniqueMembers];
    [copy release];
    return ret;
}

// http://en.wikipedia.org/wiki/Complement_(set_theory)
- (id)complementWithArray:(NSArray *)anArray {
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
		if ([anArray containsObject:object])
			[copy removeObjectIdenticalTo:object];
    NSArray *ret = [copy uniqueMembers];
    [copy release];
    return ret;
}

- (id)complementWithSet:(NSSet *)anSet {
	NSMutableArray *copy = [self mutableCopy];
	for (id object in self)
		if ([anSet containsObject:object])
			[copy removeObjectIdenticalTo:object];
    NSArray *ret = [copy uniqueMembers];
    [copy release];
    return ret;
}

@end

@implementation NSArray (PSArrayResort)

- (id)arrayByReversing {
    NSMutableArray *resorted = [self mutableCopy];
    [resorted reverse];
    return [resorted autorelease];
}

- (id)arrayByShuffling {
    NSMutableArray *shuffled = [self mutableCopy];
    [shuffled shuffle];
    return [shuffled autorelease];
}

@end

@implementation NSMutableArray (PSArrayResort)

- (void)reverse {
	for (int i=0; i<(floor([self count]/2.0)); i++)
		[self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];    
}

// http://en.wikipedia.org/wiki/Knuth_shuffle
- (void)shuffle {
    for (NSUInteger i = self.count; i > 1; i--) {
        NSUInteger m = 1;
        do {
            m <<= 1;
        } while (m < i);
        
        NSUInteger j;
        
        do {
            j = arc4random() % m;
        } while (j >= i);
        
        [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
}

- (id)reversed {
    [self reverse];
    return self;
}

- (id)shuffled {
    [self shuffle];
    return self;
}

@end

@implementation NSArray (PSArraySorting)

- (id)objectUsingPredicate:(NSPredicate *)predicate {
    NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
    if (filteredArray)
        return filteredArray.first;
    return nil;
}



- (NSString *)stringValue {
	return [self componentsJoinedByString:@" "];
}

@end