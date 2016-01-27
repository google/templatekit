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

#import <UIKit/UIKit.h>

@class TPLBuilder;
@class TPLBuilderFactoryExtension;
@class TPLSelectorWrapper;

typedef TPLBuilder *(^TPLBuilderBlock0)();
typedef TPLBuilder *(^TPLBuilderBlock1)(id);
typedef TPLBuilder *(^TPLBuilderBlockVariadic)(id, ...);
typedef TPLBuilder *(^TPLBuilderBoolBlock1)(BOOL);
typedef TPLSelectorWrapper *(^TPLSelectorWrapperBlock)(SEL);
typedef TPLBuilder *(^TPLBuilderCondBlock)(TPLSelectorWrapper *, TPLBuilder *, TPLBuilder *);


typedef void (^TPLBuilderOptionBlock)(BOOL);
@interface TPLBuilderOptions : NSObject
@property(nonatomic, readonly) TPLBuilderOptionBlock postedit;
@end

@interface TPLBuilderFactory : NSObject

@property(nonatomic, readonly) TPLBuilderBlock1 activity_indicator;
@property(nonatomic, readonly) TPLSelectorWrapperBlock bind;
@property(nonatomic, readonly) TPLBuilderBlockVariadic column;
@property(nonatomic, readonly) TPLBuilderCondBlock cond;

typedef TPLBuilder *(^TPLBuilderGridBlock)(TPLBuilder *);
@property(nonatomic, readonly) TPLBuilderGridBlock grid;

@property(nonatomic, readonly) TPLBuilderBlock1 image;
@property(nonatomic, readonly) TPLBuilderBlock1 label;

@property(nonatomic, readonly) TPLBuilderBlockVariadic layer;

@property(nonatomic, readonly) TPLBuilderBlock1 margin;

typedef TPLBuilder *(^TPLBuilderRepeatedBlock)(TPLBuilder *);
@property(nonatomic, readonly) TPLBuilderRepeatedBlock repeated;

@property(nonatomic, readonly) TPLBuilderBlockVariadic row;
@property(nonatomic, readonly) TPLBuilderBlock1 space;

@end


@interface TPLBuilder : NSObject

#define TPL_BUILTIN_VIEW_ATTRIBUTE0(name__) \
  @property(nonatomic, strong, readonly) TPLBuilder *(^name__)()

#define TPL_BUILTIN_VIEW_ATTRIBUTE1(name__) \
  @property(nonatomic, strong, readonly) TPLBuilder *(^name__)(id)

TPL_BUILTIN_VIEW_ATTRIBUTE1(accessible);
TPL_BUILTIN_VIEW_ATTRIBUTE1(align);
TPL_BUILTIN_VIEW_ATTRIBUTE1(background_color);
TPL_BUILTIN_VIEW_ATTRIBUTE1(corner_radius);
TPL_BUILTIN_VIEW_ATTRIBUTE1(grid_config);
TPL_BUILTIN_VIEW_ATTRIBUTE0(h_shrinkable);
TPL_BUILTIN_VIEW_ATTRIBUTE0(h_stretchable);
TPL_BUILTIN_VIEW_ATTRIBUTE1(height);
TPL_BUILTIN_VIEW_ATTRIBUTE1(hidden);
TPL_BUILTIN_VIEW_ATTRIBUTE1(interval);
TPL_BUILTIN_VIEW_ATTRIBUTE1(layout_config);
TPL_BUILTIN_VIEW_ATTRIBUTE0(no_rtl);
TPL_BUILTIN_VIEW_ATTRIBUTE0(not_accessible);
TPL_BUILTIN_VIEW_ATTRIBUTE1(padding);
TPL_BUILTIN_VIEW_ATTRIBUTE1(position);
TPL_BUILTIN_VIEW_ATTRIBUTE1(size);
TPL_BUILTIN_VIEW_ATTRIBUTE1(tag);
TPL_BUILTIN_VIEW_ATTRIBUTE0(tappable);
TPL_BUILTIN_VIEW_ATTRIBUTE0(v_stretchable);
TPL_BUILTIN_VIEW_ATTRIBUTE1(width);

#undef TPL_BUILTIN_VIEW_ATTRIBUTE0
#undef TPL_BUILTIN_VIEW_ATTRIBUTE1

@end


@interface TPLSelectorWrapper : NSObject

@property(nonatomic, assign, readonly) SEL selector;

- (instancetype)initWithSelector:(SEL)selector;

@end
