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

#import "EZRFilterViewController.h"
#import <EasyReact/EasyReact.h>
#import "UITextField+EZR_Extension.h"
#import "EZRJSVM.h"

@interface EZRFilterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *aTextField;
@property (weak, nonatomic) IBOutlet UITextField *filterTextField;
@property (weak, nonatomic) IBOutlet UITextField *bTextField;
@property (strong, nonatomic) EZRJSVM *jsvm;

@end

@implementation EZRFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jsvm = [EZRJSVM new];
    
    EZRNode *node = [self.aTextField.ezr_textNode filter:self.filterBlock];
    [self.bTextField.ezr_textNode linkTo:node];
    
    // calculate again if map text field changes
    @ezr_weakify(self)
    [[self.filterTextField.ezr_textNode listenedBy:self] withBlock:^(NSString * _Nullable next) {
        @ezr_strongify(self)
        if (self.filterBlock(next)) {
            self.bTextField.text = self.aTextField.text;
        }
    }];
}

- (EZSFliterBlock)filterBlock {
    @ezr_weakify(self)
    return ^BOOL(NSString * _Nullable next) {
        @ezr_strongify(self)
        JSValue *value = [self.jsvm eval:self.filterTextField.text params:@{@"a": self.aTextField.text}];
        return [value toBool];
    };
}

@end
