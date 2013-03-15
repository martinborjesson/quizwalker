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

-(void)answerFromServer:(NetCommunication *)controller callToServer:(NSString *)call numberOfTimes:(int)number serverAnswer:(NSString *)answer;

@end

@interface NetCommunication : NSObject <NSURLConnectionDelegate>

@property (retain, nonatomic) NSURLConnection *Connection;
@property (weak, nonatomic) id<NetCommunicationDelegate> delegate;
@property (nonatomic,strong) NSMutableData *ReturnData;
@property (nonatomic,strong) NSString *callToServer;
@property (nonatomic,strong) NSString *previousCallToServer;
@property (nonatomic) int callCounter;

-(void) postMessageToServerAsync:(BOOL)encrypted FileName:(NSString *)filename Parameters:(NSString *)para;
- (NSString *)postMessageToServerSync:(NSString *)filename Parameters:(NSString *)para;
@end
