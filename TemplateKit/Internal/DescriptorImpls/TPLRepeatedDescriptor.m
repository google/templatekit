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

#import "Internal/DescriptorImpls/TPLRepeatedDescriptor.h"

#import "Internal/Core/TPLValueProvider.h"
#import "Internal/Core/TPLViewModel+Internal.h"
#import "Internal/DescriptorImpls/TPLDataViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLDescriptorImplsMacros.h"


@implementation TPLRepeatedDescriptor

- (CGFloat)intervalWithViewModel:(TPLViewModel *)viewModel {
  return [_interval CGFloatValueWithViewModel:viewModel];
}

- (CGSize)intrinsicViewSizeThatFits:(CGSize)size
                      withViewModel:(TPLViewModel *)viewModel {
  NSArray *dataArray = [self dataArrayWithViewModel:viewModel];
  CGSize viewSize = CGSizeZero;
  switch (_direction) {
    case TPLDirectionHorizontal: {
      CGFloat totalWidth = 0;
      CGFloat maxHeight = 0;
      for (id data in dataArray) {
        CGSize subviewSize = [self.subdescriptor viewSizeThatFits:size withData:data];
        totalWidth += subviewSize.width;
        maxHeight = MAX(maxHeight, subviewSize.height);
      }
      totalWidth += [self intervalWithViewModel:viewModel] * (dataArray.count - 1);
      viewSize = CGSizeMake(totalWidth, maxHeight);
      break;
    }
    case TPLDirectionVertical: {
      CGFloat maxWidth = 0;
      CGFloat totalHeight = 0;
      for (id data in dataArray) {
        CGSize subviewSize = [self.subdescriptor viewSizeThatFits:size withData:data];
        maxWidth = MAX(maxWidth, subviewSize.width);
        totalHeight += subviewSize.height;
      }
      totalHeight += [self intervalWithViewModel:viewModel] * (dataArray.count - 1);
      viewSize = CGSizeMake(maxWidth, totalHeight);
      break;
    }
  }
  return viewSize;
}

- (void)layoutSubviewsInContainerView:(TPLContainerView *)containerView {
  TPLViewModel *viewModel = TPLViewModelWithView(containerView);
  CGRect remainingBounds = containerView.bounds;
  NSArray *dataArray = [self dataArrayWithViewModel:viewModel];
  CGFloat interval = [self intervalWithViewModel:viewModel];
  NSUInteger index = 0;
  for (id data in dataArray) {
    UIView *subview = containerView.tpl_subviews[index];
    CGSize size = [self.subdescriptor viewSizeThatFits:remainingBounds.size
                                              withData:data];
    size = CGSizeMake(TPL_CEIL(size.width), TPL_CEIL(size.height));
    switch (_direction) {
      case TPLDirectionHorizontal: {
        CGRect frame = CGRectMake(CGRectGetMinX(remainingBounds),
                                  CGRectGetMinY(remainingBounds),
                                  size.width,
                                  size.height);
        // TODO: Implement stretch and alignment.
        subview.frame = frame;
        remainingBounds.origin.x += (size.width + interval);
        remainingBounds.size.width -= (size.width + interval);
        break;
      }
      case TPLDirectionVertical: {
        CGRect frame = CGRectMake(CGRectGetMinX(remainingBounds),
                                  CGRectGetMinY(remainingBounds),
                                  size.width,
                                  size.height);
        if (subview.tpl_descriptor.horizontalStretchEnabled) {
          frame.size.width = CGRectGetWidth(remainingBounds);
        }
        // TODO: Implement alignment.
        subview.frame = frame;
        remainingBounds.origin.y += (size.height + interval);
        remainingBounds.size.height -= (size.height + interval);
        break;
      }
    }
    ++index;
  }
}

@end
