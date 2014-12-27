//
//  JSTAppDelegate.h
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 22/12/14.
//  ***REMOVED***
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class JSTSensorManager;

@interface JSTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

