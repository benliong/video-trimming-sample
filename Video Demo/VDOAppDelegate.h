//
//  VDOAppDelegate.h
//  Video Demo
//
//  Created by Ben Liong on 10/1/13.
//  Copyright (c) 2013 Pixls Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) UITabBarController *tabBarController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
