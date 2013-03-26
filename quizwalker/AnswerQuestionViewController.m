//
//  AnswerQuestionViewController.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-17.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "AnswerQuestionViewController.h"

@interface AnswerQuestionViewController ()

@end

@implementation AnswerQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.QuestionTextLabel.text = self.Question;
    [self.QuestionTextLabel.layer setBorderColor:
     [[UIColor colorWithRed:0.65 green:0.65 blue:0.65 alpha:1.0] CGColor]];
    [self.QuestionTextLabel.layer setBorderWidth: 2.0];
    [self.QuestionTextLabel.layer setCornerRadius:8.0f];
    [self.QuestionTextLabel.layer setMasksToBounds:YES];
    
    [self.AnswerButton1 setTitle:self.Answer1 forState:UIControlStateNormal];
    [self.AnswerButton2 setTitle:self.Answer2 forState:UIControlStateNormal];
    [self.AnswerButton3 setTitle:self.Answer3 forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AnswerButtonOnePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(ReturnAnswer:SelectedAnswer:)])
    {
        [self.delegate ReturnAnswer:self SelectedAnswer:1];
    }
}

- (IBAction)AnswerButtonTwoPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(ReturnAnswer:SelectedAnswer:)])
    {
        [self.delegate ReturnAnswer:self SelectedAnswer:2];
    }
}

- (IBAction)AnswerButtonThreePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(ReturnAnswer:SelectedAnswer:)])
    {
        [self.delegate ReturnAnswer:self SelectedAnswer:3];
    }

}

@end
