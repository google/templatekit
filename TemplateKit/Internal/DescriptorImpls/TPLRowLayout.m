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

#import "Internal/DescriptorImpls/TPLRowLayout.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/Core/TPLViewModel+Internal.h"
#import "Internal/DescriptorImpls/TPLContextualSpaceSelector.h"
#import "Internal/DescriptorImpls/TPLDescriptorImplsMacros.h"
#import "Internal/DescriptorImpls/TPLSpaceDescriptor.h"

typedef struct {
  CGFloat xShift;
  CGFloat yOffset;
  CGFloat width;
  CGFloat height;
  BOOL isHeightValid;
  BOOL isHidden;
} TPLRowLayoutOutput;

static const TPLRowLayoutOutput TPLRowLayoutOutputZero = {0.f, 0.f, 0.f, 0.f, NO, NO};
static const TPLRowLayoutOutput TPLRowLayoutOutputHidden = {0.f, 0.f, 0.f, 0.f, YES, YES};

static void ZeroFillRowLayoutOutputs(NSUInteger count, TPLRowLayoutOutput *outputs) {
  for (NSUInteger i = 0; i < count; ++i) {
    outputs[i] = TPLRowLayoutOutputZero;
  }
}

static void AdjustLayoutOutputsWithWidthExcess(CGFloat widthExcess,
                                               NSArray *subdescriptors,
                                               TPLRowLayoutOutput *outputs) {
  assert(widthExcess > 0);
  assert(subdescriptors.count > 0);

  // TODO: Implement max width after stretch and multiple stretchable subviews.
  NSUInteger index = subdescriptors.count - 1;
  for (TPLViewDescriptor *subdesc in [subdescriptors reverseObjectEnumerator]) {
    if (subdesc.horizontalStretchEnabled) {
      outputs[index].width += widthExcess;
      return;
    }
    --index;
  }

  // TODO: Implement horizontal alignment in the DSL.
  TPLAlignment horizontalAlignment = TPLAlignmentLeft;
  if (horizontalAlignment == TPLAlignmentCenter) {
    // TODO: Round the result correctly.
    outputs[0].xShift = floor(widthExcess / 2);
  } else if (horizontalAlignment == TPLAlignmentRight) {
    outputs[0].xShift = widthExcess;
  } else if (horizontalAlignment == TPLAlignmentJustify) {
    NSUInteger count = subdescriptors.count;
    if (count >= 2) {
      // TODO: Round the result correctly.
      CGFloat gap = floor(widthExcess / (count - 1));
      for (NSUInteger i = 1; i < count; ++i) {
        outputs[i].xShift = gap;
      }
    }
  }
}

static void AdjustLayoutOutputsWithWidthShortage(CGFloat widthShortage,
                                                 NSArray *subdescriptors,
                                                 TPLRowLayoutOutput *outputs) {
  assert(widthShortage > 0);

  // TODO: Implement min width after shrink.
  for (TPLViewDescriptor *subdesc in [subdescriptors reverseObjectEnumerator]) {
    if (subdesc.horizontalShrinkEnabled) {
      NSUInteger index = [subdescriptors indexOfObject:subdesc];
      outputs[index].isHeightValid = NO;
      CGFloat widthAdjusted = TPL_FMIN(widthShortage, outputs[index].width);
      outputs[index].width -= widthAdjusted;
      widthShortage -= widthAdjusted;
      if (widthShortage <= 0) {
        break;
      }
    }
  }
}

static void AdjustLayoutOutputWithContainerHeight(CGFloat containerHeight,
                                                  TPLViewDescriptor *subdescriptor,
                                                  TPLViewModel *viewModel,
                                                  TPLAlignment defaultAlignment,
                                                  TPLRowLayoutOutput *output) {
  if ((output->height < containerHeight && subdescriptor.verticalStretchEnabled)
      || (output->height > containerHeight && subdescriptor.verticalShrinkEnabled)) {
    output->height = containerHeight;
    return;
  }

  TPLAlignment alignment = defaultAlignment;
  if (subdescriptor.position) {
    alignment = [subdescriptor.position integerValueWithViewModel:viewModel];
  }
  CGFloat heightDelta = containerHeight - output->height;
  switch (alignment) {
    case TPLAlignmentTop:
    case TPLAlignmentTopLeft:
    case TPLAlignmentTopRight:
      output->yOffset = 0;
      break;
    case TPLAlignmentBottom:
    case TPLAlignmentBottomLeft:
    case TPLAlignmentBottomRight:
      output->yOffset = heightDelta;
      break;
    case TPLAlignmentCenter:
      output->yOffset = floor(heightDelta / 2);
      break;
    default:
      output->yOffset = 0;
  }
}

TPLCompositeLayoutCalculator TPLRowLayoutCalculatorCreate() {
  static const CGFloat kVeryLargeDimention = 1000000.f;

  return ^(TPLCompositeViewDescriptor *compositeDescriptor,
           TPLViewModel *viewModel,
           CGRect bounds,
           BOOL shouldLayout,
           CGSize *selfSize,
           CGRect *subviewFrames) {
    NSArray *subdescriptors = compositeDescriptor.subdescriptors;
    NSUInteger subviewCount = subdescriptors.count;
    TPLRowLayoutOutput layoutOutputs[subviewCount];
    ZeroFillRowLayoutOutputs(subviewCount, layoutOutputs);

    UIEdgeInsets insets = [compositeDescriptor paddingWithViewModel:viewModel];
    CGRect effectiveBounds = UIEdgeInsetsInsetRect(bounds, insets);

    // First pass. Calculate intrinsic sizes of subviews.
    NSUInteger index = 0;
    CGFloat totalWidth = 0.f;
    CGSize unlimitedSize = CGSizeMake(kVeryLargeDimention, kVeryLargeDimention);
    TPLContextualSpaceSelectorRef spaceSelector = TPLContextualSpaceSelectorCreate(subviewCount);
    for (TPLViewDescriptor *subdesc in subdescriptors) {
      BOOL isHidden = [subdesc isViewHiddenWithViewModel:viewModel];
      TPLRowLayoutOutput *output = &layoutOutputs[index];
      if (isHidden) {
        *output = TPLRowLayoutOutputHidden;
      } else {
        CGSize size = [subdesc viewSizeThatFits:unlimitedSize
                                  withViewModel:viewModel];
        output->width = size.width;
        output->height = size.height;
        output->isHeightValid = YES;
        totalWidth += size.width;
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
      layoutOutputs[spaceIndex] = TPLRowLayoutOutputHidden;
    }
    TPLContextualSpaceSelectorDelete(spaceSelector);

    // Second pass.
    CGFloat widthDelta = CGRectGetWidth(effectiveBounds) - totalWidth;
    if (widthDelta > 0) {
      if (shouldLayout) {
        AdjustLayoutOutputsWithWidthExcess(widthDelta,
                                           subdescriptors,
                                           layoutOutputs);
      }
    } else if (widthDelta < 0) {
      AdjustLayoutOutputsWithWidthShortage(-widthDelta,
                                           subdescriptors,
                                           layoutOutputs);
    }

    index = 0;
    CGFloat maxHeight = 0.f;
    for (TPLViewDescriptor *subdesc in subdescriptors) {
      if (!layoutOutputs[index].isHeightValid) {
        CGSize size = [subdesc viewSizeThatFits:CGSizeMake(layoutOutputs[index].width,
                                                           kVeryLargeDimention)
                                  withViewModel:viewModel];
        layoutOutputs[index].height = size.height;
      }
      maxHeight = TPL_FMAX(maxHeight, layoutOutputs[index].height);
      ++index;
    }

    CGFloat x = CGRectGetMinX(effectiveBounds);
    CGFloat y = CGRectGetMinY(effectiveBounds);
    CGFloat containerHeight = shouldLayout ? CGRectGetHeight(effectiveBounds) : maxHeight;
    TPLAlignment defaultVerticalAlignment = TPLAlignmentCenter;
    index = 0;
    for (TPLViewDescriptor *subdesc in subdescriptors) {
      TPLRowLayoutOutput output = layoutOutputs[index];
      if (output.isHidden) {
        if (shouldLayout) {
          subviewFrames[index] = CGRectZero;
        }
        x += (output.xShift + output.width);
      } else {
        AdjustLayoutOutputWithContainerHeight(containerHeight,
                                              subdesc,
                                              viewModel,
                                              defaultVerticalAlignment,
                                              &output);
        x += output.xShift;
        if (shouldLayout) {
          subviewFrames[index] = CGRectMake(x, y + output.yOffset, output.width, output.height);
        }
        x += output.width;
      }
      ++index;
    }

    if (!shouldLayout) {
      *selfSize = CGSizeMake(x - CGRectGetMinX(bounds) + insets.right,
                             insets.top + maxHeight + insets.bottom);
    }
  };
}
