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

#import "ActivityIndicatorExample.h"

#import "TemplateKit.h"


@implementation ActivityIndicatorExampleViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    _activityIndicator0 = [[TPLActivityIndicatorData alloc] init];
    _activityIndicator0.style = UIActivityIndicatorViewStyleWhite;
    _activityIndicator0.animating = YES;
    _activityIndicator0.hidesWhenStopped = NO;

    _activityIndicator1 = [[TPLActivityIndicatorData alloc] init];
    _activityIndicator1.style = UIActivityIndicatorViewStyleGray;
    _activityIndicator1.animating = YES;
    _activityIndicator1.hidesWhenStopped = NO;

    _activityIndicator2 = [[TPLActivityIndicatorData alloc] init];
    _activityIndicator2.style = UIActivityIndicatorViewStyleWhiteLarge;
    _activityIndicator2.animating = NO;
    _activityIndicator2.hidesWhenStopped = NO;
  }
  return self;
}

- (BOOL)handleEvent:(TPLEvent *)event {
  UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)event.view;
  if (indicator.isAnimating) {
    [indicator stopAnimating];
  } else {
    [indicator startAnimating];
  }
  return YES;
}

@end


@implementation ActivityIndicatorExampleView
@end


TPL_DEFINE_VIEW_TEMPLATE(activity_indicator_example, ActivityIndicatorExampleView) {
  return column(activity_indicator($(activityIndicator0))
                  .tappable(),
                activity_indicator($(activityIndicator1))
                  .tappable(),
                activity_indicator($(activityIndicator2))
                  .tappable(),
                nil);
}
