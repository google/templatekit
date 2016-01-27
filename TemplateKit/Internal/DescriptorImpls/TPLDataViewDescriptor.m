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

#import "Internal/DescriptorImpls/TPLDataViewDescriptor.h"

#import "Internal/Core/TPLValueProvider.h"
#import "Internal/Core/TPLViewModel+Internal.h"


@implementation TPLDataViewDescriptor

- (void)setData:(id)data toView:(UIView *)view {
  [self doesNotRecognizeSelector:_cmd];
}

- (CGSize)viewSizeThatFits:(CGSize)size withData:(id)data {
  [self doesNotRecognizeSelector:_cmd];
  return CGSizeZero;
}

- (void)populateView:(UIView *)view withViewModel:(TPLViewModel *)viewModel {
  [super populateView:view withViewModel:viewModel];

  id data = [self dataWithViewModel:viewModel];
  [self setData:data toView:view];
}

- (CGSize)intrinsicViewSizeThatFits:(CGSize)size
                      withViewModel:(TPLViewModel *)viewModel {
  id data = [self dataWithViewModel:viewModel];
  return [self viewSizeThatFits:size withData:data];
}

- (BOOL)isViewHiddenWithViewModel:(TPLViewModel *)viewModel {
  if ([super isViewHiddenWithViewModel:viewModel]) {
    return YES;
  }
  id data = [self dataWithViewModel:viewModel];
  if (!data) {
    return YES;
  }
  return [self isViewHiddenWithData:data];
}

- (BOOL)isViewHiddenWithData:(id)data {
  return NO;
}

- (id)dataWithViewModel:(TPLViewModel *)viewModel {
  return [_data objectWithViewModel:viewModel];
}

@end
