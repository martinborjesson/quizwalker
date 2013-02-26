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

@property (weak, nonatomic) IBOutlet UITextField *TextFieldOne;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldTwo;
@property (weak, nonatomic) IBOutlet UITextField *TextFieldThree;

@property (nonatomic,strong) NSMutableArray *StoredQuestions;

- (BOOL)stringNotEmpty:(NSString *)theString;

@end
