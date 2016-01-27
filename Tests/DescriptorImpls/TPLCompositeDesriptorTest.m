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
#import "Internal/DescriptorImpls/TPLCompositeViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLSpaceDescriptor.h"
#import "Public/Core/TPLConstants.h"
#import "TPLTestingUtil.h"

static TPLCompositeViewDescriptor *CreateCompositeDescriptor(NSArray *subdescriptors) {
  TPLCompositeViewDescriptor *composite = [TPLCompositeViewDescriptor descriptor];
  [composite.subdescriptors addObjectsFromArray:subdescriptors];
  return composite;
}

@interface TPLCompositeDesriptorTestBase : XCTestCase
@end

@implementation TPLCompositeDesriptorTestBase
@end


@interface TPLCompositeDesriptorHiddenViewsTest : TPLCompositeDesriptorTestBase
@end

@implementation TPLCompositeDesriptorHiddenViewsTest {
  TPLViewDescriptor *_subdesc0;
  TPLSpaceDescriptor *_subdesc1;
  TPLViewDescriptor *_subdesc2;
  TPLCompositeViewDescriptor *_desc;
}

- (void)setUp {
  [super setUp];

  _subdesc0 = CreateMockViewDescriptor(20, 20);
  _subdesc1 = [TPLSpaceDescriptor descriptor];
  _subdesc2 = CreateMockViewDescriptor(20, 20);
  _desc = CreateCompositeDescriptor(@[ _subdesc0, _subdesc1, _subdesc2 ]);
}

- (void)testNoSubviewsAreHidden {
  XCTAssertFalse([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testSomeSubviewsAreHidden {
  _subdesc0.hidden = [TPLValueProvider providerWithConstant:@YES];
  XCTAssertFalse([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testAllSubviewsAreHiddenWithContextualSpace {
  _subdesc0.hidden = [TPLValueProvider providerWithConstant:@YES];
  _subdesc2.hidden = [TPLValueProvider providerWithConstant:@YES];
  XCTAssertTrue([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testAllSubviewsAreHiddenWithNoncontextualSpace {
  _subdesc0.hidden = [TPLValueProvider providerWithConstant:@YES];
  _subdesc1.shouldAlwaysShow = YES;
  _subdesc2.hidden = [TPLValueProvider providerWithConstant:@YES];
  XCTAssertFalse([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testNoSubviewsAtAll {
  _desc = CreateCompositeDescriptor(@[]);
  XCTAssertTrue([_desc isViewHiddenWithViewModel:nil]);
}

@end
