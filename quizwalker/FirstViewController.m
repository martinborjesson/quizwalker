//
//  ViewController.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-02-24.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	// Open Dialog if it's the first time
    self.Dialog = [CODialog dialogWithWindow:self.view.window];
    [self.Dialog resetLayout];
    
    self.Dialog.dialogStyle = CODialogStyleDefault;
    self.Dialog.title = NSLocalizedString(@"NEW_USER_TITLE",nil);
    [self.Dialog addTextFieldWithPlaceholder:NSLocalizedString(@"USER",nil) secure:NO];
    [self.Dialog addTextFieldWithPlaceholder:NSLocalizedString(@"PASSWORD",nil) secure:YES];
    [self.Dialog addTextFieldWithPlaceholder:NSLocalizedString(@"EMAIL",nil) secure:NO];
    [self.Dialog addButtonWithTitle:NSLocalizedString(@"OK_BUTTON", nil) target:self selector:@selector(userDataEntered)];
    [self.Dialog showOrUpdateAnimated:YES];    
}

-(void)userDataEntered
{
    NSString *user = [self.Dialog textForTextFieldAtIndex:0];
    NSString *pass = [self.Dialog textForTextFieldAtIndex:1];
    NSString *email = [self.Dialog textForTextFieldAtIndex:2];
    
    //Check if data is correct
    if(([user length] > 0)&&([pass length] > 0)&&([email length] > 0)&&([self isStringBlank:user] == NO)&&([self isStringBlank:pass] == NO)&&([self isStringBlank:email] == NO))
    {
        if([self isEmailStringCorrect:email] == YES)
        {
            [self.Dialog hideAnimated:YES];
            [self sendUserData:user Password:pass Email:email];
        }
        else
        {
            //Error message
            self.Dialog.title = NSLocalizedString(@"INPUT_ERROR_WRONG_EMAIL", nil);
            [self.Dialog showOrUpdateAnimated:YES];
        }
    }
    else
    {
        //Error message
        self.Dialog.title = NSLocalizedString(@"INPUT_ERROR_BLANK_STRING", nil);
        [self.Dialog showOrUpdateAnimated:YES];
    }
}

-(void)sendUserData:(NSString *)username Password:(NSString *)password Email:(NSString *)email
{
    
}

-(BOOL)isStringBlank:(NSString *)stringToCheck
{
    int numberOfBlanks = 0;
    
    for(int counter=0; counter < [stringToCheck length]; counter++)
    {
        if([stringToCheck characterAtIndex:counter] == ' ')
        {
            numberOfBlanks++;
        }
    }
    if(numberOfBlanks == [stringToCheck length])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)isEmailStringCorrect:(NSString *)stringToCheck
{
    for(int counter=0; counter < [stringToCheck length]; counter++)
    {
        if([stringToCheck characterAtIndex:counter] == '@')
        {
            return YES;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
