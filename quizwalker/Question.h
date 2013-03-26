//
//  Question.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-02-26.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic,strong) NSString *Question;
@property (nonatomic,strong) NSString *Answer1;
@property (nonatomic,strong) NSString *Answer2;
@property (nonatomic,strong) NSString *Answer3;
@property (nonatomic) int CorrectAnswer;

@end
