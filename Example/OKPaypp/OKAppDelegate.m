//
//  OKAppDelegate.m
//  OKPaypp
//
//  Created by deadvia on 07/31/2018.
//  Copyright (c) 2018 deadvia. All rights reserved.
//

#import "OKAppDelegate.h"
#import <OKPaypp/OKPaypp.h>

@implementation OKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    OKPayDefaultConfigurator *config = [[OKPayDefaultConfigurator alloc] init];
    config.appScheme = @"com.tilink.360qws";
    config.wxPayAppId = @"wx20f0b43b2dfe90a1";
    config.WXAppdesc = @"lignwuapp";
    config.tnmode = @"01";
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [OKPaypp handleOpenURL:url withCompletion:^(NSString *result, OKPayppError *error) {
        NSLog(@"%@", result);
    }];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
    return [OKPaypp handleOpenURL:url sourceApplication:sourceApplication withCompletion:^(NSString *result, OKPayppError *error) {
        NSLog(@"%@", result);
    }];
}

@end
