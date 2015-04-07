//
//  LoginViewController.h
//  Work01
//
//  Created by kwj on 14/11/25.
//  Copyright (c) 2014年 wwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Loading.h"
#import "RegisterViewController.h"

@interface LoginViewController : UIViewController<LoadBDConnectionDataDelegate,registerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

- (IBAction)loginButton_Click:(id)sender;

- (IBAction)findPwdButton_Click:(id)sender;

- (IBAction)registerButton_Click:(id)sender;

@end
