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

#import "Internal/DescriptorImpls/TPLClientDataViewDescriptor.h"


@implementation TPLClientDataViewDescriptor

- (void)setAdapter:(id<TPLDataViewAdapter>)adapter {
  _adapter = adapter;
  if ([_adapter respondsToSelector:@selector(activatedControlEvents)]) {
    self.activatedControlEvents = [_adapter activatedControlEvents];
  }
}

- (UIView *)uninitializedView {
  return [_adapter view];
}

- (void)setData:(id)data toView:(UIView *)view {
  [_adapter setData:data toView:view];
}

- (CGSize)viewSizeThatFits:(CGSize)size withData:(id)data {
  CGSize result = CGSizeZero;
  if ([_adapter respondsToSelector:@selector(viewSizeThatFits:withData:)]) {
    result = [_adapter viewSizeThatFits:size withData:data];
  } else {
    UIView *view = [self view];
    [self setData:data toView:view];
    result = [view sizeThatFits:size];
  }
  return result;
}

@end
