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

#import "AdapterExample.h"

#import "TemplateKit.h"

@interface NoDataView : UIView
@end

@implementation NoDataView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor yellowColor];
  }
  return self;
}

@end

@interface NoDataViewAdapter : NSObject<TPLSimpleViewAdapter>
@end

@implementation NoDataViewAdapter

- (UIView *)view {
  return [[NoDataView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
}

@end

TPL_DEFINE_SIMPLE_VIEW_ADAPTER(my_no_data_view, NoDataViewAdapter);

@implementation MutableDataViewData
@end

@interface MutableDataView : UIView
@end

@implementation MutableDataView
@end

@interface MutableDataViewAdapter : NSObject<TPLDataViewAdapter>
@end

@implementation MutableDataViewAdapter

- (UIView *)view {
  return [[MutableDataView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
}

- (void)setData:(id)data toView:(UIView *)view {
  view.backgroundColor = ((MutableDataViewData *)data).color;
}

@end

TPL_DEFINE_DATA_VIEW_ADAPTER(my_mutable_data_view, MutableDataViewAdapter);

@implementation ImmutableDataViewData
@end

@interface ImmutableDataView : UIView

- (instancetype)initWithData:(ImmutableDataViewData *)data NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

@implementation ImmutableDataView

- (instancetype)initWithData:(ImmutableDataViewData *)data {
  self = [super initWithFrame:CGRectZero];
  if (self) {
    self.backgroundColor = data.color;
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  return [self initWithData:nil];
}

@end

@interface ImmutableDataViewAdapter : NSObject<TPLImmutableDataViewAdapter>
@end

@implementation ImmutableDataViewAdapter

- (UIView *)viewWithData:(id)data {
  return [[ImmutableDataView alloc] initWithData:data];
}

- (CGSize)viewSizeThatFits:(CGSize)size withData:(id)data {
  return CGSizeMake(100, 40);
}

@end

TPL_DEFINE_IMMUTABLE_DATA_VIEW_ADAPTER(my_immutable_data_view, ImmutableDataViewAdapter);


@implementation AdapterExampleViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    _mutableViewData = [[MutableDataViewData alloc] init];
    _mutableViewData.color = [UIColor greenColor];
    _immutableViewData = [[ImmutableDataViewData alloc] init];
    _immutableViewData.color = [UIColor blueColor];
  }
  return self;
}

@end


@implementation AdapterExampleView
@end

TPL_DEFINE_VIEW_TEMPLATE(adapter_example, AdapterExampleView) {
  return column(ext.my_no_data_view(),
                ext.my_mutable_data_view($(mutableViewData)),
                ext.my_immutable_data_view($(immutableViewData)),
                nil);
}
