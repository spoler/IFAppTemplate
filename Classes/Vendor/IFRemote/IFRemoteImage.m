//
//  SEImage.m
//  iPad Shoutem
//
//  Created by Matej Spoler on 3/28/11.
//  Copyright 2011 Infinum. All rights reserved.
//

#import "IFRemoteImage.h"
#import "App.h"
#import "ASIHTTPRequest.h"



@implementation IFRemoteImage
 
@synthesize delegate=_delegate;
@synthesize url, useCache, validCache, cachedImage, permanentCache, size, isValid;

-(id)initWithURL:(NSURL*)__url{
    self = [super init];
    if (self) {
        self.url = __url;
        if (__url!=nil && [[__url relativeString] length]>10) {
            isValid = YES;
        }else{
            isValid = NO;
        }
        _target = nil;
        useCache = YES;
        permanentCache = NO;
    }
    return self;
}

-(void)removeDelegate:(id<IFRemoteImageViewDelegate>) delegateToRemove{
    if (delegateToRemove==self.delegate){
        self.delegate = nil;
    }
}



- (void)downloadInBackground
{  
    if (!isValid){
        return;
    }
    if (useCache && self.validCache){
        if (self.delegate && [self.delegate retainCount]>0){
            [self.delegate imageDidLoad:cachedImage];
        }
        return;
    }
    if (permanentCache) {
        [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    }
    request = [ASIHTTPRequest requestWithURL:self.url];
    [request allowCompressedResponse];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [[App instance].requestsQueue addOperation:request]; 
}

-(void)downloadInBackgroundWithTarget:(id)__target selector:(SEL)__selector{
    _target = __target;
    _selector = __selector;
    [self downloadInBackground];
}

- (void)requestDone:(ASIHTTPRequest *)__request
{
   // DLog(@"[IFImage]Response receaved from url: %@", self.url);
    retryCount = 0;
    UIImage* image = [UIImage imageWithData:[__request responseData]];
    self.size = image.size; //real image size
    if (useCache){
        self.cachedImage = image; 
        self.validCache = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageDidLoad:)]) //TODO sta ako delegate umre
        [self.delegate imageDidLoad:image];
    if (_target!=nil) {
        [_target performSelectorOnMainThread:_selector withObject:[UIImage imageWithData:[__request responseData]] waitUntilDone:false];
        _target = nil;
    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)__request
{
    retryCount++;
//    self.isValid = NO;
//    DLog(@"[IFImage]Error: %@ -> %@", [__request originalURL], [__request error]);
    if (retryCount<kRemoteImageMaxRetryCount){
//        DLog(@"[IFImage]Retrying: %@", self.url);
        [self downloadInBackground];
    }else if(self.delegate){

        [self.delegate imageDidLoad:NULL];
    }
}

         
         
-(void)clearCache{
    if (validCache && !permanentCache && [cachedImage retainCount]<2){
//        DLog(@"[IFImage] release (count: %d)", [cachedImage retainCount]);
        validCache = NO;
       // [cachedImage release];
        self.cachedImage = nil;
    }
}


- (void)dealloc
{
  //  if (request) {
  //      [request clearDelegatesAndCancel];
  //  }
    [self clearCache];
    self.cachedImage = nil;
    [url release];
    [super dealloc];
}

@end
