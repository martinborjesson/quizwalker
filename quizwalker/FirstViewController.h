//
//  ViewController.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-02-24.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CODialog.h"
#import "NetCommunication.h"

@interface FirstViewController : UIViewController <NetCommunicationDelegate>

@property (nonatomic,strong) CODialog *Dialog;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *email;

@end
