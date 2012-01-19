//
//  ITCrowdAppDelegate.h
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITCrowdAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

