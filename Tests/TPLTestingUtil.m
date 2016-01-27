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

#import "TPLTestingUtil.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/DescriptorImpls/TPLContainerViewDescriptor.h"
#import "Public/Core/TPLUtils.h"

UIView *FindSubview(TPLContainerView *rootView, TPLViewDescriptor *descriptor) {
  NSMutableArray *pendingViews = [[NSMutableArray alloc] init];
  [pendingViews addObject:rootView];
  while (pendingViews.count) {
    UIView *view = pendingViews.firstObject;
    [pendingViews removeObjectAtIndex:0];
    if (view.tpl_descriptor == descriptor) {
      return view;
    }
    if ([view isKindOfClass:[TPLContainerView class]]) {
      TPLContainerView *container = DOWNCAST(view, TPLContainerView);
      [pendingViews addObjectsFromArray:container.tpl_subviews];
    }
  }
  return nil;
}

MockViewDescriptor *CreateMockViewDescriptor(CGFloat width, CGFloat height) {
  return [[MockViewDescriptor alloc] initWithIntrinsicSize:CGSizeMake(width, height)];
}

@implementation MockViewDescriptor {
  CGSize _intrinsicSize;
}

- (instancetype)initWithIntrinsicSize:(CGSize)size {
  self = [super init];
  if (self) {
    _intrinsicSize = size;
  }
  return self;
}

- (UIView *)uninitializedView {
  return [[UIView alloc] init];
}

- (CGSize)intrinsicViewSizeThatFits:(CGSize)size withViewModel:(TPLViewModel *)viewModel {
  return _intrinsicSize;
}

@end

@implementation MockHeightAdjustingViewDescriptor

- (instancetype)initWithDefaultSize:(CGSize)defaultSize adjustedHeight:(CGFloat)adjustedHeight {
  self = [super init];
  if (self) {
    _defaultSize = defaultSize;
    _adjustedHeight = adjustedHeight;
  }
  return self;
}

- (UIView *)uninitializedView {
  return [[UIView alloc] init];
}

- (CGSize)intrinsicViewSizeThatFits:(CGSize)size withViewModel:(TPLViewModel *)viewModel {
  if (size.width >= _defaultSize.width) {
    return _defaultSize;
  } else {
    return CGSizeMake(size.width, _adjustedHeight);
  }
}

@end
