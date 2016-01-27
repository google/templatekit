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

#import "Internal/DescriptorImpls/TPLImageDescriptor.h"

#import "Internal/Core/TPLCoreMacros.h"


@implementation TPLImageDescriptor

- (UIView *)uninitializedView {
  return [[UIImageView alloc] init];
}

- (void)setData:(id)data toView:(UIView *)view {
  DOWNCAST(view, UIImageView).image = DOWNCAST(data, UIImage);
}

- (CGSize)viewSizeThatFits:(CGSize)size withData:(id)data {
  return DOWNCAST(data, UIImage).size;
}

@end
