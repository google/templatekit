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

#import "Internal/DescriptorImpls/TPLLayerLayout.h"

#import "Internal/Core/TPLValueProvider.h"

#import <tgmath.h>

static CGPoint TPLLayerLayoutSubviewOrigin(CGSize subviewSize,
                                           CGRect containerBounds,
                                           TPLAlignment position) {
  CGFloat widthDelta = CGRectGetWidth(containerBounds) - subviewSize.width;
  CGFloat xOffset = 0;
  switch (position) {
    case TPLAlignmentLeft:
    case TPLAlignmentTopLeft:
    case TPLAlignmentBottomLeft:
      xOffset = 0;
      break;
    case TPLAlignmentRight:
    case TPLAlignmentTopRight:
    case TPLAlignmentBottomRight:
      xOffset = widthDelta;
      break;
    default:
      xOffset = floor(widthDelta / 2);
      break;
  }

  CGFloat heightDelta = CGRectGetHeight(containerBounds) - subviewSize.height;
  CGFloat yOffset = 0;
  switch (position) {
    case TPLAlignmentTop:
    case TPLAlignmentTopLeft:
    case TPLAlignmentTopRight:
      yOffset = 0;
      break;
    case TPLAlignmentBottom:
    case TPLAlignmentBottomLeft:
    case TPLAlignmentBottomRight:
      yOffset = heightDelta;
      break;
    default:
      yOffset = floor(heightDelta / 2);
      break;
  }

  CGPoint origin = CGPointMake(CGRectGetMinX(containerBounds) + xOffset,
                               CGRectGetMinY(containerBounds) + yOffset);
  return origin;
}

TPLCompositeLayoutCalculator TPLLayerLayoutCalculatorCreate() {
  static const CGFloat kVeryLargeDimention = 1000000;

  return ^(TPLCompositeViewDescriptor *compositeDescriptor,
           TPLViewModel *viewModel,
           CGRect bounds,
           BOOL shouldLayout,
           CGSize *selfSize,
           CGRect *subviewFrames) {
    NSArray *subdescriptors = compositeDescriptor.subdescriptors;

    UIEdgeInsets insets = [compositeDescriptor paddingWithViewModel:viewModel];
    CGRect containerBounds = UIEdgeInsetsInsetRect(bounds, insets);
    CGFloat containerWidth = CGRectGetWidth(containerBounds);
//    CGFloat containerHeight = CGRectGetHeight(containerBounds);

    CGSize unlimitedSize = CGSizeMake(CGRectGetWidth(containerBounds), kVeryLargeDimention);
    CGFloat maxWidth = 0;
    CGFloat maxHeight = 0;
    NSInteger index = 0;
    for (TPLViewDescriptor *subdesc in subdescriptors) {
      CGSize size = [subdesc viewSizeThatFits:unlimitedSize withViewModel:viewModel];
      if (size.width < containerWidth && subdesc.horizontalStretchEnabled) {
        size.width = containerWidth;
      }
      maxWidth = fmax(maxWidth, size.width);
      maxHeight = fmax(maxHeight, size.height);
      if (shouldLayout) {
        TPLAlignment position = [subdesc.position integerValueWithViewModel:viewModel];
        CGPoint origin = TPLLayerLayoutSubviewOrigin(size, containerBounds, position);
        subviewFrames[index] = (CGRect){.origin = origin, .size = size};
      }
      ++index;
    }

    if (!shouldLayout) {
      *selfSize = CGSizeMake(insets.left + maxWidth + insets.right,
                             insets.top + maxHeight + insets.bottom);
    }
  };
}
