//
//  NSFileManager+PSFoundation.m
//  PSFoundation
//

#import "NSFileManager+PSFoundation.h"
#import "NSArray+PSFoundation.h"

@implementation NSFileManager (PSFoundation)





+ (NSString *)documentsFolder {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)libraryFolder {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)bundleFolder {
    return [[NSBundle mainBundle] bundlePath];
}

@end