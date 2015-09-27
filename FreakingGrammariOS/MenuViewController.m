//
//  MenuViewController.m
//  FreakingGrammariOS
//
//  Created by Juan Camilo Sacanamboy on 16/10/14.
//  Copyright (c) 2014 Peewah. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "PlayViewController.h"
#define APP_STORE_ID 1010760215

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnCalificar setTitle:NSLocalizedString(@"btnCalificar", nil) forState:UIControlStateNormal];
    self.lblLanguage.text = self.language;
    self.view.backgroundColor = self.backgroundColor;
    
    [self cargarGPGIds];

}

//Load Google Play Games IDs
-(void)cargarGPGIds
{
    //1. Create dictionary from plist
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"GPGIds" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
    
    //2. Leaderboards
    _leaderboardSpanish = dictionary[@"eruditos_id"];
    _leaderboardEnglish = dictionary[@"scholars_id"];
    _leaderboardFrench = dictionary[@"savants_id"];
    
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"playSegue"])
    {
        PlayViewController *playVC = (PlayViewController *)segue.destinationViewController;
        
        playVC.language = self.language;

    }
}

//Validate if it's an available language
-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    if([identifier isEqualToString:@"playSegue"])
    {
       if([self.language isEqualToString:NSLocalizedString(@"idiomaEspanol", nil)] && [appDelegate.preguntasEspanol count] > 0)
       {
           return YES;
       }
       else if([self.language isEqualToString:NSLocalizedString(@"idiomaIngles", nil)] && [appDelegate.preguntasIngles count] > 0)
       {
           return YES;
       }
       else if ([self.language isEqualToString:NSLocalizedString(@"idiomaFrances", nil)] && [appDelegate.preguntasIngles count] > 0)
       {
           return YES;
       }
        
    }
    
    return NO;
    
}

- (IBAction)showAchievements:(id)sender
{
    //Show dialog when user isn't logged
    BOOL signedInToGameServices = [GPGManager sharedInstance].isSignedIn;
    if(signedInToGameServices == NO)
    {
        [self showSignInDialogWithTitle:NSLocalizedString(@"titleDialogIniciaSesionAchievements", nil) andBody:NSLocalizedString(@"bodyDialogIniciaSesionAchievements", nil)];
    }
    else
    {
        //Mostrar trofeos
        [[GPGLauncherController sharedInstance] presentAchievementList];
    }

}

- (IBAction)showLeaderboard:(id)sender
{
    //Show dialog when user isn't logged
    BOOL signedInToGameServices = [GPGManager sharedInstance].isSignedIn;
    
    if(signedInToGameServices == NO)
    {
        [self showSignInDialogWithTitle:NSLocalizedString(@"titleDialogIniciaSesionLeaderboard", nil) andBody:NSLocalizedString(@"bodyDialogIniciaSesionLeaderboard", nil)];
    }
    else
    {
        //Load leaderboards
        NSString *targetLeaderboardId = nil;
        
        if([self.language isEqualToString:NSLocalizedString(@"idiomaEspanol", nil)])
        {
            targetLeaderboardId = _leaderboardSpanish;
        }
        else if([self.language isEqualToString:NSLocalizedString(@"idiomaIngles", nil)])
        {
            targetLeaderboardId = _leaderboardEnglish;
        }
        else if ([self.language isEqualToString:NSLocalizedString(@"idiomaFrances", nil)])
        {
            targetLeaderboardId = _leaderboardFrench;
        }
        
        [[GPGLauncherController sharedInstance] presentLeaderboardWithLeaderboardId:targetLeaderboardId];
    }
    

}

-(void)showSignInDialogWithTitle: (NSString *)title andBody:(NSString *)body
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:body
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//Rate app
- (IBAction)calificarApp:(id)sender
{
    static NSString *const appStoreUrl = @"itms-apps://itunes.apple.com/app/id%d";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: appStoreUrl, APP_STORE_ID]]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Google Analytics
    self.screenName = @"Menu";
}

@end
