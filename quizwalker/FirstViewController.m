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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	// Open Dialog if it's the first time
    if([defaults objectForKey:@"username"] == nil)
    {
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
    else
    {
        self.username = [[NSString alloc] initWithString:[defaults stringForKey:@"username"]];
        self.password = [[NSString alloc] initWithString:[defaults stringForKey:@"password"]];
        self.email = [[NSString alloc] initWithString:[defaults stringForKey:@"email"]];
    }
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
            //Send user data to server
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
    NetCommunication *connector = [[NetCommunication alloc] init];
    connector.delegate = self;
    [connector postMessageToServerAsync:YES FileName:@"test_save_user.php" Parameters:[NSString stringWithFormat:@"user_name=%@&password=%@&email=%@",username,password,email]];
    self.username = [[NSString alloc] initWithString:username];
    self.password = [[NSString alloc] initWithString:password];
    self.email = [[NSString alloc] initWithString:email];
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

-(void)answerFromServer:(NetCommunication *)controller callToServer:(NSString *)call numberOfTimes:(int)number serverAnswer:(NSString *)answer
{
    if([answer isEqualToString:@"New user created"]||[answer isEqualToString:@"Right password"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.username forKey:@"username"];
        [defaults setObject:self.password forKey:@"password"];
        [defaults setObject:self.email forKey:@"email"];
        [defaults synchronize];
        [self.Dialog hideAnimated:YES];
    }
    if([answer isEqualToString:@"Wrong password"])
    {
        //Error message
        self.Dialog.title = NSLocalizedString(@"INPUT_ERROR_WRONG_PASSWORD", nil);
        [self.Dialog showOrUpdateAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
