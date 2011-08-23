//
//  RemoteData.h
//  HAK
//
//  Created by Matej Spoler on 5/18/11.
//  Copyright 2011 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol IFRemoteDataDelegate <NSObject>
    -(void)dataDidLoad:(NSString*)data;
@end

@interface IFRemoteData : NSObject {
    int retryCount;
    SEL _selector;
    BOOL _validCache;
    ASIHTTPRequest* request;
    NSDate* createdAt;
}

-(void)downloadInBackground;
-(void)clearCache;
-(id)initWithURL:(NSURL*)__url;
-(void)removeDelegate:(id<IFRemoteDataDelegate>) delegateToRemove;

@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) BOOL validCache;
@property (nonatomic, assign) BOOL useCache;
@property (nonatomic, assign) BOOL permanentCache;
@property (nonatomic, assign) NSTimeInterval cachingInterval;

@property (assign) id <IFRemoteDataDelegate> delegate;
@property(nonatomic,retain) NSString* cachedData;
@property(nonatomic,retain) NSString* key;
@property(nonatomic,retain) NSURL* url;

@end
