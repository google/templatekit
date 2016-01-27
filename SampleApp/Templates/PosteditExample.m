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

#import "PosteditExample.h"

#import "TemplateKit.h"

static const NSInteger kTagThumbnail;
static const NSInteger kTagTitle;

@implementation PosteditExampleViewModel
@end


@implementation PosteditExampleView

- (void)didLayoutSubviews {
  UIImageView *thumbnail = [self viewWithTag:kTagThumbnail];
  CGRect thumbnailFrame = [thumbnail.superview convertRect:thumbnail.frame toView:self];
  NSLog(@"thumbnail: %@ -> %@",
        NSStringFromCGRect(thumbnail.frame),
        NSStringFromCGRect(thumbnailFrame));
  UILabel *title = [self viewWithTag:kTagTitle];
  CGRect titleFrame = [title.superview convertRect:title.frame toView:self];
  NSLog(@"title: %@ -> %@",
        NSStringFromCGRect(title.frame),
        NSStringFromCGRect(titleFrame));
}

@end

TPL_DEFINE_VIEW_TEMPLATE(postedit_example, PosteditExampleView) {
  options.postedit(YES);

  return row(column(image([UIImage imageNamed:@"duck"])
                      .tag(@(kTagThumbnail)),
                    nil),
             column(label(@"First Line")
                      .tag(@(kTagTitle)),
                    margin(@10),
                    label(@"Second Line"),
                    nil),
             nil)
           .padding(TPLEdgeInsetsMake(5, 5, 5, 5));
}
