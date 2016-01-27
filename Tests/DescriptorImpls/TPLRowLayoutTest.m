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

#import <XCTest/XCTest.h>

#import "Internal/Core/TPLValueProvider.h"
#import "Internal/DescriptorImpls/TPLContainerViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLRowLayout.h"
#import "Internal/DescriptorImpls/TPLSpaceDescriptor.h"
#import "Public/Core/TPLUtils.h"
#import "TPLTestingUtil.h"

static TPLCompositeViewDescriptor *CreateRowDescriptor(NSArray *subdescriptors) {
  TPLCompositeViewDescriptor *row = [[TPLCompositeViewDescriptor alloc] init];
  [row.subdescriptors addObjectsFromArray:subdescriptors];
  return row;
}

static TPLSpaceDescriptor *CreateContextualSpaceDescriptor(CGFloat width) {
  TPLSpaceDescriptor *space = [TPLSpaceDescriptor descriptor];
  space.direction = TPLDirectionHorizontal;
  space.length = @(width);
  space.shouldAlwaysShow = NO;
  return space;
}

static TPLValueProvider *CreateProviderWithAlignment(TPLAlignment alignment) {
  return [TPLValueProvider providerWithConstant:@(alignment)];
}

@interface TPLRowLayoutTestBase : XCTestCase
@end

@implementation TPLRowLayoutTestBase
@end


@interface TPLRowLayoutOnePlainSubviewTest : TPLRowLayoutTestBase
@end

@implementation TPLRowLayoutOnePlainSubviewTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockViewDescriptor *_subdesc;
  TPLCompositeViewDescriptor *_desc;
  CGSize _selfSize;
  CGRect _subviewFrames[1];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLRowLayoutCalculatorCreate();
  _subdesc = CreateMockViewDescriptor(20, 20);
  _desc = CreateRowDescriptor(@[ _subdesc ]);
}

- (void)testJustEnoughWidth {
  CGRect bounds = CGRectMake(0, 0, 20, 20);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
}

- (void)testMoreThanEnoughWidth {
  CGRect bounds = CGRectMake(0, 0, 40, 20);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
}

- (void)testLessThanEnoughWidth {
  CGRect bounds = CGRectMake(0, 0, 10, 20);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
}

- (void)testHidden {
  _subdesc.hidden = [TPLValueProvider providerWithConstant:@YES];
  CGRect bounds = CGRectMake(0, 0, 30, 20);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 0, 0);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 0, 0);
}

@end


@interface TPLRowLayoutMultiplePlainSubviewsTest : TPLRowLayoutTestBase
@end

@implementation TPLRowLayoutMultiplePlainSubviewsTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockViewDescriptor *_subdesc0, *_subdesc1, *_subdesc2;
  TPLCompositeViewDescriptor *_desc;
  CGSize _selfSize;
  CGRect _subviewFrames[3];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLRowLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(20, 20);
  _subdesc1 = CreateMockViewDescriptor(20, 20);
  _subdesc2 = CreateMockViewDescriptor(20, 20);
  _desc = CreateRowDescriptor(@[ _subdesc0, _subdesc1, _subdesc2 ]);
}

- (void)testJustEnoughWidth {
  CGRect bounds = CGRectMake(0, 0, 60, 20);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 60, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 40, 0, 20, 20);
}

- (void)testMoreThanEnoughWidth {
  CGRect bounds = CGRectMake(0, 0, 70, 20);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 60, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 40, 0, 20, 20);
}

- (void)testLessThanEnoughWidth {
  CGRect bounds = CGRectMake(0, 0, 50, 20);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 60, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 40, 0, 20, 20);
}

- (void)testHidden {
  _subdesc1.hidden = [TPLValueProvider providerWithConstant:@YES];
  CGRect bounds = CGRectMake(0, 0, 30, 20);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 0, 0, 0);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 20, 0, 20, 20);
}

@end


@interface TPLRowLayoutHorizontalAlignmentTest : TPLRowLayoutTestBase
@end

@implementation TPLRowLayoutHorizontalAlignmentTest
// TODO: Write tests. peding API design.
@end


@interface TPLRowLayoutStretchTest : TPLRowLayoutTestBase
@end

@implementation TPLRowLayoutStretchTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockViewDescriptor *_subdesc0;
  MockViewDescriptor *_subdesc1;
  MockViewDescriptor *_subdesc2;
  TPLCompositeViewDescriptor *_desc;
  CGRect _bounds;
  CGSize _selfSize;
  CGRect _subviewFrames[3];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLRowLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(20, 20);
  _subdesc1 = CreateMockViewDescriptor(20, 20);
  _subdesc2 = CreateMockViewDescriptor(20, 20);
  _desc = CreateRowDescriptor(@[ _subdesc0, _subdesc1, _subdesc2 ]);
  _bounds = CGRectMake(0, 0, 80, 20);
}

- (void)testLeftmostViewIsStretchable {
  _subdesc0.horizontalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 60, 20);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);  // Stretched.
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 40, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 60, 0, 20, 20);
}

- (void)testMiddleViewIsStretchable {
  _subdesc1.horizontalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 60, 20);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 40, 20);  // Stretched.
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 60, 0, 20, 20);
}

- (void)testRightmostViewIsStretchable {
  _subdesc2.horizontalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 60, 20);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 40, 0, 40, 20);  // Stretched.
}

- (void)testTwoViewsAreStretchable {
  _subdesc1.horizontalStretchEnabled = YES;
  _subdesc2.horizontalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 60, 20);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);  // Not stretched.
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 40, 0, 40, 20);  // Stretched.
}

- (void)testHiddenViewIsStretchable {
  _subdesc1.horizontalStretchEnabled = YES;
  _subdesc1.hidden = [TPLValueProvider providerWithConstant:@YES];
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 20);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 0, 0, 0);  // Hidden, but the next item is positioned
                                                       // as if this view is stretched.
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 60, 0, 20, 20);
}

@end


@interface TPLRowLayoutShrinkTest : TPLRowLayoutTestBase
@end

@implementation TPLRowLayoutShrinkTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockViewDescriptor *_subdesc0;
  MockViewDescriptor *_subdesc1;
  MockViewDescriptor *_subdesc2;
  TPLCompositeViewDescriptor *_desc;
  CGSize _selfSize;
  CGRect _subviewFrames[3];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLRowLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(20, 20);
  _subdesc1 = CreateMockViewDescriptor(20, 20);
  _subdesc2 = CreateMockViewDescriptor(20, 20);
  _desc = CreateRowDescriptor(@[ _subdesc0, _subdesc1, _subdesc2 ]);
}

- (void)testLeftmostViewIsShrinkable {
  _subdesc0.horizontalShrinkEnabled = YES;
  {
    CGRect bounds = CGRectMake(0, 0, 50, 20);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 50, 20);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 10, 20);  // Shrinked.
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 10, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 30, 0, 20, 20);
  }
  {
    CGRect bounds = CGRectMake(0, 0, 30, 20);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 40, 20);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 0, 20);  // Shrinked but no less than zero.
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 20, 0, 20, 20);
  }
}

- (void)testMiddleViewIsShrinkable {
  _subdesc1.horizontalShrinkEnabled = YES;
  {
    CGRect bounds = CGRectMake(0, 0, 50, 20);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 50, 20);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 10, 20);  // Shrinked.
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 30, 0, 20, 20);
  }
  {
    CGRect bounds = CGRectMake(0, 0, 30, 20);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 40, 20);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 0, 20);  // Shrinked but no less than zero.
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 20, 0, 20, 20);
  }
}

- (void)testRightmostViewIsShrinkable {
  _subdesc2.horizontalShrinkEnabled = YES;
  {
    CGRect bounds = CGRectMake(0, 0, 50, 20);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 50, 20);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 40, 0, 10, 20);  // Shrinked.
  }
  {
    CGRect bounds = CGRectMake(0, 0, 30, 20);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 40, 20);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 40, 0, 0, 20);  // Shrinked but no less than zero.
  }
}

- (void)testTwoViewsAreShrinkable {
  _subdesc1.horizontalShrinkEnabled = YES;
  _subdesc2.horizontalShrinkEnabled = YES;
  {
    CGRect bounds = CGRectMake(0, 0, 50, 20);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 50, 20);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);  // Not shrinked.
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 40, 0, 10, 20);  // Shrinked.
  }
  {
    CGRect bounds = CGRectMake(0, 0, 30, 20);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 30, 20);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 10, 20);  // Shrinked.
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 30, 0, 0, 20);  // Shrinked but no less than zero.
  }
}

- (void)testHeightChange {
  // TODO: Write tests.
}

@end


@interface TPLRowLayoutContextualSpaceTest : TPLRowLayoutTestBase
@end

@implementation TPLRowLayoutContextualSpaceTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockViewDescriptor *_subdesc0;
  TPLSpaceDescriptor *_subdesc1;
  MockViewDescriptor *_subdesc2;
  TPLCompositeViewDescriptor *_desc;
  CGRect _bounds;
  CGSize _selfSize;
  CGRect _subviewFrames[3];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLRowLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(20, 20);
  _subdesc1 = CreateContextualSpaceDescriptor(20);
  _subdesc2 = CreateMockViewDescriptor(20, 20);
  _desc = CreateRowDescriptor(@[ _subdesc0, _subdesc1, _subdesc2 ]);
  _bounds = CGRectMake(0, 0, 80, 20);
}

- (void)testNoHiddenView {
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 60, 20);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 10, 20, 0);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 40, 0, 20, 20);
}

- (void)testSpaceAfterHiddenView {
  _subdesc0.hidden = [TPLValueProvider providerWithConstant:@YES];
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 20);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 0, 0);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 0, 0, 0);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 0, 20, 20);
}

- (void)testSpaceBeforeHiddenView {
  _subdesc2.hidden = [TPLValueProvider providerWithConstant:@YES];
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 20);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 0, 0, 0);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 0, 0, 0);
}

@end


@interface TPLRowLayoutVerticalAlignmentTest : TPLRowLayoutTestBase
@end

@implementation TPLRowLayoutVerticalAlignmentTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockViewDescriptor *_subdesc0;
  MockViewDescriptor *_subdesc1;
  TPLCompositeViewDescriptor *_desc;
  CGSize _selfSize;
  CGRect _subviewFrames[2];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLRowLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(20, 40);
  _subdesc1 = CreateMockViewDescriptor(20, 20);
  _desc = CreateRowDescriptor(@[ _subdesc0, _subdesc1 ]);
}

- (void)testOrganicHeightDefaultConfigurations {
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 10, 20, 20);
}

- (void)testOrganicHeightTopAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentTop);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentTop);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);
}

- (void)testOrganicHeightCenterAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 10, 20, 20);
}

- (void)testOrganicHeightBottomAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentBottom);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentBottom);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 20, 20, 20);
}

- (void)testOrganicHeightStretchable {
  _subdesc0.verticalStretchEnabled = YES;
  _subdesc1.verticalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 40);
}

- (void)testOrganicHeightShrinkable {
  _subdesc0.verticalShrinkEnabled = YES;
  _subdesc1.verticalShrinkEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 10, 20, 20);
}

- (void)testHeightExcessDefalutConfigurations {
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 100), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 30, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 40, 20, 20);
}

- (void)testHeightExcessTopAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentTop);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentTop);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 100), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);
}

- (void)testHeightExcessCenterAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 100), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 30, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 40, 20, 20);
}

- (void)testHeightExcessBottomAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentBottom);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentBottom);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 100), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 60, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 80, 20, 20);
}

- (void)testHeightExcessStretchable {
  _subdesc0.verticalStretchEnabled = YES;
  _subdesc1.verticalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 100), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 100);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 100);
}

- (void)testHeightExcessShrinkable {
  _subdesc0.verticalShrinkEnabled = YES;
  _subdesc1.verticalShrinkEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 100), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 30, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 40, 20, 20);
}

- (void)testHeightShortageDefalutConfigurations {
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 10), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, -15, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, -5, 20, 20);
}

- (void)testHeightShortageTopAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentTop);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentTop);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 10), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 20);
}

- (void)testHeightShortageCenterAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 10), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, -15, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, -5, 20, 20);
}

- (void)testHeightShortageBottomAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentBottom);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentBottom);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 10), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, -30, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, -10, 20, 20);
}

- (void)testHeightShortageStretchable {
  _subdesc0.verticalStretchEnabled = YES;
  _subdesc1.verticalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 10), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, -15, 20, 40);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, -5, 20, 20);
}

- (void)testHeightShortageShrinkable {
  _subdesc0.verticalShrinkEnabled = YES;
  _subdesc1.verticalShrinkEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 10), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 10);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 0, 20, 10);
}

@end


@interface TPLRowLayoutPaddingTest : TPLRowLayoutTestBase
@end

@implementation TPLRowLayoutPaddingTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  TPLCompositeViewDescriptor *_desc;
  MockViewDescriptor *_subdesc;
  CGRect _subviewFrames[1];
  CGSize _selfSize;
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLRowLayoutCalculatorCreate();
  _subdesc = CreateMockViewDescriptor(20, 20);
  _desc = CreateRowDescriptor(@[ _subdesc ]);
  _desc.padding = [TPLValueProvider providerWithConstant:TPLEdgeInsetsMake(5, 10, 15, 20)];
}

- (void)testStandardBounds {
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 50, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 50, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 10, 5, 20, 20);
}

- (void)testShiftedBounds {
  _layoutCalculator(_desc, nil, CGRectMake(30, 30, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 50, 40);
  _layoutCalculator(_desc, nil, CGRectMake(30, 30, 50, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 40, 35, 20, 20);
}

@end
