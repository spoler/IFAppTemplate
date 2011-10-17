//
//  UIImage+MTCache.m
//  PSFoundation
//
//  Created by Matthias Tretter on 04.03.11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "UIImage+MTCache.h"
#import "NSFileManager+PSFoundation.h"

@implementation UIImage (MTCache)

+ (UIImage *)JPEGWithContentsOfFilename:(NSString *)filename {
	NSString *path = [[NSFileManager documentsFolder] stringByAppendingPathComponent:filename];

	return [UIImage imageWithContentsOfFile:path];
}

- (BOOL)writeJPEGToFilename:(NSString *)filename quality:(double)quality {
	NSString *path = [[NSFileManager documentsFolder] stringByAppendingPathComponent:filename];

	return [UIImageJPEGRepresentation(self, quality) writeToFile:path options:NSAtomicWrite error:nil];
}

@end
