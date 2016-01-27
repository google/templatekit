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
#import "Internal/Core/TPLViewModel+Internal.h"
#import "Internal/DescriptorImpls/TPLDataViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLMultiplexerViewDescriptor.h"
#import "Public/Core/TPLConstants.h"

@interface TPLMultiplexerViewDescriptorTestViewModel : TPLViewModel

@property(nonatomic) NSMutableArray *dataArray;

@end

@implementation TPLMultiplexerViewDescriptorTestViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    _dataArray = [[NSMutableArray alloc] init];
  }
  return self;
}

@end

@interface TPLMultiplexerViewDescriptorTestBase : XCTestCase
@end

@implementation TPLMultiplexerViewDescriptorTestBase
@end

@interface TPLMultiplexerViewDescriptorHiddenViewsTest : TPLMultiplexerViewDescriptorTestBase
@end

@implementation TPLMultiplexerViewDescriptorHiddenViewsTest {
  TPLMultiplexerViewDescriptor *_desc;
  TPLDataViewDescriptor *_subdesc;
}

- (void)setUp {
  [super setUp];

  _desc = [TPLMultiplexerViewDescriptor descriptor];
  _subdesc = [TPLDataViewDescriptor descriptor];
  _subdesc.data = [TPLValueProvider providerWithSelector:@selector(dataArray)];
  _desc.subdescriptor = _subdesc;
}

- (void)testNoViewModel {
  XCTAssertTrue([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testNoData {
  TPLMultiplexerViewDescriptorTestViewModel *viewModel =
      [[TPLMultiplexerViewDescriptorTestViewModel alloc] init];
  XCTAssertTrue([_desc isViewHiddenWithViewModel:viewModel]);
}

- (void)testDataHasNotHiddenItems {
  TPLMultiplexerViewDescriptorTestViewModel *viewModel =
      [[TPLMultiplexerViewDescriptorTestViewModel alloc] init];
  [viewModel.dataArray addObjectsFromArray:@[ @1, @2 ]];
  XCTAssertFalse([_desc isViewHiddenWithViewModel:viewModel]);
}

- (void)testNoSubdescriptor {
  TPLMultiplexerViewDescriptorTestViewModel *viewModel =
      [[TPLMultiplexerViewDescriptorTestViewModel alloc] init];
  [viewModel.dataArray addObjectsFromArray:@[ @1, @2 ]];
  _desc.subdescriptor = nil;
  XCTAssertTrue([_desc isViewHiddenWithViewModel:viewModel]);
}

- (void)testDataHasOnlyHiddenItems {
  // TODO: Write tests.
}

@end
