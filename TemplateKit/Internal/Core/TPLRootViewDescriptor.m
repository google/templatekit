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

#import "Internal/Core/TPLRootViewDescriptor.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLRootView+Internal.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/Core/TPLViewModel+Internal.h"


@implementation TPLRootViewDescriptor

- (instancetype)init {
  self = [super init];
  if (self) {
    _viewClass = [TPLRootView class];
  }
  return self;
}

- (UIView *)uninitializedView {
  return [[_viewClass alloc] init];
}

- (void)populateView:(UIView *)view withViewModel:(TPLViewModel *)viewModel {
  TPLRootView *rootView = DOWNCAST(view, TPLRootView);
  if (_submodel) {
    // This is the root of a subtree.
    TPLViewModel *submodel = [self submodelWithViewModel:viewModel];
    rootView->_viewModel = submodel;
  }

  [super populateView:view withViewModel:viewModel];

  if (!rootView.contentView) {
    rootView.contentView = [_subdescriptor view];
  }
  if (_submodel) {
    // This is the root of a subtree.
    TPLViewModel *submodel = [self submodelWithViewModel:viewModel];
    [_subdescriptor populateView:rootView.contentView withViewModel:submodel];
  } else {
    // This is the root of the entire tree that might be comprised of more than one subtree.
    [_subdescriptor populateView:rootView.contentView withViewModel:viewModel];
  }
}

- (CGSize)intrinsicViewSizeThatFits:(CGSize)size
                      withViewModel:(TPLViewModel *)viewModel {
  if (_submodel) {
    // This is the root of a subtree.
    TPLViewModel *submodel = [self submodelWithViewModel:viewModel];
    return [_subdescriptor viewSizeThatFits:size withViewModel:submodel];
  } else {
    // This is the root of the entire tree that might be comprised of more than one subtree.
    return [_subdescriptor viewSizeThatFits:size withViewModel:viewModel];
  }
}

- (TPLViewModel *)submodelWithViewModel:(TPLViewModel *)viewModel {
  return [_submodel objectWithViewModel:viewModel];
}

- (void)setData:(id)data toView:(UIView *)view {
  // This must NOT be the root of the entire tree that might be comprised of more than one subtree.
  assert(_submodel);
  TPLRootView *rootView = DOWNCAST(view, TPLRootView);
  rootView.contentView = [_subdescriptor view];
  rootView->_viewModel = DOWNCAST(data, TPLViewModel);
  [_subdescriptor populateView:rootView.contentView
                 withViewModel:DOWNCAST(data, TPLViewModel)];
}

- (CGSize)viewSizeThatFits:(CGSize)size withData:(id)data {
  // This must NOT be the root of the entire tree that might be comprised of more than one subtree.
  assert(_submodel);
  // TODO: I think this method should be called on self.
  return [_subdescriptor viewSizeThatFits:size withViewModel:DOWNCAST(data, TPLViewModel)];
}

- (id)dataWithViewModel:(TPLViewModel *)viewModel {
  // This must NOT be the root of the entire tree that might be comprised of more than one subtree.
  assert(_submodel);
  return [self submodelWithViewModel:viewModel];
}

@end
