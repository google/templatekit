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

#import "Internal/DescriptorImpls/TPLContextualSpaceSelector.h"

@interface TPLContextualSpaceSelectorTest : XCTestCase
@end

@implementation TPLContextualSpaceSelectorTest {
  TPLContextualSpaceSelectorRef _selector;
}

- (void)setUp {
  [super setUp];

  _selector = NULL;
}

- (void)tearDown {
  [super tearDown];

  TPLContextualSpaceSelectorDelete(_selector);
  _selector = NULL;
}

- (void)test_0Item {
  _selector = TPLContextualSpaceSelectorCreate(0);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 0);
}

- (void)test_1item_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(1);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 0);
}

- (void)test_1item_hiddenView {
  _selector = TPLContextualSpaceSelectorCreate(1);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 0);
}

- (void)test_1item_space {
  _selector = TPLContextualSpaceSelectorCreate(1);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 0);
}

- (void)test_2items_visibleView_space {
  _selector = TPLContextualSpaceSelectorCreate(2);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 1);
}

- (void)test_2items_hiddenView_space {
  _selector = TPLContextualSpaceSelectorCreate(2);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 1);
}

- (void)test_2items_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(2);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 0);
}

- (void)test_2items_space_hiddenView {
  _selector = TPLContextualSpaceSelectorCreate(2);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 0);
}

- (void)test_2items_space_space {
  _selector = TPLContextualSpaceSelectorCreate(2);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 2);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 0);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[1], 1);
}

- (void)test_3items_visibleView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(3);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 0);
}

- (void)test_3items_hiddenView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(3);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 1);
}

- (void)test_3items_visibleView_space_hiddenView {
  _selector = TPLContextualSpaceSelectorCreate(3);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 1);
}

- (void)test_4items_visibleView_space_visibleView_space {
  _selector = TPLContextualSpaceSelectorCreate(4);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 3);
}

- (void)test_4items_visibleView_space_hiddenView_space {
  _selector = TPLContextualSpaceSelectorCreate(4);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 2);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[1], 3);
}

- (void)test_4items_hiddenView_space_visibleView_space {
  _selector = TPLContextualSpaceSelectorCreate(4);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 2);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[1], 3);
}

- (void)test_4items_space_visibleView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(4);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 0);
}

- (void)test_4items_space_visibleView_space_hiddenView {
  _selector = TPLContextualSpaceSelectorCreate(4);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 2);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 0);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[1], 2);
}

- (void)test_4items_space_hiddenView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(4);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 2);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 0);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[1], 2);
}

- (void)test_4items_visibleView_space_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(4);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  // TODO(keni): Selection of space to be hidden is unspecified.
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 2);
}

- (void)test_5items_visibleView_space_visibleView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(5);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 0);
}

- (void)test_5items_hiddenView_space_visibleView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(5);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 1);
}

- (void)test_5items_visibleView_space_hiddenView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(5);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  // TODO(keni): Selection of space to be hidden is unspecified.
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 3);
}

- (void)test_5items_visibleView_space_vislbleView_space_hiddenView {
  _selector = TPLContextualSpaceSelectorCreate(5);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 3);
}

- (void)test_5items_visibleView_space_space_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(5);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 2);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 2);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[1], 3);
}

- (void)test_6items_visibleView_space_vislbleView_space_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(6);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 4);
}

- (void)test_6items_visibleView_space_space_visibleView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(6);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 2);
}

- (void)test_7items_visibleView_space_hiddenView_space_visibleView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(7);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 3);
}

- (void)test_7items_visibleView_space_visibleView_space_hiddenView_space_visibleView {
  _selector = TPLContextualSpaceSelectorCreate(7);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, YES);
  TPLContextualSpaceSelectorAddContextualSpace(_selector);
  TPLContextualSpaceSelectorAddView(_selector, NO);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(_selector), 1);
  XCTAssertEqual(TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(_selector)[0], 5);
}

@end
