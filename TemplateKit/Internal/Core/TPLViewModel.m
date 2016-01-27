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

#import "Internal/Core/TPLViewModel+Internal.h"

#import "Internal/Core/TPLCoreMacros.h"
#import "Internal/Core/TPLRootView+Internal.h"


@implementation TPLEvent
@end


@implementation TPLViewModel

- (BOOL)handleEvent:(TPLEvent *)event {
  return NO;
}

- (void)__didFireTouchUpInside:(id)sender {
  TPLEvent *event = [[TPLEvent alloc] init];
  event.view = DOWNCAST(sender, UIControl);
  event.viewModel = self;
  event.controlEvent = UIControlEventTouchUpInside;
  [self processEvent:event];
}

- (void)__didFireValueChanged:(id)sender {
  TPLEvent *event = [[TPLEvent alloc] init];
  event.view = DOWNCAST(sender, UIControl);
  event.viewModel = self;
  event.controlEvent = UIControlEventValueChanged;
  [self processEvent:event];
}

- (void)__didRecognizeTapGesture:(id)sender {
  TPLEvent *event = [[TPLEvent alloc] init];
  UITapGestureRecognizer *recognizer = DOWNCAST(sender, UITapGestureRecognizer);
  event.view = recognizer.view;
  event.viewModel = self;
  event.gestureRecognizer = recognizer;
  [self processEvent:event];
}

- (void)processEvent:(TPLEvent *)event {
  TPLRootView *rootView = TPLRootViewWithView(event.view);
  event.rootView = (TPLView *)rootView;
  while (rootView) {
    TPLViewModel *viewModel = rootView.viewModel;
    if (viewModel.eventDelegate) {
      [viewModel.eventDelegate viewModel:viewModel didReceiveEvent:event];
      return;
    } else if ([viewModel handleEvent:event]) {
      return;
    }
    rootView = TPLRootViewWithView([rootView superview]);
  }
  assert(0);
}

@end

TPLViewModel *TPLViewModelWithView(UIView *view) {
  return TPLRootViewWithView(view).viewModel;
}
