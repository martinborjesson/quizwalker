//
//  NetCommunication.m
//  quizwalker
//
//  Created by Martin Börjesson on 2013-03-12.
//  Copyright (c) 2013 Martin Börjesson. All rights reserved.
//

#import "NetCommunication.h"

@interface NetCommunication()

@end

@implementation NetCommunication

static NSString *server = @"uberskull.ddns.info";

-(id) init
{
    self = [super init];
    if(self != nil)
    {
        self.ReturnData = [[NSMutableData alloc] init];
        self.previousCallToServer = @"";
    }
    return self;
}

-(void) postMessageToServerAsync:(BOOL)encrypted FileName:(NSString *)filename Parameters:(NSString *)para
{
    //if there is a connection going on just cancel it.
    [self.Connection cancel];
    
    //Store the call
    self.callToServer = [[NSString alloc] initWithString:filename];
    
    //initialize url that is going to be fetched.
    NSString *sendTo = nil;
    if(encrypted)
    {
        sendTo = [NSString stringWithFormat:@"%@%@%@%@",@"https://",server,@"/",filename];
    }
    else
    {
        sendTo = [NSString stringWithFormat:@"%@%@%@%@",@"http://",server,@"/",filename];
    }
    NSURL *url = [NSURL URLWithString:sendTo];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    //set request content type we MUST set this value.
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[para dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.Connection = connection;
    
    //start the connection
    [connection start];
}

- (NSString *)postMessageToServerSync:(NSString *)filename Parameters:(NSString *)para
{
    //initialize url that is going to be fetched.
    NSString *sendTo = [NSString stringWithFormat:@"%@%@%@%@",@"http://",server,@"/",filename];

    NSURL *url = [NSURL URLWithString:sendTo];
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    
    //set http method
    [request setHTTPMethod:@"POST"];
    
    //set request content type we MUST set this value.
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[para dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    //send Request
    NSData *returned = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *htmlString = [[NSString alloc] initWithData:returned encoding:NSUTF8StringEncoding];
    
    return htmlString;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [self.ReturnData setData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"DidFailWithError");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    NSString *htmlString = [[NSString alloc] initWithData:self.ReturnData encoding:NSUTF8StringEncoding];
    //Is it the same type of call? If so increase callCounter
    if([self.previousCallToServer isEqualToString:self.callToServer])
    {
        self.callCounter++;
    }
    else
    {
        self.callCounter = 1;
        self.previousCallToServer = [[NSString alloc] initWithString:self.callToServer];
    }
    
    if ([self.delegate respondsToSelector:@selector(answerFromServer:callToServer:numberOfTimes:serverAnswer:)])
    {
        [self.delegate answerFromServer:self callToServer:self.callToServer numberOfTimes:self.callCounter serverAnswer:htmlString];
    }
}

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"didReceiveAuthenticationChallenge");
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

@end
