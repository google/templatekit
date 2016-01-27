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

#import "Internal/DescriptorImpls/TPLActivityIndicatorDescriptor.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Public/DescriptorImpls/TPLActivityIndicatorData.h"

static CGSize g_TPLActivityIndicatorSizeGray;
static CGSize g_TPLActivityIndicatorSizeWhite;
static CGSize g_TPLActivityIndicatorSizeWhiteLarge;

@implementation TPLActivityIndicatorData

- (instancetype)init {
  self = [super init];
  if (self) {
    _hidesWhenStopped = YES;
  }
  return self;
}

@end


@implementation TPLActivityIndicatorDescriptor

- (UIView *)uninitializedView {
  return [[UIActivityIndicatorView alloc]
             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}

- (void)setData:(id)data toView:(UIView *)view {
  UIActivityIndicatorView *indicator = DOWNCAST(view, UIActivityIndicatorView);
  TPLActivityIndicatorData *indicatorData = DOWNCAST(data, TPLActivityIndicatorData);
  indicator.activityIndicatorViewStyle = indicatorData.style;
  indicator.hidesWhenStopped = indicatorData.hidesWhenStopped;
  if (indicatorData.animating) {
    [indicator startAnimating];
  } else {
    [indicator stopAnimating];
  }
}

- (CGSize)viewSizeThatFits:(CGSize)size withData:(id)data {
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [indicator sizeToFit];
    g_TPLActivityIndicatorSizeGray = indicator.bounds.size;

    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [indicator sizeToFit];
    g_TPLActivityIndicatorSizeWhite = indicator.bounds.size;

    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator sizeToFit];
    g_TPLActivityIndicatorSizeWhiteLarge = indicator.bounds.size;
  });

  switch (DOWNCAST(data, TPLActivityIndicatorData).style) {
    case UIActivityIndicatorViewStyleGray:
      return g_TPLActivityIndicatorSizeGray;
    case UIActivityIndicatorViewStyleWhite:
      return g_TPLActivityIndicatorSizeWhite;
    case UIActivityIndicatorViewStyleWhiteLarge:
      return g_TPLActivityIndicatorSizeWhiteLarge;
  }
}

@end
