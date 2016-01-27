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
#import "Internal/DescriptorImpls/TPLLabelDescriptor.h"
#import "Public/Core/TPLViewModel.h"


@interface TPLLabelDescriptorTestViewModel : TPLViewModel
@property(nonatomic) id data;
@end

@implementation TPLLabelDescriptorTestViewModel
@end


@interface TPLLabelDescriptorTestBase : XCTestCase
@end

@implementation TPLLabelDescriptorTestBase
@end


@interface TPLLabelDescriptorHiddenViewTest : TPLLabelDescriptorTestBase
@end

@implementation TPLLabelDescriptorHiddenViewTest {
  TPLLabelDescriptor *_desc;
  TPLLabelDescriptorTestViewModel *_viewModel;
  TPLValueProvider *_selectorProvider;
  TPLLabelData *_labelData;
}

- (void)setUp {
  [super setUp];

  _desc = [[TPLLabelDescriptor alloc] init];
  _viewModel = [[TPLLabelDescriptorTestViewModel alloc] init];
  _selectorProvider = [TPLValueProvider providerWithSelector:@selector(data)];
  _labelData = [[TPLLabelData alloc] init];
}

- (void)testNoProvider {
  _viewModel.data = @"foo";
  XCTAssertTrue([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithNoModel {
  _desc.data = _selectorProvider;
  XCTAssertTrue([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testSelectorProviderWithEmptyModel {
  _desc.data = _selectorProvider;
  XCTAssertTrue([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithStringInModel {
  _desc.data = _selectorProvider;
  _viewModel.data = @"foo";
  XCTAssertFalse([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithEmptyStringInModel {
  _desc.data = _selectorProvider;
  _viewModel.data = @"";
  XCTAssertTrue([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithAttributedStringInModel {
  _desc.data = _selectorProvider;
  _viewModel.data = [[NSAttributedString alloc] initWithString:@"foo"];
  XCTAssertFalse([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithEmptyAttributedStringInModel {
  _desc.data = _selectorProvider;
  _viewModel.data = [[NSAttributedString alloc] initWithString:@""];
  XCTAssertTrue([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithEmptyDataInModel {
  _desc.data = _selectorProvider;
  _viewModel.data = _labelData;
  XCTAssertTrue([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithDataWithStringInModel {
  _desc.data = _selectorProvider;
  _labelData.text = @"foo";
  _viewModel.data = _labelData;
  XCTAssertFalse([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithDataWithEmptyStringInModel {
  _desc.data = _selectorProvider;
  _labelData.text = @"";
  _viewModel.data = _labelData;
  XCTAssertTrue([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithDataWithAttributedStringInModel {
  _desc.data = _selectorProvider;
  _labelData.attributedText = [[NSAttributedString alloc] initWithString:@"foo"];
  _viewModel.data = _labelData;
  XCTAssertFalse([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testSelectorProviderWithDataWithEmptyAttributedStringInModel {
  _desc.data = _selectorProvider;
  _labelData.attributedText = [[NSAttributedString alloc] initWithString:@""];
  _viewModel.data = _labelData;
  XCTAssertTrue([_desc isViewHiddenWithViewModel:_viewModel]);
}

- (void)testConstantProviderWithString {
  _desc.data = [TPLValueProvider providerWithConstant:@"foo"];
  XCTAssertFalse([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testConstantProviderWithEmptyString {
  _desc.data = [TPLValueProvider providerWithConstant:@""];
  XCTAssertTrue([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testConstantProviderWithAttributedString {
  _desc.data =
      [TPLValueProvider providerWithConstant:[[NSAttributedString alloc] initWithString:@"foo"]];
  XCTAssertFalse([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testConstantProviderWithEmptyAttributedString {
  _desc.data =
      [TPLValueProvider providerWithConstant:[[NSAttributedString alloc] initWithString:@""]];
  XCTAssertTrue([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testConstantProviderWithEmptyData {
  _desc.data = [TPLValueProvider providerWithConstant:_labelData];
  XCTAssertTrue([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testConstantProviderWithDataWithString {
  _labelData.text = @"foo";
  _desc.data = [TPLValueProvider providerWithConstant:_labelData];
  XCTAssertFalse([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testConstantProviderWithDataWithEmptyString {
  _labelData.text = @"";
  _desc.data = [TPLValueProvider providerWithConstant:_labelData];
  XCTAssertTrue([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testConstantProviderWithDataWithAttributedString {
  _labelData.attributedText = [[NSAttributedString alloc] initWithString:@"foo"];
  _desc.data = [TPLValueProvider providerWithConstant:_labelData];
  XCTAssertFalse([_desc isViewHiddenWithViewModel:nil]);
}

- (void)testConstantProviderWithDataWithEmptyAttributedStringInModel {
  _labelData.attributedText = [[NSAttributedString alloc] initWithString:@""];
  _desc.data = [TPLValueProvider providerWithConstant:_labelData];
  XCTAssertTrue([_desc isViewHiddenWithViewModel:nil]);
}

@end
