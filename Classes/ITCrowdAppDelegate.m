//
//  ITCrowdAppDelegate.m
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "ITCrowdAppDelegate.h"

#import "UploadFlyersViewController.h"
#import "ReviewViewController.h"
#import "TourGuideViewController.h"
#import "EateriesViewController.h"

@implementation ITCrowdAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
    // Override point for customization after application launch.
	tabBarController = [[UITabBarController alloc] init];
	
	//create view controllers
	EateriesViewController *eateriesViewController = [[EateriesViewController alloc] init];
	UINavigationController *fourthViewNavController = [[UINavigationController alloc] initWithRootViewController:eateriesViewController];	
	
	UploadFlyersViewController *uploadFlyersViewController = [[UploadFlyersViewController alloc] init];
	UINavigationController *firstViewNavController = [[UINavigationController alloc] initWithRootViewController:uploadFlyersViewController];
	
	ReviewViewController *reviewViewController = [[ReviewViewController alloc] init];
	UINavigationController *secondViewNavController = [[UINavigationController alloc] initWithRootViewController:reviewViewController];
	
	TourGuideViewController *tourGuideViewController = [[TourGuideViewController alloc] init];
	UINavigationController *thirdViewNavController = [[UINavigationController alloc] initWithRootViewController:tourGuideViewController];
	
	//Add view controllers as children of tabBarController
	tabBarController.viewControllers = [NSArray arrayWithObjects:firstViewNavController,thirdViewNavController, secondViewNavController,fourthViewNavController,nil];
	
	//memory management
	[uploadFlyersViewController release];
	[reviewViewController release];
	[tourGuideViewController release];
	[eateriesViewController release];
	
	[firstViewNavController release];
	[secondViewNavController release];
	[thirdViewNavController release];
	[fourthViewNavController release];
	
	tabBarController.selectedIndex = 0;
	
	[window addSubview:tabBarController.view];
	[self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
//	[firstViewNavController release];
	[tabBarController release];
    [window release];
    [super dealloc];
}


@end
