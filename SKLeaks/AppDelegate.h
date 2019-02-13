//
//  AppDelegate.h
//  SKLeaks
//
//  Created by 赵申侃 on 2019/2/12.
//  Copyright © 2019 赵申侃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

