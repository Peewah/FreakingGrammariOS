//
//  AppDelegate.m
//  FreakingGrammariOS
//
//  Created by Juan Camilo Sacanamboy on 14/10/14.
//  Copyright (c) 2014 Peewah. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Pregunta.h"
#import <GooglePlus/GooglePlus.h>
#import <Appirater/Appirater.h>
#import "GAI.h"
#include<unistd.h>
#include<netdb.h>
#define APP_STORE_ID 1010760215


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Cargar App Rater
    [self configurarAppRater];
    
    // Local data store
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"APPLICATION_ID"
                  clientKey:@"CLIENT_KEY"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.preguntasEspanol = [NSMutableArray array];
    self.preguntasIngles = [NSMutableArray array];
    self.preguntasFrances = [NSMutableArray array];
    
    //Cargar preguntas desde Internet
    if([self isNetworkAvailable])
    {
        [self cargarPreguntasEspanol];
        [self cargarPreguntasIngles];
        [self cargarPreguntasFrances];
    }
    //Cargar preguntas localmente
    else
    {
        [self cargarPreguntasEspanolLocalmente];
        [self cargarPreguntasInglesLocalmente];
        [self cargarPreguntasFrancesLocalmente];
    }

    //Google Analytics
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Load spanish questions
-(void)cargarPreguntasEspanol
{
    PFQuery *query = [PFQuery queryWithClassName:@"Pregunta"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error)
        {
            //Pin to the list
            [PFObject pinAllInBackground:objects];
            
            for(PFObject *obj in objects)
            {
                NSString *frase = obj[@"frase"];
                NSString *respuestaBuena = obj[@"respuestaBuena"];
                NSString *respuestaMala = obj[@"respuestaMala"];
                
                //Create question
                Pregunta *pregunta = [[Pregunta alloc] init];
                pregunta.frase = frase;
                pregunta.respuestaBuena = respuestaBuena;
                pregunta.respuestaMala = respuestaMala;
                
                [self.preguntasEspanol addObject:pregunta];
            }
        }
        else
        {
            NSLog(@"Problems loading questions");
        }
    }];
    
}

//Load spanish questions locally
-(void)cargarPreguntasEspanolLocalmente
{
    PFQuery *query = [PFQuery queryWithClassName:@"Pregunta"];
    [query fromLocalDatastore];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error)
        {
            for(PFObject *obj in objects)
            {
                NSString *frase = obj[@"frase"];
                NSString *respuestaBuena = obj[@"respuestaBuena"];
                NSString *respuestaMala = obj[@"respuestaMala"];
                
                //Create question
                Pregunta *pregunta = [[Pregunta alloc] init];
                pregunta.frase = frase;
                pregunta.respuestaBuena = respuestaBuena;
                pregunta.respuestaMala = respuestaMala;
                
                [self.preguntasEspanol addObject:pregunta];
            }
        }
        else
        {
            NSLog(@"Problems loading questions");
        }
    }];
    
}

//Load english questions
-(void)cargarPreguntasIngles
{
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error)
        {
            //Pin to the list
            [PFObject pinAllInBackground:objects];
            
            for(PFObject *obj in objects)
            {
                NSString *frase = obj[@"phrase"];
                NSString *respuestaBuena = obj[@"goodAnswer"];
                NSString *respuestaMala = obj[@"badAnswer"];
                
                //Create question
                Pregunta *pregunta = [[Pregunta alloc] init];
                pregunta.frase = frase;
                pregunta.respuestaBuena = respuestaBuena;
                pregunta.respuestaMala = respuestaMala;
                
                [self.preguntasIngles addObject:pregunta];
            }
        }
        else
        {
            NSLog(@"Problems loading questions");
        }
    }];
    
}

//Load english questions locally
-(void)cargarPreguntasInglesLocalmente
{
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query fromLocalDatastore];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error)
        {
            for(PFObject *obj in objects)
            {
                NSString *frase = obj[@"phrase"];
                NSString *respuestaBuena = obj[@"goodAnswer"];
                NSString *respuestaMala = obj[@"badAnswer"];
                
                //Crear pregunta
                Pregunta *pregunta = [[Pregunta alloc] init];
                pregunta.frase = frase;
                pregunta.respuestaBuena = respuestaBuena;
                pregunta.respuestaMala = respuestaMala;
                
                [self.preguntasIngles addObject:pregunta];
            }
        }
        else
        {
            NSLog(@"Problems loading questions");
        }
    }];
    
}

//Load french questions
-(void)cargarPreguntasFrances
{
    PFQuery *query = [PFQuery queryWithClassName:@"PreguntaFrances"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error)
        {
            //Pin a la lista
            [PFObject pinAllInBackground:objects];
            
            for(PFObject *obj in objects)
            {
                NSString *frase = obj[@"frase"];
                NSString *respuestaBuena = obj[@"respuestaBuena"];
                NSString *respuestaMala = obj[@"respuestaMala"];
                
                //Crear pregunta
                Pregunta *pregunta = [[Pregunta alloc] init];
                pregunta.frase = frase;
                pregunta.respuestaBuena = respuestaBuena;
                pregunta.respuestaMala = respuestaMala;
                
                [self.preguntasFrances addObject:pregunta];
            }
        }
        else
        {
            NSLog(@"Problems loading questions");
        }
    }];
    
}

//Load french questions locally
-(void)cargarPreguntasFrancesLocalmente
{
    PFQuery *query = [PFQuery queryWithClassName:@"PreguntaFrances"];
    [query fromLocalDatastore];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error)
        {
            //Pin a la lista
            [PFObject pinAllInBackground:objects];
            
            for(PFObject *obj in objects)
            {
                NSString *frase = obj[@"frase"];
                NSString *respuestaBuena = obj[@"respuestaBuena"];
                NSString *respuestaMala = obj[@"respuestaMala"];
                
                //Crear pregunta
                Pregunta *pregunta = [[Pregunta alloc] init];
                pregunta.frase = frase;
                pregunta.respuestaBuena = respuestaBuena;
                pregunta.respuestaMala = respuestaMala;
                
                [self.preguntasFrances addObject:pregunta];
            }
        }
        else
        {
            NSLog(@"Problems loading questions");
        }
    }];
    
}

//Configure App Rater
-(void)configurarAppRater
{
    [Appirater setAppId:[NSString stringWithFormat:@"%d", APP_STORE_ID]];
    [Appirater setDaysUntilPrompt:3];
    [Appirater setUsesUntilPrompt:7];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];
}

//Determine if the network is available
-(BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "parse.com";
    hostinfo = gethostbyname (hostname);
    
    if (hostinfo == NULL)
    {
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else
    {
        NSLog(@"-> connection established!\n");
        return YES;
    }
}

@end
