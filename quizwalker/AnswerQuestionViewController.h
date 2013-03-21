//
//  AnswerQuestionViewController.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-17.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class AnswerQuestionViewController;

@protocol ReturnAnswerDelegate <NSObject>

-(void)ReturnAnswer:(AnswerQuestionViewController *)controller SelectedAnswer:(int)answer;

@end

@interface AnswerQuestionViewController : UIViewController

@property (nonatomic,strong) NSString *Question;
@property (nonatomic,strong) NSString *Answer1;
@property (nonatomic,strong) NSString *Answer2;
@property (nonatomic,strong) NSString *Answer3;
@property (weak, nonatomic) IBOutlet UILabel *QuestionTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *AnswerButton1;
@property (weak, nonatomic) IBOutlet UIButton *AnswerButton2;
@property (weak, nonatomic) IBOutlet UIButton *AnswerButton3;
@property (weak, nonatomic) id<ReturnAnswerDelegate> delegate;
- (IBAction)AnswerButtonOnePressed:(id)sender;
- (IBAction)AnswerButtonTwoPressed:(id)sender;
- (IBAction)AnswerButtonThreePressed:(id)sender;

@end
