/**
 * Beijing Sankuai Online Technology Co.,Ltd (Meituan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

#import "UITextField+EZR_Extension.h"
#import <objc/runtime.h>


@implementation UITextField (EZR_Extension)

- (EZRMutableNode<NSString *> *)ezr_textNode {
    EZRMutableNode<NSString *> *node = objc_getAssociatedObject(self, @selector(ezr_textNode));
    if (node == nil) {
        node = [self generatorTextNode];
        objc_setAssociatedObject(self, @selector(ezr_textNode), node, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return node;
}

- (EZRMutableNode<NSString *> *)generatorTextNode {
    EZRMutableNode<NSString *> *node = [EZRMutableNode new];
    @ezr_weakify(self, node)
    [[node listenedBy:self] withContextBlock:^(NSString * _Nullable next, id  _Nullable context) {
        @ezr_strongify(self)
        if (![context isEqualToString:[self uniqueContext]]) {
            self.text = next;
        }
    }];
    [self addTarget:self action:@selector(ezr_textChanged:) forControlEvents:UIControlEventEditingChanged];
    [[EZR_PATH(self, text) listenedBy:self] withBlock:^(id  _Nullable next) {
        @ezr_strongify(self, node)
        [node setValue:next context:[self uniqueContext]];
    }];
    return node;
}

- (IBAction)ezr_textChanged:(UITextField *)sender {
    [sender.ezr_textNode setValue:sender.text context:[sender uniqueContext]];
}

- (NSString *)uniqueContext {
    return [NSString stringWithFormat:@"ezr_updateText_%p", self];
}

@end
