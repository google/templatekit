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

#import <UIKit/UIKit.h>

#ifndef TPL_ENABLE_DEBUGGING
#if DEBUG
#define TPL_ENABLE_DEBUGGING 1
#else
#define TPL_ENABLE_DEBUGGING 0
#endif
#endif

#if TPL_ENABLE_DEBUGGING

@interface TPLDebugger : NSObject

+ (void)enableDebuggingForTag:(NSInteger)tag;
+ (void)disableDebuggingForTag:(NSInteger)tag;
+ (BOOL)isDebuggingEnabledForView:(UIView *)view;

+ (void)enableBordering;
+ (void)disableBordering;
+ (BOOL)isBorderingEnabled;


@end

#endif  // TPL_ENABLE_DEBUGGING
