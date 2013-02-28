//
//  CreateQuestionsViewController.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-02-24.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "CreateQuestionsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CreateQuestionsViewController ()

@end

@implementation CreateQuestionsViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 97;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Create frame for textview
    [self.QuestionTextView.layer setBorderColor:
     [[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0] CGColor]];
    [self.QuestionTextView.layer setBorderWidth: 2.0];
    [self.QuestionTextView.layer setCornerRadius:8.0f];
    [self.QuestionTextView.layer setMasksToBounds:YES];
    //Attach delegates
    self.TextFieldOne.delegate = self;
    self.TextFieldTwo.delegate = self;
    self.TextFieldThree.delegate = self;
    self.QuestionTextView.delegate = self;
    //Create Array
    self.StoredQuestions = [[NSMutableArray alloc] init];
    self.PositionInStoredQuestions = 0;
    //set correct answer
    self.CorrectAnswer = 1;
    //Create first object
    [self insertObjectIntoStorage];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Remove keyboard on rotation
    if(self.QuestionTextView.isFirstResponder)
    {
        [self.QuestionTextView resignFirstResponder];
    }
    if(self.TextFieldOne.isFirstResponder)
    {
        [self.TextFieldOne resignFirstResponder];
    }
    if(self.TextFieldTwo.isFirstResponder)
    {
        [self.TextFieldTwo resignFirstResponder];
    }
    if(self.TextFieldThree.isFirstResponder)
    {
        [self.TextFieldThree resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //Animate to prevent keyboard from covering textfield
    CGRect viewFrame = self.view.frame;

    if(([UIApplication sharedApplication].statusBarOrientation == 1)||([UIApplication sharedApplication].statusBarOrientation == 2))
    {
        viewFrame.origin.y -= PORTRAIT_KEYBOARD_HEIGHT;
    }
    if(([UIApplication sharedApplication].statusBarOrientation == 3)||([UIApplication sharedApplication].statusBarOrientation == 4))
    {
        viewFrame.origin.y -= LANDSCAPE_KEYBOARD_HEIGHT;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //Animate to restore placement
    CGRect viewFrame = self.view.frame;
    
    if(([UIApplication sharedApplication].statusBarOrientation == 1)||([UIApplication sharedApplication].statusBarOrientation == 2))
    {
        viewFrame.origin.y += PORTRAIT_KEYBOARD_HEIGHT;
    }
    if(([UIApplication sharedApplication].statusBarOrientation == 3)||([UIApplication sharedApplication].statusBarOrientation == 4))
    {
        viewFrame.origin.y += LANDSCAPE_KEYBOARD_HEIGHT;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //End input when user press return
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //End input when user press return
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (IBAction)PreviousButton:(id)sender
{
    if([self stringNotEmpty:self.QuestionTextView.text]&&[self stringNotEmpty:self.TextFieldOne.text]&&[self stringNotEmpty:self.TextFieldTwo.text]&&[self stringNotEmpty:self.TextFieldThree.text])
    {
        //Try to store current text view data
        [self updateObjectInStorage:self.PositionInStoredQuestions];
        self.PositionInStoredQuestions--;
        //Get new view data
        [self fillView:self.PositionInStoredQuestions];
        if(self.PositionInStoredQuestions == 0)
        {
            [self.PreviousButtonOutlet setEnabled:NO];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"ALERT_MSG_INPUT_ERROR_TITLE",nil)
                                                        message: NSLocalizedString(@"ALERT_MSG_INPUT_ERROR_MESSAGE",nil)
                                                       delegate:nil
                                              cancelButtonTitle: NSLocalizedString(@"OK_BUTTON",nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)NextButton:(id)sender
{
    if([self stringNotEmpty:self.QuestionTextView.text]&&[self stringNotEmpty:self.TextFieldOne.text]&&[self stringNotEmpty:self.TextFieldTwo.text]&&[self stringNotEmpty:self.TextFieldThree.text])
    {
        //Create new object?
        if(self.PositionInStoredQuestions == self.StoredQuestions.count-1)
        {
            [self updateObjectInStorage:self.PositionInStoredQuestions];
            [self clearView];
            [self insertObjectIntoStorage];
            self.PositionInStoredQuestions++;
        }
        else
        {
            [self updateObjectInStorage:self.PositionInStoredQuestions];
            self.PositionInStoredQuestions++;
            [self fillView:self.PositionInStoredQuestions];
        }
        if(self.PositionInStoredQuestions > 0)
        {
            [self.PreviousButtonOutlet setEnabled:YES];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"ALERT_MSG_INPUT_ERROR_TITLE",nil)
                                                        message: NSLocalizedString(@"ALERT_MSG_INPUT_ERROR_MESSAGE",nil)
                                                       delegate:nil
                                              cancelButtonTitle: NSLocalizedString(@"OK_BUTTON",nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)fillView:(int)position
{
    //Write data from StoredQuestions to textviews
    Question *CurrentQuestion = [self.StoredQuestions objectAtIndex:position];
    self.QuestionTextView.text = CurrentQuestion.Question;
    self.TextFieldOne.text = CurrentQuestion.Answer1;
    self.TextFieldTwo.text = CurrentQuestion.Answer2;
    self.TextFieldThree.text = CurrentQuestion.Answer3;
    self.CorrectAnswer = CurrentQuestion.CorrectAnswer;
    
    if(CurrentQuestion.CorrectAnswer == 1)
    {
        [self.AnswerSwitch1 setOn:YES animated:YES];
        [self.AnswerSwitch2 setOn:NO animated:YES];
        [self.AnswerSwitch3 setOn:NO animated:YES];
    }
    if(CurrentQuestion.CorrectAnswer == 2)
    {
        [self.AnswerSwitch1 setOn:NO animated:YES];
        [self.AnswerSwitch2 setOn:YES animated:YES];
        [self.AnswerSwitch3 setOn:NO animated:YES];
    }
    if(CurrentQuestion.CorrectAnswer == 3)
    {
        [self.AnswerSwitch1 setOn:NO animated:YES];
        [self.AnswerSwitch2 setOn:NO animated:YES];
        [self.AnswerSwitch3 setOn:YES animated:YES];
    }
}

- (void)updateObjectInStorage:(int)Position
{
    //Update object
    Question *CurrentQuestion = [[Question alloc] init];
    CurrentQuestion.Question = self.QuestionTextView.text;
    CurrentQuestion.Answer1 = self.TextFieldOne.text;
    CurrentQuestion.Answer2 = self.TextFieldTwo.text;
    CurrentQuestion.Answer3 = self.TextFieldThree.text;
    CurrentQuestion.CorrectAnswer = self.CorrectAnswer;
    [self.StoredQuestions replaceObjectAtIndex:Position withObject:CurrentQuestion];
}

- (void)insertObjectIntoStorage
{
    //Store question in array
    Question *theQuestion = [[Question alloc] init];
    theQuestion.Question = self.QuestionTextView.text;
    theQuestion.Answer1 = self.TextFieldOne.text;
    theQuestion.Answer2 = self.TextFieldTwo.text;
    theQuestion.Answer3 = self.TextFieldThree.text;
    theQuestion.CorrectAnswer = self.CorrectAnswer;
    [self.StoredQuestions insertObject:theQuestion atIndex:self.StoredQuestions.count];
}

-(void)clearView
{
    //Reset the text
    self.QuestionTextView.text = [NSString stringWithFormat:@"%d.",self.StoredQuestions.count+1];
    self.TextFieldOne.text = @"";
    self.TextFieldTwo.text = @"";
    self.TextFieldThree.text = @"";
    
    [self.AnswerSwitch1 setOn:YES animated:YES];
    [self.AnswerSwitch2 setOn:NO animated:YES];
    [self.AnswerSwitch3 setOn:NO animated:YES];
    self.CorrectAnswer = 1;
}

- (BOOL)stringNotEmpty:(NSString *)theString
{
    if([theString length] == 0)
        return NO;
    for (int counter=0; counter<[theString length]; counter++)
    {
        if([theString characterAtIndex:counter] != ' ')
        {
            return YES;
        }
    }
    return NO;
}

- (IBAction)AnswerSwitchFlipped1:(id)sender
{
    if([self.AnswerSwitch1 isOn] == YES)
    {
        self.CorrectAnswer = 1;
        [self.AnswerSwitch2 setOn:NO animated:YES];
        [self.AnswerSwitch3 setOn:NO animated:YES];
    }
    else
    {
        self.CorrectAnswer = 2;
        [self.AnswerSwitch2 setOn:YES animated:YES];
        [self.AnswerSwitch3 setOn:NO animated:YES];
    }
    NSLog(@"Correct Answer: %d",self.CorrectAnswer);
}

- (IBAction)AnswerSwitchFlipped2:(id)sender
{
    if([self.AnswerSwitch2 isOn] == YES)
    {
        self.CorrectAnswer = 2;
        [self.AnswerSwitch1 setOn:NO animated:YES];
        [self.AnswerSwitch3 setOn:NO animated:YES];
    }
    else
    {
        self.CorrectAnswer = 3;
        [self.AnswerSwitch1 setOn:NO animated:YES];
        [self.AnswerSwitch3 setOn:YES animated:YES];
    }
    NSLog(@"Correct Answer: %d",self.CorrectAnswer);
}

- (IBAction)AnswerSwitchFlipped3:(id)sender
{
    if([self.AnswerSwitch3 isOn] == YES)
    {
        self.CorrectAnswer = 3;
        [self.AnswerSwitch1 setOn:NO animated:YES];
        [self.AnswerSwitch2 setOn:NO animated:YES];
    }
    else
    {
        self.CorrectAnswer = 1;
        [self.AnswerSwitch1 setOn:YES animated:YES];
        [self.AnswerSwitch2 setOn:NO animated:YES];
    }
    NSLog(@"Correct Answer: %d",self.CorrectAnswer);
}

@end
