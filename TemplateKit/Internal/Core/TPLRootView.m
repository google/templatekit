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

#import "Internal/Core/TPLRootView+Internal.h"

#import "Internal/Core/TPLBenchmark.h"
#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLViewDescriptor.h"


@implementation TPLRootView

- (CGSize)sizeThatFits:(CGSize)size {
  CGSize result = CGSizeZero;
  TPL_BENCHMARK(1, size_calculation, self) {
    result = [_contentView.tpl_descriptor viewSizeThatFits:size
                                             withViewModel:_viewModel];
  }
  return result;
}

- (void)setContentView:(UIView *)contentView {
  if (_contentView) {
    [_contentView removeFromSuperview];
    _contentView = nil;
  }
  _contentView = contentView;
  _contentView.frame = self.bounds;
  _contentView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:_contentView];
}

- (void)setViewModel:(TPLViewModel *)viewModel {
  TPL_BENCHMARK(1, view_population, self) {
    _viewModel = viewModel;
    [self.tpl_descriptor populateView:self withViewModel:_viewModel];
  }
}

@end

TPLRootView *TPLRootViewWithView(UIView *view) {
  UIView *current = [view superview];
  while (current) {
    if ([current isKindOfClass:[TPLRootView class]]) {
      return DOWNCAST(current, TPLRootView);
    }
    current = [current superview];
  }
  return nil;
}
