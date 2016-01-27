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
#import "Internal/DescriptorImpls/TPLColumnLayout.h"
#import "Internal/DescriptorImpls/TPLContainerViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLSpaceDescriptor.h"
#import "Public/Core/TPLUtils.h"
#import "TPLTestingUtil.h"

static TPLCompositeViewDescriptor *CreateColumnDescriptor(NSArray *subdescriptors) {
  TPLCompositeViewDescriptor *column = [[TPLCompositeViewDescriptor alloc] init];
  [column.subdescriptors addObjectsFromArray:subdescriptors];
  return column;
}

static TPLSpaceDescriptor *CreateContextualSpaceDescriptor(CGFloat height) {
  TPLSpaceDescriptor *space = [TPLSpaceDescriptor descriptor];
  space.direction = TPLDirectionVertical;
  space.length = @(height);
  space.shouldAlwaysShow = NO;
  return space;
}

static TPLValueProvider *CreateProviderWithAlignment(TPLAlignment alignment) {
  return [TPLValueProvider providerWithConstant:@(alignment)];
}

@interface TPLColumnLayoutTestBase : XCTestCase
@end

@implementation TPLColumnLayoutTestBase
@end


@interface TPLColumnLayoutOnePlainSubviewTest : TPLColumnLayoutTestBase
@end

@implementation TPLColumnLayoutOnePlainSubviewTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockViewDescriptor *_subdesc;
  TPLCompositeViewDescriptor *_desc;
  CGSize _selfSize;
  CGRect _subviewFrames[1];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLColumnLayoutCalculatorCreate();
  _subdesc = CreateMockViewDescriptor(20, 20);
  _desc = CreateColumnDescriptor(@[ _subdesc ]);
}

- (void)testJustEnoughHeight {
  CGRect bounds = CGRectMake(0, 0, 20, 20);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
}

- (void)testMoreThanEnoughHeight {
  CGRect bounds = CGRectMake(0, 0, 20, 40);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
}

- (void)testLessThanEnoughHeight {
  CGRect bounds = CGRectMake(0, 0, 20, 10);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 20);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
}

- (void)testHidden {
  _subdesc.hidden = [TPLValueProvider providerWithConstant:@YES];
  CGRect bounds = CGRectMake(0, 0, 20, 30);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 0, 0);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 0, 0);
}

@end


@interface TPLColumnLayoutMultiplePlainSubviewsTest : TPLColumnLayoutTestBase
@end

@implementation TPLColumnLayoutMultiplePlainSubviewsTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockViewDescriptor *_subdesc0, *_subdesc1, *_subdesc2;
  TPLCompositeViewDescriptor *_desc;
  CGSize _selfSize;
  CGRect _subviewFrames[3];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLColumnLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(20, 20);
  _subdesc1 = CreateMockViewDescriptor(20, 20);
  _subdesc2 = CreateMockViewDescriptor(20, 20);
  _desc = CreateColumnDescriptor(@[ _subdesc0, _subdesc1, _subdesc2 ]);
}

- (void)testJustEnoughHeight {
  CGRect bounds = CGRectMake(0, 0, 20, 60);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 60);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 40, 20, 20);
}

- (void)testMoreThanEnoughHeight {
  CGRect bounds = CGRectMake(0, 0, 20, 70);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 60);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 40, 20, 20);
}

- (void)testLessThanEnoughHeight {
  CGRect bounds = CGRectMake(0, 0, 20, 50);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 60);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 40, 20, 20);
}

- (void)testHidden {
  _subdesc1.hidden = [TPLValueProvider providerWithConstant:@YES];
  CGRect bounds = CGRectMake(0, 0, 20, 30);
  _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 40);
  _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 0, 0, 0);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 20, 20, 20);
}

@end


@interface TPLColumnLayoutHeightAdjustingSubviewTest : TPLColumnLayoutTestBase
@end

@implementation TPLColumnLayoutHeightAdjustingSubviewTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockHeightAdjustingViewDescriptor *_subdesc;
  TPLCompositeViewDescriptor *_desc;
  CGSize _selfSize;
  CGRect _subviewFrame[1];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLColumnLayoutCalculatorCreate();
  _subdesc = [[MockHeightAdjustingViewDescriptor alloc] initWithDefaultSize:CGSizeMake(20, 20)
                                                             adjustedHeight:40];
  _desc = CreateColumnDescriptor(@[ _subdesc ]);
}

- (void)testSufficientWidth {
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 20, 20), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 20);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 20, 20), YES, NULL, _subviewFrame);
  ASSERT_EQUAL_RECTS(_subviewFrame[0], 0, 0, 20, 20);
}

- (void)testInsufficientWidth {
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 10, 20), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 10, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 10, 20), YES, NULL, _subviewFrame);
  ASSERT_EQUAL_RECTS(_subviewFrame[0], 0, 0, 10, 40);
}

@end


@interface TPLColumnLayoutVerticalAlignmentTest : TPLColumnLayoutTestBase
@end

@implementation TPLColumnLayoutVerticalAlignmentTest
// TODO: Write tests. peding API design.
@end


@interface TPLColumnLayoutStretchTest : TPLColumnLayoutTestBase
@end

@implementation TPLColumnLayoutStretchTest {
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

  _layoutCalculator = TPLColumnLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(20, 20);
  _subdesc1 = CreateMockViewDescriptor(20, 20);
  _subdesc2 = CreateMockViewDescriptor(20, 20);
  _desc = CreateColumnDescriptor(@[ _subdesc0, _subdesc1, _subdesc2 ]);
  _bounds = CGRectMake(0, 0, 20, 80);
}

- (void)testTopmostViewIsStretchable {
  _subdesc0.verticalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 60);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 40);  // Stretched.
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 40, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 60, 20, 20);
}

- (void)testMiddleViewIsStretchable {
  _subdesc1.verticalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 60);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 40);  // Stretched.
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 60, 20, 20);
}

- (void)testBottommostViewIsStretchable {
  _subdesc2.verticalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 60);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 40, 20, 40);  // Stretched.
}

- (void)testTwoViewsAreStretchable {
  _subdesc1.verticalStretchEnabled = YES;
  _subdesc2.verticalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 60);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);  // Not stretched.
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 40, 20, 40);  // Stretched.
}

- (void)testHiddenViewIsStretchable {
  _subdesc1.verticalStretchEnabled = YES;
  _subdesc1.hidden = [TPLValueProvider providerWithConstant:@YES];
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 40);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 0, 0, 0);  // Hidden, but the next item is positioned
                                                      // as if this view is stretched.
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 60, 20, 20);
}

@end


@interface TPLColumnLayoutShrinkTest : TPLColumnLayoutTestBase
@end

@implementation TPLColumnLayoutShrinkTest {
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

  _layoutCalculator = TPLColumnLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(20, 20);
  _subdesc1 = CreateMockViewDescriptor(20, 20);
  _subdesc2 = CreateMockViewDescriptor(20, 20);
  _desc = CreateColumnDescriptor(@[ _subdesc0, _subdesc1, _subdesc2 ]);
}

- (void)testTopmostViewIsShrinkable {
  _subdesc0.verticalShrinkEnabled = YES;
  {
    CGRect bounds = CGRectMake(0, 0, 20, 50);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 20, 50);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 10);  // Shrinked.
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 10, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 30, 20, 20);
  }
  {
    CGRect bounds = CGRectMake(0, 0, 20, 30);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 20, 40);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 0);  // Shrinked but no less than zero.
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 20, 20, 20);
  }
}

- (void)testMiddleViewIsShrinkable {
  _subdesc1.verticalShrinkEnabled = YES;
  {
    CGRect bounds = CGRectMake(0, 0, 20, 50);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 20, 50);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 10);  // Shrinked.
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 30, 20, 20);
  }
  {
    CGRect bounds = CGRectMake(0, 0, 20, 30);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 20, 40);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 0);  // Shrinked but no less than zero.
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 20, 20, 20);
  }
}

- (void)testRightmostViewIsShrinkable {
  _subdesc2.verticalShrinkEnabled = YES;
  {
    CGRect bounds = CGRectMake(0, 0, 20, 50);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 20, 50);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 40, 20, 10);  // Shrinked.
  }
  {
    CGRect bounds = CGRectMake(0, 0, 20, 30);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 20, 40);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 40, 20, 0);  // Shrinked but no less than zero.
  }
}

- (void)testTwoViewsAreShrinkable {
  _subdesc1.verticalShrinkEnabled = YES;
  _subdesc2.verticalShrinkEnabled = YES;
  {
    CGRect bounds = CGRectMake(0, 0, 20, 50);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 20, 50);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);  // Not shrinked.
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 40, 20, 10);  // Shrinked.
  }
  {
    CGRect bounds = CGRectMake(0, 0, 20, 30);
    _layoutCalculator(_desc, nil, bounds, NO, &_selfSize, NULL);
    ASSERT_EQUAL_SIZES(_selfSize, 20, 30);
    _layoutCalculator(_desc, nil, bounds, YES, NULL, _subviewFrames);
    ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
    ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 10);  // Shrinked.
    ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 30, 20, 0);  // Shrinked but no less than zero.
  }
}

@end


@interface TPLColumnLayoutContextualSpaceTest : TPLColumnLayoutTestBase
@end

@implementation TPLColumnLayoutContextualSpaceTest {
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

  _layoutCalculator = TPLColumnLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(20, 20);
  _subdesc1 = CreateContextualSpaceDescriptor(20);
  _subdesc2 = CreateMockViewDescriptor(20, 20);
  _desc = CreateColumnDescriptor(@[ _subdesc0, _subdesc1, _subdesc2 ]);
  _bounds = CGRectMake(0, 0, 20, 80);
}

- (void)testNoHiddenView {
  _layoutCalculator(_desc, nil, _bounds, NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 20, 60);
  _layoutCalculator(_desc, nil, _bounds, YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 20, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 0, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[2], 0, 40, 20, 20);
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


@interface TPLColumnLayoutHorizontalAlignmentTest : TPLColumnLayoutTestBase
@end

@implementation TPLColumnLayoutHorizontalAlignmentTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  MockViewDescriptor *_subdesc0;
  MockViewDescriptor *_subdesc1;
  TPLCompositeViewDescriptor *_desc;
  CGSize _selfSize;
  CGRect _subviewFrames[2];
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLColumnLayoutCalculatorCreate();
  _subdesc0 = CreateMockViewDescriptor(40, 20);
  _subdesc1 = CreateMockViewDescriptor(20, 20);
  _desc = CreateColumnDescriptor(@[ _subdesc0, _subdesc1 ]);
}

- (void)testOrganicWidthDefaultConfigurations {
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
}

- (void)testOrganicWidthLeftAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentLeft);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentLeft);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
}

- (void)testOrganicWidthCenterAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 10, 20, 20, 20);
}

- (void)testOrganicWidthRihgtAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentRight);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentRight);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 20, 20, 20, 20);
}

- (void)testOrganicWidthStretchable {
  _subdesc0.horizontalStretchEnabled = YES;
  _subdesc1.horizontalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 40, 20);
}

- (void)testOrganicWidthShrinkable {
  _subdesc0.horizontalShrinkEnabled = YES;
  _subdesc1.horizontalShrinkEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 40, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
}

- (void)testWidthExcessDefalutConfigurations {
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
}

- (void)testWidthExcessLeftAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentLeft);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentLeft);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
}

- (void)testWidthExcessCenterAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 30, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 40, 20, 20, 20);
}

- (void)testWidthExcessRihgtAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentRight);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentRight);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 60, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 80, 20, 20, 20);
}

- (void)testWidthExcessStretchable {
  _subdesc0.horizontalStretchEnabled = YES;
  _subdesc1.horizontalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 100, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 100, 20);
}

- (void)testWidthExcessShrinkable {
  _subdesc0.horizontalShrinkEnabled = YES;
  _subdesc1.horizontalShrinkEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
}

- (void)testWidthShortageDefalutConfigurations {
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 10, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
}

- (void)testWidthShortageLeftAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentLeft);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentLeft);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 10, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
}

- (void)testWidthShortageCenterAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentCenter);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 10, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], -15, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], -5, 20, 20, 20);
}

- (void)testWidthShortageRihgtAlignment {
  _subdesc0.position = CreateProviderWithAlignment(TPLAlignmentRight);
  _subdesc1.position = CreateProviderWithAlignment(TPLAlignmentRight);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 10, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], -30, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], -10, 20, 20, 20);
}

- (void)testWidthShortageStretchable {
  _subdesc0.horizontalStretchEnabled = YES;
  _subdesc1.horizontalStretchEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 10, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 40, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 20, 20);
}

- (void)testWidthShortageShrinkable {
  _subdesc0.horizontalShrinkEnabled = YES;
  _subdesc1.horizontalShrinkEnabled = YES;
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 100, 100), NO, &_selfSize, NULL);
  ASSERT_EQUAL_SIZES(_selfSize, 40, 40);
  _layoutCalculator(_desc, nil, CGRectMake(0, 0, 10, 40), YES, NULL, _subviewFrames);
  ASSERT_EQUAL_RECTS(_subviewFrames[0], 0, 0, 10, 20);
  ASSERT_EQUAL_RECTS(_subviewFrames[1], 0, 20, 10, 20);
}

// TODO: Write tests for subviewHorizontalAlignment.

@end


@interface TPLColumnLayoutPaddingTest : TPLColumnLayoutTestBase
@end

@implementation TPLColumnLayoutPaddingTest {
  TPLCompositeLayoutCalculator _layoutCalculator;
  TPLCompositeViewDescriptor *_desc;
  MockViewDescriptor *_subdesc;
  CGRect _subviewFrames[1];
  CGSize _selfSize;
}

- (void)setUp {
  [super setUp];

  _layoutCalculator = TPLColumnLayoutCalculatorCreate();
  _subdesc = CreateMockViewDescriptor(20, 20);
  _desc = CreateColumnDescriptor(@[ _subdesc ]);
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
