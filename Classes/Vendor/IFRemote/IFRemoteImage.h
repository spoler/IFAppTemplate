//
//  SEImage.h
//  iPad Shoutem
//
//  Created by Matej Spoler on 3/28/11.
//  Copyright 2011 Infinum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol IFRemoteImageViewDelegate <NSObject>
    -(void)imageDidLoad:(UIImage*)image;
@end

@class ASIHTTPRequest;

@interface IFRemoteImage : NSObject {
    int retryCount;
    id _target;
    SEL _selector;
    ASIHTTPRequest* request;
}

-(void)downloadInBackground;
-(void)downloadInBackgroundWithTarget:(id)__target selector:(SEL)__selector;
-(void)clearCache;
-(id)initWithURL:(NSURL*)__url;
-(void)removeDelegate:(id<IFRemoteImageViewDelegate>) delegateToRemove;

@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, assign) BOOL validCache;
@property (nonatomic, assign) BOOL useCache;
@property (nonatomic, assign) BOOL permanentCache;
@property (nonatomic, assign) CGSize size;
//@property (nonatomic, retain) NSMutableArray* observers;
@property (assign) id <IFRemoteImageViewDelegate> delegate;
@property(nonatomic,retain) UIImage* cachedImage;
@property(nonatomic,retain) NSURL* url;

@end
