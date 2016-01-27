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

#import "Internal/DescriptorImpls/TPLGridDescriptor.h"

#include <tgmath.h>

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLValueProvider.h"
#import "Internal/Core/TPLViewModel+Internal.h"
#import "Internal/DescriptorImpls/TPLDataViewDescriptor.h"
#import "Internal/DescriptorImpls/TPLDescriptorImplsMacros.h"
#import "Public/DescriptorImpls/TPLGridConfig.h"


@implementation TPLGridConfig

- (instancetype)init {
  self = [super init];
  if (self) {
    _numberOfColumns = 2;
    _columnMargin = 5.f;
    _rowMargin = 5.f;
  }
  return self;
}

@end


@implementation TPLGridDescriptor

- (instancetype)init {
  self = [super init];
  if (self) {
    _config = [TPLValueProvider providerWithConstant:[[TPLGridConfig alloc] init]];
  }
  return self;
}

- (CGSize)intrinsicViewSizeThatFits:(CGSize)size
                      withViewModel:(TPLViewModel *)viewModel {
  NSArray *dataArray = [self dataArrayWithViewModel:viewModel];
  NSInteger numberOfCells = dataArray.count;
  if (numberOfCells == 0) {
    return CGSizeZero;
  }
  TPLGridConfig *config = [_config objectWithViewModel:viewModel];
  NSInteger numberOfColumns = config.numberOfColumns;
  NSInteger numberOfRows = (numberOfCells + numberOfColumns - 1) / numberOfColumns;
  CGSize firstCellMaxSize = CGSizeMake(ceil(size.width / numberOfColumns),
                                       ceil(size.height / numberOfRows));
  CGSize firstCellSize = [self.subdescriptor viewSizeThatFits:firstCellMaxSize
                                                     withData:dataArray[0]];
  CGFloat finalWidth =
      ceil(firstCellSize.width) * numberOfColumns + config.columnMargin * (numberOfColumns - 1);
  CGFloat finalHeight =
      ceil(firstCellSize.height) * numberOfRows + config.rowMargin * (numberOfRows - 1);
  CGSize finalSize = CGSizeMake(finalWidth, finalHeight);
  return finalSize;
}

- (void)layoutSubviewsInContainerView:(TPLContainerView *)containerView {
  TPLViewModel *viewModel = TPLViewModelWithView(containerView);
  TPLGridConfig *config = [_config objectWithViewModel:viewModel];
  NSArray *dataArray = [self dataArrayWithViewModel:viewModel];
  NSInteger numberOfCells = dataArray.count;
  NSInteger numberOfColumns = config.numberOfColumns;
  NSInteger numberOfRows = (numberOfCells + numberOfColumns - 1) / numberOfColumns;
  CGRect bounds = containerView.bounds;
  CGFloat columnWidth =
      (CGRectGetWidth(bounds) - config.columnMargin * (numberOfColumns - 1)) / numberOfColumns;
  CGFloat rowHeight =
      (CGRectGetHeight(bounds) - config.rowMargin * (numberOfRows - 1)) / numberOfRows;
  for (NSUInteger cellIndex = 0; cellIndex < dataArray.count; ++cellIndex) {
    NSUInteger columnIndex = cellIndex % numberOfColumns;
    NSUInteger rowIndex = cellIndex / numberOfColumns;
    UIView *subview = containerView.tpl_subviews[cellIndex];
    subview.frame = CGRectMake(TPL_CEIL((columnWidth + config.columnMargin) * columnIndex),
                               TPL_CEIL((rowHeight + config.rowMargin) * rowIndex),
                               TPL_CEIL(columnWidth),
                               TPL_CEIL(rowHeight));
  }
}

@end
