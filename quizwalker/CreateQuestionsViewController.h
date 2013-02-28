//
//  CreateQuestionsViewController.h
//  quizwalker
//
//  Created by Martin Börjesson on 2013-02-24.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface CreateQuestionsViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *QuestionTextView;

- (IBAction)PreviousButton:(id)sender;
- (IBAction)NextButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *PreviousButtonOutlet;

@property (weak, nonatomic) IBOutlet UITextField *TextFieldOne;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldTwo;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldThree;

@property (weak, nonatomic) IBOutlet UISwitch *AnswerSwitch1;
@property (weak, nonatomic) IBOutlet UISwitch *AnswerSwitch2;
@property (weak, nonatomic) IBOutlet UISwitch *AnswerSwitch3;

@property (nonatomic,strong) NSMutableArray *StoredQuestions;
@property (nonatomic) int PositionInStoredQuestions;
@property (nonatomic) int CorrectAnswer;

- (IBAction)AnswerSwitchFlipped1:(id)sender;
- (IBAction)AnswerSwitchFlipped2:(id)sender;
- (IBAction)AnswerSwitchFlipped3:(id)sender;

- (BOOL)stringNotEmpty:(NSString *)theString;
- (void)fillView:(int) position;
- (void)clearView;
- (void)insertObjectIntoStorage;
- (void)updateObjectInStorage:(int)Position;

@end
