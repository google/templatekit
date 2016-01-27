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

#import "Internal/DescriptorImpls/TPLColumnLayout.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/Core/TPLViewModel+Internal.h"
#import "Internal/DescriptorImpls/TPLContextualSpaceSelector.h"
#import "Internal/DescriptorImpls/TPLDescriptorImplsMacros.h"
#import "Internal/DescriptorImpls/TPLSpaceDescriptor.h"
#import "Public/Core/TPLSettings.h"

typedef struct {
  CGFloat yShift;
  CGFloat xOffset;
  CGFloat width;
  CGFloat height;
  BOOL isHidden;
} TPLColumnLayoutOutput;

static const TPLColumnLayoutOutput TPLColumnLayoutOutputZero = {0.f, 0.f, 0.f, 0.f, NO};
static const TPLColumnLayoutOutput TPLColumnLayoutOutputHidden = {0.f, 0.f, 0.f, 0.f, YES};

static void ZeroFillColumnLayoutOutputs(NSUInteger count, TPLColumnLayoutOutput *outputs) {
  for (NSUInteger i = 0; i < count; ++i) {
    outputs[i] = TPLColumnLayoutOutputZero;
  }
}

static void AdjustLayoutOutputsWithHeightExcess(CGFloat heightExcess,
                                                NSArray *subdescriptors,
                                                TPLColumnLayoutOutput *outputs) {
  assert(heightExcess > 0);
  assert(subdescriptors.count > 0);

  // TODO: Implement max height after stretch and multiple stretchable subviews.
  NSUInteger index = subdescriptors.count - 1;
  for (TPLViewDescriptor *subdesc in [subdescriptors reverseObjectEnumerator]) {
    if (subdesc.verticalStretchEnabled) {
      outputs[index].height += heightExcess;
      return;
    }
    --index;
  }

  // TODO: Implement vertical alignment in the DSL.
  TPLAlignment verticalAlignment = TPLAlignmentTop;
  if (verticalAlignment == TPLAlignmentCenter) {
    // TODO: Round the result correctly.
    outputs[0].yShift = floor(heightExcess / 2);
  } else if (verticalAlignment == TPLAlignmentBottom) {
    outputs[0].yShift = heightExcess;
  } else if (verticalAlignment == TPLAlignmentJustify) {
    NSUInteger count = subdescriptors.count;
    if (count >= 2) {
      // TODO: Round the result correctly.
      CGFloat gap = floor(heightExcess / (count - 1));
      for (NSUInteger i = 1; i < count; ++i) {
        outputs[i].yShift = gap;
      }
    }
  }
}

static void AdjustLayoutOutputsWithHeightShortage(CGFloat heightShortage,
                                                  NSArray *subdescriptors,
                                                  TPLColumnLayoutOutput *outputs) {
  assert(heightShortage > 0);

  // TODO: Implement min height after shrink.
  for (TPLViewDescriptor *subdesc in [subdescriptors reverseObjectEnumerator]) {
    if (subdesc.verticalShrinkEnabled) {
      NSUInteger index = [subdescriptors indexOfObject:subdesc];
      CGFloat heightAdjusted = TPL_FMIN(heightShortage, outputs[index].height);
      outputs[index].height -= heightAdjusted;
      heightShortage -= heightAdjusted;
      if (heightShortage <= 0) {
        break;
      }
    }
  }
}

static void AdjustLayoutOutputWithContainerWidth(CGFloat containerWidth,
                                                 TPLViewDescriptor *subdescriptor,
                                                 TPLViewModel *viewModel,
                                                 TPLAlignment defaultAlignment,
                                                 TPLColumnLayoutOutput *output) {
  if ((output->width < containerWidth && subdescriptor.horizontalStretchEnabled)
      || (output->width > containerWidth && subdescriptor.horizontalShrinkEnabled)) {
    output->width = containerWidth;
    return;
  }

  TPLAlignment alignment = defaultAlignment;
  if (subdescriptor.position) {
    alignment = [subdescriptor.position integerValueWithViewModel:viewModel];
  }
  CGFloat widthDelta = containerWidth - output->width;
  switch (alignment) {
    case TPLAlignmentLeft:
    case TPLAlignmentTopLeft:
    case TPLAlignmentBottomLeft:
      output->xOffset = 0;
      break;
    case TPLAlignmentRight:
    case TPLAlignmentTopRight:
    case TPLAlignmentBottomRight:
      output->xOffset = widthDelta;
      break;
    case TPLAlignmentCenter:
      output->xOffset = floor(widthDelta / 2);
      break;
    default:
      output->xOffset = 0;
      break;
  }
}

TPLCompositeLayoutCalculator TPLColumnLayoutCalculatorCreate() {
  static const CGFloat kVeryLargeDimention = 1000000.f;

  return ^(TPLCompositeViewDescriptor *compositeDescriptor,
           TPLViewModel *viewModel,
           CGRect bounds,
           BOOL shouldLayout,
           CGSize *selfSize,
           CGRect *subviewFrames) {
    assert(!shouldLayout || subviewFrames != NULL);
    assert(shouldLayout || selfSize != NULL);

    NSArray *subdescriptors = compositeDescriptor.subdescriptors;
    NSUInteger subviewCount = subdescriptors.count;
    TPLColumnLayoutOutput layoutOutputs[subviewCount];
    ZeroFillColumnLayoutOutputs(subviewCount, layoutOutputs);

    UIEdgeInsets insets = [compositeDescriptor paddingWithViewModel:viewModel];
    CGRect effectiveBounds = UIEdgeInsetsInsetRect(bounds, insets);

    // First pass. Calculate intrinsic sizes of subviews.
    NSUInteger index = 0;
    CGFloat maxWidth = 0.f;
    CGFloat totalHeight = 0.f;
    CGSize unlimitedSize = CGSizeMake(CGRectGetWidth(effectiveBounds), kVeryLargeDimention);
    TPLContextualSpaceSelectorRef spaceSelector = TPLContextualSpaceSelectorCreate(subviewCount);
    for (TPLViewDescriptor *subdesc in subdescriptors) {
      BOOL isHidden = [subdesc isViewHiddenWithViewModel:viewModel];
      TPLColumnLayoutOutput *output = &layoutOutputs[index];
      if (isHidden) {
        *output = TPLColumnLayoutOutputHidden;
      } else {
        CGSize size = [subdesc viewSizeThatFits:unlimitedSize withViewModel:viewModel];
        output->width = size.width;
        output->height = size.height;
        maxWidth = TPL_FMAX(maxWidth, size.width);
        totalHeight += size.height;
      }
      if ([subdesc isKindOfClass:[TPLSpaceDescriptor class]]
          && !DOWNCAST(subdesc, TPLSpaceDescriptor).shouldAlwaysShow) {
        TPLContextualSpaceSelectorAddContextualSpace(spaceSelector);
      } else {
        TPLContextualSpaceSelectorAddView(spaceSelector, isHidden);
      }
      ++index;
    }
    for (NSInteger i = 0;
         i < TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(spaceSelector);
         ++i) {
      NSInteger spaceIndex = TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(spaceSelector)[i];
      layoutOutputs[spaceIndex] = TPLColumnLayoutOutputHidden;
    }
    TPLContextualSpaceSelectorDelete(spaceSelector);

    // Second pass.
    CGFloat heightDelta = CGRectGetHeight(effectiveBounds) - totalHeight;
    if (heightDelta > 0) {
      if (shouldLayout) {
        AdjustLayoutOutputsWithHeightExcess(heightDelta,
                                            subdescriptors,
                                            layoutOutputs);
      }
    } else if (heightDelta < 0) {
      AdjustLayoutOutputsWithHeightShortage(-heightDelta,
                                            subdescriptors,
                                            layoutOutputs);
    }

    CGFloat x = CGRectGetMinX(effectiveBounds);
    CGFloat y = CGRectGetMinY(effectiveBounds);
    CGFloat containerWidth = shouldLayout ? CGRectGetWidth(effectiveBounds) : maxWidth;
    TPLAlignment defaultAlignment =
        [compositeDescriptor.subviewAlignment integerValueWithViewModel:viewModel];
    index = 0;
    for (TPLViewDescriptor *subdesc in subdescriptors) {
      TPLColumnLayoutOutput output = layoutOutputs[index];
      if (output.isHidden) {
        if (shouldLayout) {
          subviewFrames[index] = CGRectZero;
        }
        y += (output.yShift + output.height);
      } else {
        AdjustLayoutOutputWithContainerWidth(containerWidth,
                                             subdesc,
                                             viewModel,
                                             defaultAlignment,
                                             &output);
        y += output.yShift;
        if (shouldLayout) {
          subviewFrames[index] = CGRectMake(x + output.xOffset, y, output.width, output.height);
        }
        y += output.height;
      }
      ++index;
    }

    if (!shouldLayout) {
      *selfSize = CGSizeMake(insets.left + maxWidth + insets.right,
                             y - CGRectGetMinY(bounds) + insets.bottom);
    }
  };
}
