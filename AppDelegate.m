//
//  AppDelegate.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 11/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "AppDelegate.h"
#import "DataLoader.h"
// #import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // [Crashlytics startWithAPIKey:@"fc62541ac0b1cf9e884084965cf833ff17d9d545"];
    [Fabric with:@[[Crashlytics class]]];
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"seg"];
    
   // [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"newSession"];
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"SecondOptions"];
    
    [NSPersistentStoreCoordinator setDataModelName:@"SignatureModel" withStoreName: @"SignatureDB.sqlite"];
    
    [DataLoader sharedInstance];
    
    
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [self handleURL:url];
}


#pragma mark - Handle Custom URLScheme
- (BOOL)handleURL:(NSURL *)url {
    //hvactek  hvactek://?jobID=jobNumber  hvactek://?jobID=123456
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    
    if ([urlString hasPrefix:@"hvactek://"]) {
        urlString = [urlString substringFromIndex:[@"hvactek://?" length]];
        
        if ([urlString hasPrefix:@"jobID="]) {
            urlString = [urlString substringFromIndex:[@"jobID=" length]];
            //[self handleResponseForString:urlString];
            [self performSelector:@selector(handleResponseForString:) withObject:urlString afterDelay:0.5];
        }
    }
    
    return YES;
}



#pragma mark - Handle Custom URLScheme
- (void)handleResponseForString:(NSString *)jobString {
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    if ([[DataLoader sharedInstance] currentUser] == nil) {
        ShowOkAlertWithTitle(@"In order to start a new job, please Sign In.", [navController visibleViewController]);
    }else{
        
        NSMutableArray *allControllers = [[NSMutableArray alloc] initWithArray:navController.viewControllers];
        [DataLoader sharedInstance].recivedSWRJobID = jobString;
        
        if ([allControllers containsObject:self.homeController]) {
            if (navController.topViewController == self.homeController) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NotifReciveJobIDFromSWR" object:nil];
            }else{
                [navController popToViewController:self.homeController animated:YES];
            }
        }else{
            if ([allControllers containsObject:self.mainVController]) {
                [navController popToViewController:self.mainVController animated:NO];
                [self.mainVController performSegueWithIdentifier:@"tehnicianHome" sender:self.mainVController];
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
                TechnicianHomeVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"TechnicianHomeVC"];
                [navController setViewControllers:@[vc] animated:YES];
            }
        }
    }
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
  
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Unifeiyed_Quoting" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Unifeiyed_Quoting.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{ NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
       
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
