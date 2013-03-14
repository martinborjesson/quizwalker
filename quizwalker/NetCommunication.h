//
//  NetCommunication.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-12.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetCommunication;

@protocol NetCommunicationDelegate <NSObject>

-(void)answerFromServer:(NetCommunication *)controller serverAnswer:(NSString *)answer;

@end

@interface NetCommunication : NSObject <NSURLConnectionDelegate>

@property (retain, nonatomic) NSURLConnection *Connection;
@property (weak, nonatomic) id<NetCommunicationDelegate> delegate;
@property (nonatomic,strong) NSMutableData *ReturnData;

-(void) postMessageToServer:(BOOL)encrypted FileName:(NSString *)filename Parameters:(NSString *)para;

@end
