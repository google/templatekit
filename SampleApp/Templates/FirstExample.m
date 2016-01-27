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

#import "FirstExample.h"

#import "TemplateKit.h"


@implementation FirstExampleView
@end


@implementation FirstExampleViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    _title = [[TPLLabelData alloc] init];
    _title.text = @"The great duck";
    _subtitle = [[TPLLabelData alloc] init];
    _subtitle.text = @"Osaka trip, Dec 2014";
    _subtitle.textColor = [UIColor darkGrayColor];
    _subtitle.font = [UIFont systemFontOfSize:14];
    _thumbnail = [UIImage imageNamed:@"duck"];
  }
  return self;
}

@end


TPL_DEFINE_VIEW_TEMPLATE(first_example, FirstExampleView) {
  return row(image($(thumbnail)),
             margin(@10),
             column(label($(title)),
                    label($(subtitle)),
                    nil),
             nil)
           .padding(TPLEdgeInsetsMake(10, 10, 10, 10));
}
