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

#import "RTLExample.h"

#import "TemplateKit.h"

static const NSInteger kTagSwitch = 100;


@interface MySwitchAdapter : NSObject <TPLSimpleViewAdapter>
@end

@implementation MySwitchAdapter

- (UIView *)view {
  return [[UISwitch alloc] init];
}

- (UIControlEvents)activatedControlEvents {
  return UIControlEventValueChanged;
}

@end

TPL_DEFINE_SIMPLE_VIEW_ADAPTER(my_switch, MySwitchAdapter);


@implementation RTLExampleViewModel

- (BOOL)handleEvent:(TPLEvent *)event {
  if (event.view.tag == kTagSwitch && event.controlEvent == UIControlEventValueChanged) {
    [TPLSettings setIsRTLOverride:[(UISwitch *)event.view isOn]];
    [event.rootView reloadViewModel];
    return YES;
  } else {
    return NO;
  }
}

@end


@implementation RTLExampleView
@end

TPL_DEFINE_VIEW_TEMPLATE(rtl_example, RTLExampleView) {
  return column(label(@"aa")
                  .position(left),
                label(@"bb")
                  .position(center),
                label(@"cc")
                  .position(right),
                label(@"aa")
                  .position(left)
                  .no_rtl(),
                label(@"bb")
                  .position(center)
                  .no_rtl(),
                label(@"cc")
                  .position(right)
                  .no_rtl(),
                ext.my_switch()
                  .tag(@(kTagSwitch)),
                nil);
}
