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
    viewFrame.origin.y -= PORTRAIT_KEYBOARD_HEIGHT;
    
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
    viewFrame.origin.y += PORTRAIT_KEYBOARD_HEIGHT;
    
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

}

- (IBAction)NextButton:(id)sender
{
    //Insert the question and its parts into array IF everything is correctly filled in
    if([self stringNotEmpty:self.QuestionTextView.text]&&[self stringNotEmpty:self.TextFieldOne.text]&&[self stringNotEmpty:self.TextFieldTwo.text]&&[self stringNotEmpty:self.TextFieldThree.text])
    {
        Question *theQuestion = [[Question alloc] init];
        theQuestion.Question = self.QuestionTextView.text;
        theQuestion.Answer1 = self.TextFieldOne.text;
        theQuestion.Answer2 = self.TextFieldTwo.text;
        theQuestion.Answer3 = self.TextFieldThree.text;
    
        [self.StoredQuestions insertObject:theQuestion atIndex:self.StoredQuestions.count];
    }
    else
    {
        
    }
}

- (BOOL)stringNotEmpty:(NSString *)theString
{
    return YES;
}

@end
