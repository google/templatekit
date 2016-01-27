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

#import "LabelExample.h"

#import "TemplateKit.h"


@implementation LabelExampleViewModel
@end


@implementation LabelExampleView
@end

TPL_DEFINE_VIEW_TEMPLATE(label_example, LabelExampleView) {
  // TODO: add an example with dynamic type.
  // http://qiita.com/koogawa/items/1011962b444420b854d7
  // http://stackoverflow.com/questions/20510094/how-to-use-a-custom-font-with-dynamic-text-sizes-in-ios7
  return label(@"hoge");
}
