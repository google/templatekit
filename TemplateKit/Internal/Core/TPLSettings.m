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

#import "Public/Core/TPLSettings.h"

static NSNumber *g_isRTLOverride = nil;


@implementation TPLSettings

+ (BOOL)isRTL {
  if (g_isRTLOverride) {
    return [g_isRTLOverride boolValue];
  } else {
    NSString *languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    NSLocaleLanguageDirection characterDirection =
    [NSLocale characterDirectionForLanguage:languageCode];
    BOOL regionLanguageDirectionIsRTL = (characterDirection == NSLocaleLanguageDirectionRightToLeft);
    return regionLanguageDirectionIsRTL;
  }
}

+ (void)setIsRTLOverride:(BOOL)isRTLOverride {
  g_isRTLOverride = @(isRTLOverride);
}

+ (void)clearIsRTLOverride {
  g_isRTLOverride = nil;
}

@end
