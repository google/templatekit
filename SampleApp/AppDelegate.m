/*
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AppDelegate.h"

#import "SampleViewController.h"
#import "Templates/ActivityIndicatorExample.h"
#import "Templates/AdapterExample.h"
#import "Templates/FirstExample.h"
#import "Templates/LayerExample.h"
#import "Templates/PosteditExample.h"
#import "Templates/RTLExample.h"
#import "Templates/SpaceExample.h"
#import "TemplateKit.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  TPLView *view = [[FirstExampleView alloc] init];
  TPLViewModel *viewModel = [[FirstExampleViewModel alloc] init];
  view.viewModel = viewModel;
  view.backgroundColor = [UIColor whiteColor];
  SampleViewController *rootViewController =
      [[SampleViewController alloc] initWithContentView:view];
  self.window.rootViewController = rootViewController;
  return YES;
}

@end
