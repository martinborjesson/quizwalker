//
//  NetCommunication.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-12.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetCommunication;

@protocol ServerAnswerDelegate <NSObject>

-(void)answerFromServer:(NetCommunication *)controller serverAnswer:(NSString *)answer;

@end


@interface NetCommunication : NSObject

@property(weak, nonatomic) id<ServerAnswerDelegate> delegate;

@end
