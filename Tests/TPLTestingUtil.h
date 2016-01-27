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

#import <UIKit/UIKit.h>

#import "Internal/Core/TPLViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLContainerViewDescriptor.h"

@class MockViewDescriptor;


#define ASSERT_EQUAL_POINTS(point___, x___, y___) \
  do { \
    XCTAssertEqualWithAccuracy(point___.x, x___, 0.00001); \
    XCTAssertEqualWithAccuracy(point___.y, y___, 0.00001); \
  } while (0)

#define ASSERT_EQUAL_SIZES(size___, width___, height___) \
  do { \
    XCTAssertEqualWithAccuracy(size___.width, width___, 0.00001); \
    XCTAssertEqualWithAccuracy(size___.height, height___, 0.00001); \
  } while (0)

#define ASSERT_EQUAL_RECTS(frame__, x__, y__, width__, height__) \
  do { \
    ASSERT_EQUAL_POINTS(frame__.origin, x__, y__); \
    ASSERT_EQUAL_SIZES(frame__.size, width__, height__); \
  } while (0)


UIView *FindSubview(TPLContainerView *rootView, TPLViewDescriptor *descriptor);

MockViewDescriptor *CreateMockViewDescriptor(CGFloat width, CGFloat height);

@interface MockViewDescriptor : TPLViewDescriptor

- (instancetype)initWithIntrinsicSize:(CGSize)size;

@end

@interface MockHeightAdjustingViewDescriptor : TPLViewDescriptor

@property(nonatomic) CGSize defaultSize;
@property(nonatomic) CGFloat adjustedHeight;

- (instancetype)initWithDefaultSize:(CGSize)defaultSize adjustedHeight:(CGFloat)adjustedHeight;

@end
