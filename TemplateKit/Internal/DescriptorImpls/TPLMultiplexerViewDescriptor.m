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

#import "Internal/DescriptorImpls/TPLMultiplexerViewDescriptor.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/DescriptorImpls/TPLDataViewDescriptor.h"


@implementation TPLMultiplexerViewDescriptor

- (UIView *)uninitializedView {
  return [[TPLContainerView alloc] init];
}

- (void)populateView:(UIView *)view withViewModel:(TPLViewModel *)viewModel {
  [super populateView:view withViewModel:viewModel];

  TPLContainerView *containerView = DOWNCAST(view, TPLContainerView);
  [containerView removeAllSubviews];

  NSArray *dataArray = [self dataArrayWithViewModel:viewModel];
  for (id data in dataArray) {
    UIView *subview = [self.subdescriptor view];
    CHECK_NONNULL(subview.tpl_descriptor);
    [self.subdescriptor setData:data toView:subview];
    [containerView addSubview:subview];
    [containerView.tpl_subviews addObject:subview];
  }
}

- (BOOL)isViewHiddenWithViewModel:(TPLViewModel *)viewModel {
  if ([super isViewHiddenWithViewModel:viewModel]) {
    return YES;
  }

  NSArray *dataArray = [self dataArrayWithViewModel:viewModel];
  if (!dataArray.count) {
    return YES;
  }
  // TODO: Call -isViewHiddenWithViewModel: with data items in the array and return YES if
  // all of those return YES.
  return NO;
}

- (void)layoutSubviewsInContainerView:(TPLContainerView *)containerView {
  [self doesNotRecognizeSelector:_cmd];
}

- (NSArray *)dataArrayWithViewModel:(TPLViewModel *)viewModel {
  id data = [self.subdescriptor dataWithViewModel:viewModel];
  return DOWNCAST(data, NSArray);
}

- (void)addDescriptionToFormatter:(TPLViewDescriptorFormatter *)formatter {
  [super addDescriptionToFormatter:formatter];
  [formatter appendSubdescriptorDescriptionWithBlock:^{
    [_subdescriptor addDescriptionToFormatter:formatter];
  }];
}

@end
