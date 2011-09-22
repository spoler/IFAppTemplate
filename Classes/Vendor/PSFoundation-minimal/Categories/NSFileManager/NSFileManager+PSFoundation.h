//
//  NSFileManager+PSFoundation.h
//  PSFoundation
//
//  Includes code by the following:
//   - Erica Sadun.        2009.  BSD.
//   - Peter Steinberger.  2010.  MIT.
//

@interface NSFileManager (PSFoundation)

+ (NSString *)documentsFolder;
+ (NSString *)libraryFolder;
+ (NSString *)bundleFolder;

@end