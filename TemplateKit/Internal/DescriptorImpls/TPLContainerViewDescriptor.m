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

#import "Internal/DescriptorImpls/TPLContainerViewDescriptor.h"

#import "Internal/Core/TPLBenchmark.h"
#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLViewDescriptor.h"
#import "Public/Core/TPLDebugger.h"

@implementation TPLContainerView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _tpl_subviews = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)removeAllSubviews {
  for (UIView *subview in _tpl_subviews) {
    [subview removeFromSuperview];
  }
  [_tpl_subviews removeAllObjects];
}

- (void)layoutSubviews {
#if TPL_ENABLE_DEBUGGING
  if ([TPLDebugger isDebuggingEnabledForView:self]) {
    NSLog(@"%zd:%p layoutSubviews frame:%@",
          self.tag,
          self,
          NSStringFromCGRect(self.frame));
  }
#endif  // TPL_ENABLE_DEBUGGING

  TPL_BENCHMARK(1, view_layout, self.tpl_descriptor) {
    [super layoutSubviews];
    [(id<TPLContainerViewDescriptor>)self.tpl_descriptor layoutSubviewsInContainerView:self];
  }
}

#if TPL_ENABLE_DEBUGGING
- (void)setFrame:(CGRect)frame {
  if ([TPLDebugger isDebuggingEnabledForView:self]) {
    NSLog(@"%zd:%p setFrame oldFrame:%@ newFrame:%@",
          self.tag,
          self,
          NSStringFromCGRect(self.frame),
          NSStringFromCGRect(frame));
  }

  [super setFrame:frame];
}
#endif  // TPL_ENABLE_DEBUGGING

#if TPL_ENABLE_DEBUGGING
- (void)setBounds:(CGRect)bounds {
  if ([TPLDebugger isDebuggingEnabledForView:self]) {
    NSLog(@"%zd:%p setFrame oldBounds:%@ newBounds:%@",
          self.tag,
          self,
          NSStringFromCGRect(self.bounds),
          NSStringFromCGRect(bounds));
  }

  [super setBounds:bounds];
}
#endif  // TPL_ENABLE_DEBUGGING

#if TPL_ENABLE_DEBUGGING
- (void)setNeedsLayout {
  if ([TPLDebugger isDebuggingEnabledForView:self]) {
    NSLog(@"%zd:%p setNeedsLayout frame:%@",
          self.tag,
          self,
          NSStringFromCGRect(self.frame));
  }

  [super setNeedsLayout];
}
#endif  // TPL_ENABLE_DEBUGGING

@end
