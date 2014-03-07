//
//  AppDelegate.h
//  HeyaldaOpenGLCustomDraw
//
//  Created by Jim Range on 8/10/12.
//  Copyright Heyalda Corporation 2012. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class HeyaldaNavigationViewController;

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	HeyaldaNavigationViewController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) HeyaldaNavigationViewController *navController;
@property (readonly) CCDirectorIOS *director;

@end
