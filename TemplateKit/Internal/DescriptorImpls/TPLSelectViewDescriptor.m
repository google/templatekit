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

#import "Internal/DescriptorImpls/TPLSelectViewDescriptor.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/DescriptorImpls/TPLDescriptorImplsMacros.h"

typedef UIView *(^TPLCreateSubviewBlock)(id key);


@interface TPLSelectView : UIView

- (instancetype)initWithCreateSubviewBlock:(TPLCreateSubviewBlock)createBlock;

- (UIView *)selectedSubview;

- (void)selectSubviewForKey:(id)key;

@end


@implementation TPLSelectView {
  id _selectedSubviewKey;
  TPLCreateSubviewBlock _createSubviewBlock;
  NSMutableDictionary *_cachedSubviews;  // From subview key (id) to subview (UIView).
}

- (instancetype)initWithCreateSubviewBlock:(TPLCreateSubviewBlock)createBlock {
  self = [super init];
  if (self) {
    _selectedSubviewKey = nil;
    _createSubviewBlock = [createBlock copy];
    _cachedSubviews = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (UIView *)selectedSubview {
  assert(_selectedSubviewKey && _cachedSubviews[_selectedSubviewKey]);
  return _cachedSubviews[_selectedSubviewKey];
}

- (void)selectSubviewForKey:(id)key {
  if ([key isEqual:_selectedSubviewKey]) {
    return;
  }

  if (_selectedSubviewKey) {
    [[self selectedSubview] removeFromSuperview];
  }

  if (!_cachedSubviews[key]) {
    UIView *newView = _createSubviewBlock(key);
    // TODO: What is the right value for autoresizingMask?
    newView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _cachedSubviews[key] = newView;
  }
  UIView *selectedSubview = _cachedSubviews[key];
  // TODO: What is the right value for frame?
  selectedSubview.frame = self.bounds;
  [self addSubview:selectedSubview];
  _selectedSubviewKey = key;
}

@end


@implementation TPLBinarySelectViewDescriptor

- (UIView *)uninitializedView {
  // TODO: Any risk of retain cycle?
  TPLCreateSubviewBlock createSubviewBlock = ^(id key) {
    if ([key isEqual:@YES]) {
      return [self.thenDescriptor view];
    } else if ([key isEqual:@NO]) {
      return [self.elseDescriptor view];
    } else {
      assert(false);
      return (UIView *)nil;
    }
  };
  TPLSelectView *selectView = [[TPLSelectView alloc] initWithCreateSubviewBlock:createSubviewBlock];
  return selectView;
}

- (void)populateView:(UIView *)view withViewModel:(TPLViewModel *)viewModel {
  [super populateView:view withViewModel:viewModel];

  TPLSelectView *selectView = DOWNCAST(view, TPLSelectView);
  BOOL condition = [self conditionWithViewModel:viewModel];
  if (condition) {
    [selectView selectSubviewForKey:@YES];
    [_thenDescriptor populateView:[selectView selectedSubview] withViewModel:viewModel];
  } else {
    [selectView selectSubviewForKey:@NO];
    [_elseDescriptor populateView:[selectView selectedSubview] withViewModel:viewModel];
  }
}

- (CGSize)intrinsicViewSizeThatFits:(CGSize)size
                      withViewModel:(TPLViewModel *)viewModel {
  BOOL condition = [self conditionWithViewModel:viewModel];
  TPLViewDescriptor *activeDescriptor = condition ? _thenDescriptor : _elseDescriptor;
  return [activeDescriptor viewSizeThatFits:size
                              withViewModel:viewModel];
}

- (void)addDescriptionToFormatter:(TPLViewDescriptorFormatter *)formatter {
  [super addDescriptionToFormatter:formatter];
  [formatter appendSubdescriptorDescriptionWithBlock:^{
    [_thenDescriptor addDescriptionToFormatter:formatter];
    [formatter wrap];
    [_elseDescriptor addDescriptionToFormatter:formatter];
  }];
}

- (BOOL)conditionWithViewModel:(TPLViewModel *)viewModel {
  return [_condition boolValueWithViewModel:viewModel];
}

@end
