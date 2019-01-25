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

#import "EZRCombineViewController.h"
#import <EasyReact/EasyReact.h>
#import "UITextField+EZR_Extension.h"
#import "EZRJSVM.h"

@interface EZRCombineViewController ()
    
@property (weak, nonatomic) IBOutlet UITextField *aTextField;
@property (weak, nonatomic) IBOutlet UITextField *bTextField;
@property (weak, nonatomic) IBOutlet UITextField *cTextField;
@property (weak, nonatomic) IBOutlet UITextField *mapTextField;
@property (strong, nonatomic) EZRJSVM *jsvm;

@end

@implementation EZRCombineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jsvm = [EZRJSVM new];
    @ezr_weakify(self)
    EZRNode *node = [EZRCombine(self.aTextField.ezr_textNode, self.bTextField.ezr_textNode, self.mapTextField.ezr_textNode) mapEach:^NSString *(NSString *a, NSString *b, NSString *map) {
        @ezr_strongify(self)
        JSValue *value = [self.jsvm eval:map params:@{@"a": @(a.intValue), @"b": @(b.intValue)}];
        return [value toString];
    }];

    [self.cTextField.ezr_textNode linkTo:node];
}

@end
