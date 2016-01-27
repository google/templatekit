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

#import "Internal/DescriptorImpls/TPLCompositeViewDescriptor.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/Core/TPLViewModel+Internal.h"
#import "Internal/DescriptorImpls/TPLColumnLayout.h"
#import "Internal/DescriptorImpls/TPLContextualSpaceSelector.h"
#import "Internal/DescriptorImpls/TPLLayerLayout.h"
#import "Internal/DescriptorImpls/TPLRowLayout.h"
#import "Internal/DescriptorImpls/TPLSpaceDescriptor.h"
#import "Public/Core/TPLSettings.h"
#import "Public/DescriptorImpls/TPLLayoutConfig.h"

static TPLCompositeLayoutCalculator LayoutCalculatorWithConfig(TPLLayoutConfig *config) {
  switch (config.layoutType) {
    case TPLLayoutTypeRow:
      return TPLRowLayoutCalculatorCreate();
    case TPLLayoutTypeColumn:
      return TPLColumnLayoutCalculatorCreate();
    case TPLLayoutTypeLayer:
      return TPLLayerLayoutCalculatorCreate();
    default:
      // Defaults to row.
      assert(NO);
      return TPLRowLayoutCalculatorCreate();
  }
}

static CGRect TPLRTLFrame(CGRect frame, CGRect containerBounds) {
  CGFloat rightMargin = CGRectGetWidth(containerBounds) - CGRectGetMaxX(frame);
  frame.origin.x = rightMargin;
  return frame;
}


@implementation TPLCompositeViewDescriptor

- (instancetype)init {
  self = [super init];
  if (self) {
    _subdescriptors = [[NSMutableArray alloc] init];
  }
  return self;
}

- (TPLContainerView *)uninitializedView {
  TPLContainerView *view = [[TPLContainerView alloc] init];
  for (TPLViewDescriptor *subdescriptor in _subdescriptors) {
    UIView *subview = [subdescriptor view];
    CHECK_NONNULL(subview.tpl_descriptor);
    [view addSubview:subview];
    [view.tpl_subviews addObject:subview];
  }
  return view;
}

- (void)populateView:(UIView *)view withViewModel:(TPLViewModel *)viewModel {
  [super populateView:view withViewModel:viewModel];

  TPLContainerView *containerView = DOWNCAST(view, TPLContainerView);
  NSInteger index = 0;
  for (TPLViewDescriptor *subdesc in _subdescriptors) {
    UIView *subview = containerView.tpl_subviews[index];
    [subdesc populateView:subview withViewModel:viewModel];
    ++index;
  }
}

- (BOOL)isViewHiddenWithViewModel:(TPLViewModel *)viewModel {
  if ([super isViewHiddenWithViewModel:viewModel]) {
    return YES;
  }

  for (TPLViewDescriptor *subdesc in self.subdescriptors) {
    if ([subdesc isKindOfClass:[TPLSpaceDescriptor class]]
        && !DOWNCAST(subdesc, TPLSpaceDescriptor).shouldAlwaysShow) {
      continue;
    }
    BOOL subviewHidden = [subdesc isViewHiddenWithViewModel:viewModel];
    if (!subviewHidden) {
      return NO;
    }
  }
  return YES;
}

- (CGSize)intrinsicViewSizeThatFits:(CGSize)size
                      withViewModel:(TPLViewModel *)viewModel {
  TPLCompositeLayoutCalculator layoutCalculator =
      LayoutCalculatorWithConfig([_layoutConfig objectWithViewModel:viewModel]);
  CGSize selfSize;
  layoutCalculator(self,
                   viewModel,
                   CGRectMake(0, 0, size.width, size.height),
                   NO,
                   &selfSize,
                   NULL);
  return selfSize;
}

- (void)layoutSubviewsInContainerView:(TPLContainerView *)containerView {
  TPLViewModel *viewModel = TPLViewModelWithView(containerView);
  TPLCompositeLayoutCalculator layoutCalculator =
      LayoutCalculatorWithConfig([_layoutConfig objectWithViewModel:viewModel]);
  CGRect bounds = containerView.bounds;
  CGRect subviewFrames[self.subdescriptors.count];
  layoutCalculator(self,
                   viewModel,
                   bounds,
                   YES,
                   NULL,
                   subviewFrames);
  BOOL isRTL = [TPLSettings isRTL];
  NSUInteger index = 0;
  for (UIView *subview in containerView.tpl_subviews) {
    if (isRTL && subview.tpl_descriptor.RTLEnabled) {
      subviewFrames[index] = TPLRTLFrame(subviewFrames[index], bounds);
    }
    subview.frame = subviewFrames[index];
    ++index;
  }
}

- (UIEdgeInsets)paddingWithViewModel:(TPLViewModel *)viewModel {
  return [_padding UIEdgeInsetsValueWithViewModel:viewModel];
}

- (void)addDescriptionToFormatter:(TPLViewDescriptorFormatter *)formatter {
  [super addDescriptionToFormatter:formatter];
  [formatter appendSubdescriptorDescriptionWithBlock:^{
    for (TPLViewDescriptor *subdesc in _subdescriptors) {
      [subdesc addDescriptionToFormatter:formatter];
      if (subdesc != _subdescriptors.lastObject) {
        [formatter wrap];
      }
    }
  }];
}

@end

