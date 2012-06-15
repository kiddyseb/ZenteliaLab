//
//  AppDelegate.h
//  Hello2
//
//  Created by Bogdan Vladu on 10/27/11.
//  Copyright Bogdan Vladu 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
