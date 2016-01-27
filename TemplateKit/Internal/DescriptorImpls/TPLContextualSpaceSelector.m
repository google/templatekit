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

#import "Internal/DescriptorImpls/TPLContextualSpaceSelector.h"

static void ContextualSpaceSelectorFinalize(TPLContextualSpaceSelectorRef selector);

typedef struct {
  BOOL isSpace;
  BOOL isHidden;
} TPLContextualSpaceSelectorInput;

typedef struct TPLContextualSpaceSelector {
  NSInteger inputCount;
  NSInteger nextInputIndex;
  TPLContextualSpaceSelectorInput *input;
  NSInteger spaceToBeHiddenCount;
  NSInteger *spaceToBeHiddenIndexes;
} TPLContextualSpaceSelector;

TPLContextualSpaceSelectorRef TPLContextualSpaceSelectorCreate(NSInteger numberOfViews) {
  TPLContextualSpaceSelectorRef selector = malloc(sizeof(TPLContextualSpaceSelector));
  selector->inputCount = numberOfViews;
  selector->nextInputIndex = 0;
  selector->input = malloc(sizeof(TPLContextualSpaceSelectorInput) * numberOfViews);
  selector->spaceToBeHiddenCount = 0;
  selector->spaceToBeHiddenIndexes = malloc(sizeof(NSInteger) * numberOfViews);
  return selector;
}

void TPLContextualSpaceSelectorDelete(TPLContextualSpaceSelectorRef selector) {
  free(selector->input);
  free(selector->spaceToBeHiddenIndexes);
  free(selector);
}

void TPLContextualSpaceSelectorAddView(TPLContextualSpaceSelectorRef selector, BOOL isHidden) {
  assert(selector->nextInputIndex < selector->inputCount);

  TPLContextualSpaceSelectorInput *input = &selector->input[selector->nextInputIndex];
  input->isSpace = NO;
  input->isHidden = isHidden;
  ++selector->nextInputIndex;

  if (selector->nextInputIndex == selector->inputCount) {
    ContextualSpaceSelectorFinalize(selector);
  }
}

void TPLContextualSpaceSelectorAddContextualSpace(TPLContextualSpaceSelectorRef selector) {
  assert(selector->nextInputIndex < selector->inputCount);

  TPLContextualSpaceSelectorInput *input = &selector->input[selector->nextInputIndex];
  input->isSpace = YES;
  input->isHidden = NO;
  ++selector->nextInputIndex;

  if (selector->nextInputIndex == selector->inputCount) {
    ContextualSpaceSelectorFinalize(selector);
  }
}

NSInteger TPLContextualSpaceSelectorGetSpaceToBeHiddenCount(TPLContextualSpaceSelectorRef selector) {
  assert(selector->nextInputIndex == selector->inputCount);

  return selector->spaceToBeHiddenCount;
}

NSInteger *TPLContextualSpaceSelectorGetSpaceToBeHiddenIndexes(TPLContextualSpaceSelectorRef selector) {
  assert(selector->nextInputIndex == selector->inputCount);

  return selector->spaceToBeHiddenIndexes;
}

static void ContextualSpaceSelectorFinalize(TPLContextualSpaceSelectorRef selector) {
  BOOL hasPrecedingView = NO;
  NSInteger pendingSpaceIndex = -1;
  for (NSInteger index = 0; index < selector->inputCount; ++index) {
    TPLContextualSpaceSelectorInput *input = &selector->input[index];
    if (input->isSpace) {
      if (hasPrecedingView) {
        pendingSpaceIndex = index;
      } else {
        input->isHidden = YES;
      }
      hasPrecedingView = NO;
    } else {
      if (!input->isHidden) {
        pendingSpaceIndex = -1;
        hasPrecedingView = YES;
      }
    }
  }
  if (pendingSpaceIndex >= 0) {
    selector->input[pendingSpaceIndex].isHidden = YES;
  }

  for (NSInteger index = 0; index < selector->inputCount; ++index) {
    const TPLContextualSpaceSelectorInput input = selector->input[index];
    if (input.isSpace && input.isHidden) {
      selector->spaceToBeHiddenIndexes[selector->spaceToBeHiddenCount] = index;
      ++selector->spaceToBeHiddenCount;
    }
  }
}
