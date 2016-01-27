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

#import "LayerExample.h"

#import "TemplateKit.h"


@implementation LayerExampleViewModel
@end


@implementation LayerExampleView
@end

TPL_DEFINE_VIEW_TEMPLATE(layer_example, LayerExampleView) {
  return layer(layer(label(@"front text")
                       .background_color([UIColor whiteColor])
                       .position(left),
                     label(@"back text")
                       .position(right),
                     nil)
                 .size(TPLSizeMake(120, 80))
                 .background_color([UIColor redColor])
                 .position(top_left),
               layer(label(@"front text")
                       .background_color([UIColor whiteColor])
                       .position(right),
                     label(@"back text")
                       .position(left),
                     nil)
                 .size(TPLSizeMake(120, 80))
                 .background_color([UIColor greenColor])
                 .position(bottom_right),
               label(@"")
                 .size(TPLSizeMake(240, 240))
                 .background_color([UIColor blueColor]),
               nil);
}
