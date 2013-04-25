//
//  LoginAlertBox.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-04-10.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CODialog.h"
#import "NetCommunication.h"

@class LoginAlertBox;

@protocol LoginAlertBoxDelegate <NSObject>

-(void)UserDataUpdated:(LoginAlertBox *)alertBox username:(NSString *)user password:(NSString *)pass email:(NSString *)em;

@end

@interface LoginAlertBox : NSObject <NetCommunicationDelegate>

@property (nonatomic,strong) CODialog *Dialog;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *email;

@property(weak, nonatomic) id<LoginAlertBoxDelegate> delegate;

-(id)initWithTitle:(NSString *)title Window:(UIWindow *)window;
-(void)showWithTitle:(NSString *)title;

@end
