//
//  IFAppTemplateAppDelegate.h
//  IFAppTemplate
//
//  Created by Matej Spoler on 8/23/11.
//  Copyright 2011 Infinum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> {

}
void uncaughtExceptionHandler(NSException *exception);
@property (nonatomic, retain) IBOutlet UIWindow *window;


@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
