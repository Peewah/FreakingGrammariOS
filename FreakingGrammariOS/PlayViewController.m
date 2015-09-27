//
//  PlayViewController.m
//  FreakingGrammariOS
//
//  Created by Juan Camilo Sacanamboy on 5/06/15.
//  Copyright (c) 2015 Peewah. All rights reserved.
//

#import "PlayViewController.h"
#import "AppDelegate.h"
#import "Pregunta.h"
#import "ParejaColor.h"
#import <CustomIOSAlertView.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PlayViewController ()

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set flag in NO
    _haGanadoBandera = NO;
    
    //Load GPG Ids
    [self cargarGPGIds];
    
    //Start game
    [self iniciarJuego];
    
    //Give first achievement
    [self darPrimerLogro];
    
    //Load ADs
    self.interstitial = [self createAndLoadInterstitial];
}

//Load Google Play Games IDs
-(void)cargarGPGIds
{
    //Create dictionary from plist
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"GPGIds" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:pListPath];
    
    //1. Leaderboards
    _leaderboardSpanish = dictionary[@"eruditos_id"];
    _leaderboardEnglish = dictionary[@"scholars_id"];
    _leaderboardFrench = dictionary[@"savants_id"];
    
    //2. Achievements
    
    //  2.1 Spanish achievements
    _logroNuevo = dictionary[@"logroNuevo"];
    _logroNovato = dictionary[@"logroNovato"];
    _logroAprendiz = dictionary[@"logroAprendiz"];
    _logroProfesional = dictionary[@"logroProfesional"];
    _logroAvanzado = dictionary[@"logroAvanzado"];
    _logroErudito = dictionary[@"logroErudito"];
    
    //  2.2 English achievements
    _logroNewbie = dictionary[@"logroNewbie"];
    _logroFreshman = dictionary[@"logroFreshman"];
    _logroApprentice = dictionary[@"logroApprentice"];
    _logroAdvanced = dictionary[@"logroAdvanced"];
    _logroProfessional = dictionary[@"logroProfessional"];
    _logroScholar = dictionary[@"logroScholar"];
    
    //  2.3 French achievements
    _logroDebutant = dictionary[@"logroDebutant"];
    _logroNovice = dictionary[@"logroNovice"];
    _logroApprenti = dictionary[@"logroApprenti"];
    _logroAdvance = dictionary[@"logroAdvance"];
    _logroProfessionnel = dictionary[@"logroProfessionnel"];
    _logroSavant = dictionary[@"logroSavant"];
    
    
}


//Restart all parameters to start the game
-(void) iniciarJuego
{
    //Get list of questions
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    if([self.language isEqualToString:NSLocalizedString(@"idiomaEspanol", nil)])
    {
        self.preguntas = [[NSMutableArray alloc] initWithArray:appDelegate.preguntasEspanol];
    }
    else if ([self.language isEqualToString:NSLocalizedString(@"idiomaIngles", nil)])
    {
        self.preguntas = [[NSMutableArray alloc] initWithArray:appDelegate.preguntasIngles];
    }
    else if ([self.language isEqualToString:NSLocalizedString(@"idiomaFrances", nil)])
    {
        self.preguntas = [[NSMutableArray alloc] initWithArray:appDelegate.preguntasFrances];
    }
    else
    {
        self.preguntas = [NSMutableArray array];
    }
    
    //Start max interval
    _totalCountdownInterval = 5;
    
    //Assign current score
    _puntajeActual = 0;
    _tvPuntaje.text = [NSString stringWithFormat:@"%d", _puntajeActual];
    
    //Load colors
    [self cargarColores];
    
    //Load first question
    _preguntaActual = [self cargarPregunta];
    
    //Load sound preferences
    _sound = [self obtenerPreferenciaSonido];
    
    //Change sound icon
    if(_sound == YES)
        [_btnSonido setImage:[UIImage imageNamed:@"sound_icon"] forState:UIControlStateNormal];
    else
        [_btnSonido setImage:[UIImage imageNamed:@"sound_off_icon"] forState:UIControlStateNormal];
}



//Load a question randomly
-(Pregunta *) cargarPregunta
{
    //Get a question randomly
    NSUInteger randomIndexPregunta = arc4random_uniform((int)[self.preguntas count]);
    Pregunta *pregunta = [self.preguntas objectAtIndex:randomIndexPregunta];
    
    //Show the question in the UI
    _tvFrase.text = pregunta.frase;
    //Change color
    NSUInteger posColor = arc4random_uniform((int)[self.colores count]);
    ParejaColor *parejaColor = [self.colores objectAtIndex:posColor];
    _btnRespuestaUno.backgroundColor = [UIColor colorWithRed:[parejaColor.colorIzq[0] intValue]/255.0 green:[parejaColor.colorIzq[1] intValue]/255.0 blue:[parejaColor.colorIzq[2] intValue]/255.0 alpha:[parejaColor.colorIzq[3] intValue]];
    _btnRespuestaDos.backgroundColor = [UIColor colorWithRed:[parejaColor.colorDer[0] intValue]/255.0 green:[parejaColor.colorDer[1] intValue]/255.0 blue:[parejaColor.colorDer[2] intValue]/255.0 alpha:[parejaColor.colorDer[3] intValue]];
    //Show the options in the UI
    NSUInteger posRespuestaBuena = arc4random_uniform(2);
    if (posRespuestaBuena == 0)
    {
        [_btnRespuestaUno setTitle:pregunta.respuestaBuena forState:UIControlStateNormal];
        [_btnRespuestaDos setTitle:pregunta.respuestaMala forState:UIControlStateNormal];
    }
    else
    {
        [_btnRespuestaUno setTitle:pregunta.respuestaMala forState:UIControlStateNormal];
        [_btnRespuestaDos setTitle:pregunta.respuestaBuena forState:UIControlStateNormal];
    }
    


    return pregunta;
}

//Load colors
-(void) cargarColores
{
    ParejaColor *parejaUno = [[ParejaColor alloc]init];
    parejaUno.colorIzq = [NSArray arrayWithObjects:[NSNumber numberWithInt:104], [NSNumber numberWithInt:195], [NSNumber numberWithInt:160], [NSNumber numberWithInt:1], nil];
    parejaUno.colorDer = [NSArray arrayWithObjects:[NSNumber numberWithInt:167], [NSNumber numberWithInt:114], [NSNumber numberWithInt:176], [NSNumber numberWithInt:1], nil];
    
    ParejaColor *parejaDos = [[ParejaColor alloc]init];
    parejaDos.colorIzq = [NSArray arrayWithObjects:[NSNumber numberWithInt:251], [NSNumber numberWithInt:225], [NSNumber numberWithInt:49], [NSNumber numberWithInt:1], nil];
    parejaDos.colorDer = [NSArray arrayWithObjects:[NSNumber numberWithInt:244], [NSNumber numberWithInt:139], [NSNumber numberWithInt:153], [NSNumber numberWithInt:1], nil];
    
    ParejaColor *parejaTres = [[ParejaColor alloc]init];
    parejaTres.colorIzq = [NSArray arrayWithObjects:[NSNumber numberWithInt:91], [NSNumber numberWithInt:119], [NSNumber numberWithInt:204], [NSNumber numberWithInt:1], nil];
    parejaTres.colorDer = [NSArray arrayWithObjects:[NSNumber numberWithInt:250], [NSNumber numberWithInt:190], [NSNumber numberWithInt:73], [NSNumber numberWithInt:1], nil];
    
    ParejaColor *parejaCuatro = [[ParejaColor alloc]init];
    parejaCuatro.colorIzq = [NSArray arrayWithObjects:[NSNumber numberWithInt:116], [NSNumber numberWithInt:191], [NSNumber numberWithInt:71], [NSNumber numberWithInt:1], nil];
    parejaCuatro.colorDer = [NSArray arrayWithObjects:[NSNumber numberWithInt:81], [NSNumber numberWithInt:181], [NSNumber numberWithInt:223], [NSNumber numberWithInt:1], nil];
    
    ParejaColor *parejaCinco = [[ParejaColor alloc]init];
    parejaCinco.colorIzq = [NSArray arrayWithObjects:[NSNumber numberWithInt:167], [NSNumber numberWithInt:114], [NSNumber numberWithInt:176], [NSNumber numberWithInt:1], nil];
    parejaCinco.colorDer = [NSArray arrayWithObjects:[NSNumber numberWithInt:104], [NSNumber numberWithInt:195], [NSNumber numberWithInt:160], [NSNumber numberWithInt:1], nil];
    
    ParejaColor *parejaSeis = [[ParejaColor alloc]init];
    parejaSeis.colorIzq = [NSArray arrayWithObjects:[NSNumber numberWithInt:244], [NSNumber numberWithInt:139], [NSNumber numberWithInt:153], [NSNumber numberWithInt:1], nil];
    parejaSeis.colorDer = [NSArray arrayWithObjects:[NSNumber numberWithInt:251], [NSNumber numberWithInt:225], [NSNumber numberWithInt:49], [NSNumber numberWithInt:1], nil];
    
    ParejaColor *parejaSiete = [[ParejaColor alloc]init];
    parejaSiete.colorIzq = [NSArray arrayWithObjects:[NSNumber numberWithInt:250], [NSNumber numberWithInt:190], [NSNumber numberWithInt:73], [NSNumber numberWithInt:1], nil];
    parejaSiete.colorDer = [NSArray arrayWithObjects:[NSNumber numberWithInt:91], [NSNumber numberWithInt:119], [NSNumber numberWithInt:204], [NSNumber numberWithInt:1], nil];
    
    ParejaColor *parejaOcho = [[ParejaColor alloc]init];
    parejaOcho.colorIzq = [NSArray arrayWithObjects:[NSNumber numberWithInt:167], [NSNumber numberWithInt:114], [NSNumber numberWithInt:176], [NSNumber numberWithInt:1], nil];
    parejaOcho.colorDer = [NSArray arrayWithObjects:[NSNumber numberWithInt:104], [NSNumber numberWithInt:195], [NSNumber numberWithInt:160], [NSNumber numberWithInt:1], nil];
    
    _colores = [NSArray arrayWithObjects:parejaUno, parejaDos, parejaTres, parejaCuatro, parejaCinco, parejaSiete, parejaSiete, parejaOcho, nil];
}

//When left button is touched
- (IBAction)respuestaUno:(id)sender
{
    if([_btnRespuestaUno.titleLabel.text isEqualToString:_preguntaActual.respuestaBuena])
    {
        [self haGanado];
    }
    else
    {
        [self haPerdido];
    }
}

//When right button is touched
- (IBAction)respuestaDos:(id)sender
{
    if([_btnRespuestaDos.titleLabel.text isEqualToString:_preguntaActual.respuestaBuena])
    {
        [self haGanado];
    }
    else
    {
        [self haPerdido];
    }
}

//When user answer correctly
-(void) haGanado
{
    //Play sound
    if(_sound == YES)
        [self reproducirSonidoGana];
    
    //1. Remove current question
    [_preguntas removeObject:_preguntaActual];
        
    //2. Update score
    _puntajeActual++;
    _tvPuntaje.text = [NSString stringWithFormat:@"%d", _puntajeActual];
    
    //If there aren't questions
    if ([_preguntas count] == 0)
    {
        //Stop timer
        if(_timer!=nil)
        {
            [_timer invalidate];
            _timer = nil;
        }
        
        //Save score in Google Play Games
        [self guardarPuntajeRemoto:_puntajeActual];
        
        //Save score locally
        [self guardarPuntajeLocalmente];
        
        //Give achievements
        [self darLogroConPuntaje:_puntajeActual];
        
        //Set flag in YES
        _haGanadoBandera = YES;
        
        //Show ADs
        if([self.interstitial isReady])
        {
            [self.interstitial presentFromRootViewController:self];
        }
        //Show message
        else
        {
            [self mostrarMensajeGano];
        }
        
    }
    //Still there are questions
    else
    {
        //Load current question
        _preguntaActual = [self cargarPregunta];
        
        //Start timer
        if(_timer!=nil)
        {
            [_timer invalidate];
            _timer = nil;
        }
            
        [self iniciarTimer];
    }
    
}

//When user answer badly
-(void) haPerdido
{
    //Play sound
    if(_sound == YES)
        [self reproducirSonidoPierde];
    
    //Cancel timer
    if(_timer != nil)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    //Set progress bar in zero
    _progressBar.progress = 0;
    
    //Save score in Google Play Games
    [self guardarPuntajeRemoto:_puntajeActual];

    //Save score locally
    [self guardarPuntajeLocalmente];
    
    //Give achievements
    [self darLogroConPuntaje:_puntajeActual];
    

    
    //Show ADs
    if([self.interstitial isReady])
    {
        [self.interstitial presentFromRootViewController:self];
    }
    //Show message
    else
    {
        [self mostrarMensajePerdio];
    }
    
}

//Start the timer
-(void) iniciarTimer
{
    _fechaInicial = [NSDate date];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(logicaTickTimer:) userInfo:nil repeats:YES];
    _progressBar.progress = 1;
}

//Tick's logic
-(void) logicaTickTimer:(NSTimer *) timer
{
    //Calculate elapsed time
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:_fechaInicial];
    
    //Calculate remaining time
    NSTimeInterval remainingTime = _totalCountdownInterval - elapsedTime;
    
    //Update progress bar
    _progressBar.progress = (float)remainingTime/(float)_totalCountdownInterval;
    
    //Time is over
    if(remainingTime <= 0.0)
    {
        [self haPerdido];
    }

}

//Get best score in spanish
-(int) obtenerMejorPuntajeEspanolLocal
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *puntajeEspanol = @"puntajeEspanol";
    
    if([preferences objectForKey:puntajeEspanol] == nil)
    {
        return 0;
    }
    else
    {
        return (int)[preferences integerForKey:puntajeEspanol];
    }
}

//Get best score in english
-(int) obtenerMejorPuntajeInglesLocal
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *puntajeIngles = @"puntajeIngles";
    
    if([preferences objectForKey:puntajeIngles] == nil)
    {
        return 0;
    }
    else
    {
        return (int)[preferences integerForKey:puntajeIngles];
    }
}

//Get best score in french
-(int) obtenerMejorPuntajeFrancesLocal
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *puntajeFrances = @"puntajeFrances";
    
    if([preferences objectForKey:puntajeFrances] == nil)
    {
        return 0;
    }
    else
    {
        return (int)[preferences integerForKey:puntajeFrances];
    }
}

//Get user's sound preferences
-(BOOL) obtenerPreferenciaSonido
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *sonido = @"sonido";
    
    if([preferences objectForKey:sonido] == nil)
    {
        return YES;
    }
    else
    {
        return (BOOL)[preferences boolForKey:sonido];
    }
}

//Save score locally in spanish
-(void) guardarPuntajeEspanolLocal:(int)puntaje
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *puntajeEspanol = @"puntajeEspanol";
    
    [preferences setInteger:puntaje forKey:puntajeEspanol];
    
    [preferences synchronize];
}

//Save score locally in english
-(void) guardarPuntajeInglesLocal:(int)puntaje
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *puntajeIngles = @"puntajeIngles";
    
    [preferences setInteger:puntaje forKey:puntajeIngles];
    
    [preferences synchronize];
}

//Save score locally in french
-(void) guardarPuntajeFrancesLocal:(int)puntaje
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *puntajeFrances = @"puntajeFrances";
    
    [preferences setInteger:puntaje forKey:puntajeFrances];
    
    [preferences synchronize];
}

//Save sound preferences
-(void) guardarPreferenciaSonido:(BOOL)preferenciaSonido
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *sonido = @"sonido";
    
    [preferences setBool:preferenciaSonido forKey:sonido];
    
    [preferences synchronize];
}

//Save the best score locally
-(void) guardarPuntajeLocalmente
{
    //Save score locally
    if([self.language isEqualToString:NSLocalizedString(@"idiomaEspanol", nil)])
    {
        int bestScore = [self obtenerMejorPuntajeEspanolLocal];
        
        if(_puntajeActual > bestScore)
        {
            [self guardarPuntajeEspanolLocal:_puntajeActual];
        }
    }
    else if ([self.language isEqualToString:NSLocalizedString(@"idiomaIngles", nil)])
    {
        int bestScore = [self obtenerMejorPuntajeInglesLocal];
        
        if(_puntajeActual > bestScore)
        {
            [self guardarPuntajeInglesLocal:_puntajeActual];
        }
    }
    else if ([self.language isEqualToString:NSLocalizedString(@"idiomaFrances", nil)])
    {
        int bestScore = [self obtenerMejorPuntajeFrancesLocal];

        if(_puntajeActual > bestScore)
        {
            [self guardarPuntajeFrancesLocal:_puntajeActual];
        }
    }
}

//Create final dialog
-(UIView *) crearDialogoFinal: (NSString *) titulo
{
    //Create custom view for dialog
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    
    //Initialize top label
    UILabel *labelTop = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 100, 30)];
    labelTop.text = titulo;
    [labelTop setTextAlignment:NSTextAlignmentCenter];
    
    //Initialize new score label
    UILabel *labelNewScore = [[UILabel alloc]initWithFrame:CGRectMake(40, 50, 60,30)];
    labelNewScore.text = NSLocalizedString(@"newScore", nil);
    
    UILabel *labelNewScoreValue = [[UILabel alloc]initWithFrame:CGRectMake(200, 50, 60,30)];
    labelNewScoreValue.text = [NSString stringWithFormat:@"%d", _puntajeActual];
    
    //Initializa best score label
    UILabel *labelBestScore = [[UILabel alloc]initWithFrame:CGRectMake(40, 100, 60,30)];
    labelBestScore.text = NSLocalizedString(@"bestScore", nil);
    
    UILabel *labelBestScoreValue = [[UILabel alloc]initWithFrame:CGRectMake(200, 100, 60,30)];
    if([self.language isEqualToString:NSLocalizedString(@"idiomaEspanol", nil)])
    {
        labelBestScoreValue.text = [NSString stringWithFormat:@"%d", [self obtenerMejorPuntajeEspanolLocal]];
    }
    else if ([self.language isEqualToString:NSLocalizedString(@"idiomaIngles", nil)])
    {
        labelBestScoreValue.text = [NSString stringWithFormat:@"%d", [self obtenerMejorPuntajeInglesLocal]];
    }
    else if ([self.language isEqualToString:NSLocalizedString(@"idiomaFrances", nil)])
    {
        labelBestScoreValue.text = [NSString stringWithFormat:@"%d", [self obtenerMejorPuntajeFrancesLocal]];
    }
    else
    {
        labelBestScoreValue.text = [NSString stringWithFormat:@"%d", 0];
    }
    
    //Add components to the view
    [customView addSubview:labelTop];
    [customView addSubview:labelNewScore];
    [customView addSubview:labelBestScore];
    [customView addSubview:labelNewScoreValue];
    [customView addSubview:labelBestScoreValue];
    
    return customView;
}

//When a dialog's button is pressed
-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        //Play  button
        if(buttonIndex == 0)
        {
            [alertView close];
            [self iniciarJuego];
        }
        //Menu button
        else if (buttonIndex == 1)
        {
            [alertView close];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        //Share button
        else if (buttonIndex == 2)
        {
            [alertView close];
            
            [self iniciarJuego];
            
            NSURL *URL = [NSURL URLWithString:@"https://www.facebook.com/freakingrammar"];
            
            NSString *cadenaPrimera = [NSLocalizedString(@"shareScoreFirst", nil) stringByAppendingString:[NSString stringWithFormat:@" %d", _puntajeActual]];
            
            NSString *cadenaResultante = cadenaPrimera;
            
            if([self.language isEqualToString:NSLocalizedString(@"idiomaEspanol", nil)])
            {
                cadenaResultante = [cadenaPrimera stringByAppendingString:@" "];
                cadenaResultante = [cadenaResultante stringByAppendingString:NSLocalizedString(@"shareScoreSecondEspanol", nil)];
            }
            else if ([self.language isEqualToString:NSLocalizedString(@"idiomaIngles", nil)])
            {
                cadenaResultante = [cadenaPrimera stringByAppendingString:@" "];
                cadenaResultante = [cadenaResultante stringByAppendingString:NSLocalizedString(@"shareScoreSecondIngles", nil)];
            }
            else if ([self.language isEqualToString:NSLocalizedString(@"idiomaFrances", nil)])
            {
                cadenaResultante = [cadenaPrimera stringByAppendingString:@" "];
                cadenaResultante = [cadenaResultante stringByAppendingString:NSLocalizedString(@"shareScoreSecondFrances", nil)];
            }
            
            UIActivityViewController *activityViewController =
            [[UIActivityViewController alloc] initWithActivityItems:@[cadenaResultante, URL]
                                              applicationActivities:nil];
            activityViewController.excludedActivityTypes = @[UIActivityTypeMessage,
                                                             UIActivityTypeMail,
                                                             UIActivityTypePrint,
                                                             UIActivityTypeCopyToPasteboard];
            [self.navigationController presentViewController:activityViewController
                                                    animated:YES
                                                  completion:nil];
            
        }
    
    

}

//When sound button is pressed
- (IBAction)btnSonidoClicked:(id)sender
{
    if(_sound == YES)
    {
        _sound = NO;
        [_btnSonido setImage:[UIImage imageNamed:@"sound_off_icon"] forState:UIControlStateNormal];
    }
    else
    {
        _sound = YES;
        [_btnSonido setImage:[UIImage imageNamed:@"sound_icon"] forState:UIControlStateNormal];
    }
    
    [self guardarPreferenciaSonido:_sound];
}

//Play win sound
-(void) reproducirSonidoGana
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"paso" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
    //AudioServicesDisposeSystemSoundID(soundID);
}

//Play you lose sound
-(void) reproducirSonidoPierde
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"mal" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    AudioServicesPlaySystemSound(soundID);
    //AudioServicesDisposeSystemSoundID(soundID);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //Stop timer if user close the screen
    if(_timer != nil)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
}

//Give the first achievement
-(void)darPrimerLogro
{
    BOOL signedInToGameServices = [GPGManager sharedInstance].isSignedIn;
    
    if(signedInToGameServices)
    {
        NSString *primerLogro = nil;
        
        if([self.language isEqualToString:NSLocalizedString(@"idiomaEspanol", nil)])
        {
            primerLogro = _logroNuevo;
        }
        else if([self.language isEqualToString:NSLocalizedString(@"idiomaIngles", nil)])
        {
            primerLogro = _logroNewbie;
        }
        else if ([self.language isEqualToString:NSLocalizedString(@"idiomaFrances", nil)])
        {
            primerLogro = _logroDebutant;
        }
        
        GPGAchievement *primerTrofeo = [GPGAchievement achievementWithId:primerLogro];
        
        //First achievement
        [primerTrofeo unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
            if(error)
            {
                
            }
            else if(!newlyUnlocked)
            {
                //Already unlocked
            }
            else
            {
                //It was unlocked
            }
        }];
    }
}

//Save score in Google Play Games
-(void)guardarPuntajeRemoto:(int)puntaje
{
    BOOL signedInToGameServices = [GPGManager sharedInstance].isSignedIn;
    
    if(signedInToGameServices)
    {
        //Put leaderboard code according to the current language
        NSString *leaderboardId = nil;
        
        if([self.language isEqualToString:NSLocalizedString(@"idiomaEspanol", nil)])
        {
            leaderboardId = _leaderboardSpanish;
        }
        else if([self.language isEqualToString:NSLocalizedString(@"idiomaIngles", nil)])
        {
            leaderboardId = _leaderboardEnglish;
            
        }
        else if ([self.language isEqualToString:NSLocalizedString(@"idiomaFrances", nil)])
        {
            leaderboardId = _leaderboardFrench;
            
        }
        
        //Upload score
        GPGScore *myScore = [[GPGScore alloc] initWithLeaderboardId:leaderboardId];
        myScore.value = puntaje;
        [myScore submitScoreWithCompletionHandler:^(GPGScoreReport *report, NSError *error) {
            if(error)
            {
                
            }
        }];
    }
    
}


//Give achievements according to the score
-(void)darLogroConPuntaje:(int)puntaje
{
    BOOL signedInToGameServices = [GPGManager sharedInstance].isSignedIn;
    
    if(signedInToGameServices)
    {
        //Spanish
        if([self.language isEqualToString:NSLocalizedString(@"idiomaEspanol", nil)])
        {
            
            if (puntaje >= 10 && puntaje < 30)
            {
                //Novato
                [self desbloquearNovato];
            } else if (puntaje >= 30 && puntaje < 80)
            {
                //Novato
                [self desbloquearNovato];
                
                //Aprendiz
                [self desbloquearAprendiz];
                
            } else if (puntaje >= 80 && puntaje < 100)
            {
                //Novato
                [self desbloquearNovato];
                
                //Aprendiz
                [self desbloquearAprendiz];
                
                //Avanzado
                [self desbloquearAvanzado];
                
            } else if (puntaje >= 100 && puntaje < 200)
            {
                //Novato
                [self desbloquearNovato];
                
                //Aprendiz
                [self desbloquearAprendiz];
                
                //Avanzado
                [self desbloquearAvanzado];
                
                //Profesional
                [self desbloquearProfesional];
                
            } else if (puntaje >= 200)
            {
                //Novato
                [self desbloquearNovato];
                
                //Aprendiz
                [self desbloquearAprendiz];
                
                //Avanzado
                [self desbloquearAvanzado];
                
                //Profesional
                [self desbloquearProfesional];
                
                //Erudito
                [self desbloquearErudito];
                
            }
        }
        //English
        else if([self.language isEqualToString:NSLocalizedString(@"idiomaIngles", nil)])
        {
            if (puntaje >= 10 && puntaje < 30)
            {
                //Freshman
                [self desbloquearFreshman];
            } else if (puntaje >= 30 && puntaje < 80)
            {
                //Freshman
                [self desbloquearFreshman];
                
                //Apprentice
                [self desbloquearApprentice];
                
            } else if (puntaje >= 80 && puntaje < 100)
            {
                //Freshman
                [self desbloquearFreshman];
                
                //Apprentice
                [self desbloquearApprentice];
                
                //Advanced
                [self desbloquearAdvanced];
                
            } else if (puntaje >= 100 && puntaje < 200)
            {
                //Freshman
                [self desbloquearFreshman];
                
                //Apprentice
                [self desbloquearApprentice];
                
                //Advanced
                [self desbloquearAdvanced];
                
                //Professional
                [self desbloquearProfessional];
                
            } else if (puntaje >= 200)
            {
                //Freshman
                [self desbloquearFreshman];
                
                //Apprentice
                [self desbloquearApprentice];
                
                //Advanced
                [self desbloquearAdvanced];
                
                //Professional
                [self desbloquearProfessional];
                
                //Scholar
                [self desbloquearScholar];
                
            }
        }
        //French
        else if ([self.language isEqualToString:NSLocalizedString(@"idiomaFrances", nil)])
        {
            if (puntaje >= 10 && puntaje < 30)
            {
                //Novice
                [self desbloquearNovice];
            } else if (puntaje >= 30 && puntaje < 80)
            {
                //Novice
                [self desbloquearNovice];
                
                //Apprenti
                [self desbloquearApprenti];
                
            } else if (puntaje >= 80 && puntaje < 100)
            {
                //Novice
                [self desbloquearNovice];
                
                //Apprenti
                [self desbloquearApprenti];
                
                //Advance
                [self desbloquearAdvance];
                
            } else if (puntaje >= 100 && puntaje < 200)
            {
                //Novice
                [self desbloquearNovice];
                
                //Apprenti
                [self desbloquearApprenti];
                
                //Advance
                [self desbloquearAdvance];
                
                //Professionnel
                [self desbloquearProfessionnel];
                
            } else if (puntaje >= 200)
            {
                //Novice
                [self desbloquearNovice];
                
                //Apprenti
                [self desbloquearApprenti];
                
                //Advance
                [self desbloquearAdvance];
                
                //Professionnel
                [self desbloquearProfessionnel];
                
                //Savant
                [self desbloquearSavant];
                
            }
        }
    }
    
}

//Unlock achievement novato - Spanish
-(void)desbloquearNovato
{
    GPGAchievement *novato = [GPGAchievement achievementWithId:_logroNovato];
    
    //Novato
    [novato unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
    
}

//Unlock achievement aprendiz - Spanish
-(void)desbloquearAprendiz
{
    GPGAchievement *aprendiz = [GPGAchievement achievementWithId:_logroAprendiz];
    
    //Aprendiz
    [aprendiz unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Alredy unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement avanzado- Spanish
-(void)desbloquearAvanzado
{
    GPGAchievement *avanzado = [GPGAchievement achievementWithId:_logroAvanzado];
    
    //Avanzado
    [avanzado unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
    
}

//Unlock achievement profesional - Spanish
-(void)desbloquearProfesional
{
    GPGAchievement *profesional = [GPGAchievement achievementWithId:_logroProfesional];
    
    //Profesional
    [profesional unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
    
    
}

//Unlock achievement erudito - Spanish
-(void)desbloquearErudito
{
    GPGAchievement *erudito = [GPGAchievement achievementWithId:_logroErudito];
    
    //Erudito
    [erudito unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement freshman - English
-(void)desbloquearFreshman
{
    GPGAchievement *freshman = [GPGAchievement achievementWithId:_logroFreshman];
    
    //Freshman
    [freshman unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement apprentice - English
-(void)desbloquearApprentice
{
    GPGAchievement *apprentice = [GPGAchievement achievementWithId:_logroApprentice];
    
    //Apprentice
    [apprentice unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement advanced - English
-(void)desbloquearAdvanced
{
    GPGAchievement *advanced = [GPGAchievement achievementWithId:_logroAdvanced];
    
    //Advanced
    [advanced unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement professional - English
-(void)desbloquearProfessional
{
    GPGAchievement *professional = [GPGAchievement achievementWithId:_logroProfessional];
    
    //Professional
    [professional unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement scholar - English
-(void)desbloquearScholar
{
    GPGAchievement *scholar = [GPGAchievement achievementWithId:_logroScholar];
    
    //Scholar
    [scholar unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement novice - French
-(void)desbloquearNovice
{
    GPGAchievement *novice = [GPGAchievement achievementWithId:_logroNovice];
    
    //Novice
    [novice unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement apprenti - French
-(void)desbloquearApprenti
{
    GPGAchievement *apprenti = [GPGAchievement achievementWithId:_logroApprenti];
    
    //Apprenti
    [apprenti unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement advance - French
-(void)desbloquearAdvance
{
    GPGAchievement *advance = [GPGAchievement achievementWithId:_logroAdvance];
    
    //Advance
    [advance unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement professionnel - French
-(void)desbloquearProfessionnel
{
    GPGAchievement *professionnel = [GPGAchievement achievementWithId:_logroProfessionnel];
    
    //Professionnel
    [professionnel unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Unlock achievement savant - French
-(void)desbloquearSavant
{
    GPGAchievement *savant = [GPGAchievement achievementWithId:_logroSavant];
    
    //Savant
    [savant unlockAchievementWithCompletionHandler:^(BOOL newlyUnlocked, NSError *error) {
        if(error)
        {
            
        }
        else if(!newlyUnlocked)
        {
            //Already unlocked
        }
        else
        {
            //It was unlocked
        }
    }];
}

//Create an interstitial ad and load it
-(GADInterstitial *)createAndLoadInterstitial
{
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-1105716017576442/4431637419"];
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

//When the interstitial ad is closed load a new one
-(void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    //Load another interstitial ad
    self.interstitial = [self createAndLoadInterstitial];
    
    //Show a message when win
    if(_haGanadoBandera)
    {
        [self mostrarMensajeGano];
    }
    //Show a message when lose
    else
    {
        [self mostrarMensajePerdio];
    }
}

//Show winning message
-(void)mostrarMensajeGano
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc]init];
    [alertView setContainerView:[self crearDialogoFinal:NSLocalizedString(@"youWin", nil)]];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:NSLocalizedString(@"btnJugar", nil), NSLocalizedString(@"btnMenu", nil), NSLocalizedString(@"btnCompartir", nil), nil]];
    [alertView setDelegate:self];
    [alertView show];
}

//Show losing message
-(void)mostrarMensajePerdio
{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc]init];
    [alertView setContainerView:[self crearDialogoFinal:NSLocalizedString(@"youLost", nil)]];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:NSLocalizedString(@"btnJugar", nil), NSLocalizedString(@"btnMenu", nil), NSLocalizedString(@"btnCompartir", nil), nil]];
    [alertView setDelegate:self];
    [alertView show];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.screenName = @"Juego";
}


@end
