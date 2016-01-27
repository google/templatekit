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

#import "SpaceExample.h"

#import "TemplateKit.h"


@implementation SpaceExampleViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    _nonnilImage = [UIImage imageNamed:@"duck"];
  }
  return self;
}

@end


@implementation SpaceExampleView
@end

TPL_DEFINE_VIEW_TEMPLATE(space_example, SpaceExampleView) {
  UIColor *ultralighGray = [UIColor colorWithWhite:0.8 alpha:1];
  UIColor *white = [UIColor whiteColor];

  return column(row(image($(nonnilImage)),
                    margin(@20),
                    image($(nonnilImage)),
                    margin(@20),
                    image($(nonnilImage)),
                    nil)
                  .background_color(white),
                margin(@20),

                row(image($(nilImage)),
                    margin(@20),
                    image($(nonnilImage)),
                    margin(@20),
                    image($(nonnilImage)),
                    nil)
                  .background_color(white),
                margin(@20),

                row(image($(nonnilImage)),
                    margin(@20),
                    image($(nilImage)),
                    margin(@20),
                    image($(nonnilImage)),
                    nil)
                  .background_color(white),
                margin(@20),

                row(image($(nonnilImage)),
                    margin(@20),
                    image($(nonnilImage)),
                    margin(@20),
                    image($(nilImage)),
                    nil)
                  .background_color(white),
                margin(@20),

                row(row(image($(nonnilImage)),
                        margin(@20),
                        image($(nonnilImage)),
                        nil)
                      .background_color(white),
                    margin(@20),
                    row(image($(nilImage)),
                        margin(@20),
                        image($(nilImage)),
                        nil)
                      .background_color(white),
                    nil)
                  .background_color([UIColor redColor]),

                nil)
              .background_color(ultralighGray);
}
