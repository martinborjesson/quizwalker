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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
