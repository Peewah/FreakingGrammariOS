//
//  PlayViewController.h
//  FreakingGrammariOS
//
//  Created by Juan Camilo Sacanamboy on 5/06/15.
//  Copyright (c) 2015 Peewah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pregunta.h"
#import <CustomIOSAlertView.h>
#import <gpg/GooglePlayGames.h>
#import "GAITrackedViewController.h"
@import GoogleMobileAds;


@interface PlayViewController : GAITrackedViewController <CustomIOSAlertViewDelegate, GADInterstitialDelegate>
//Current language
@property (strong, nonatomic) NSString *language;
//List of questions
@property (strong, nonatomic) NSMutableArray *preguntas;
//Current question
@property (strong, nonatomic) Pregunta *preguntaActual;
//Current socre
@property (nonatomic) int puntajeActual;
//List of colors
@property (strong, nonatomic) NSArray *colores;
//Timer
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSTimeInterval totalCountdownInterval;
@property (strong, nonatomic) NSDate *fechaInicial;
//Sound property
@property (nonatomic) BOOL sound;
//UI components
@property (weak, nonatomic) IBOutlet UITextView *tvFrase;
@property (weak, nonatomic) IBOutlet UIButton *btnRespuestaUno;
@property (weak, nonatomic) IBOutlet UIButton *btnRespuestaDos;
@property (weak, nonatomic) IBOutlet UILabel *tvPuntaje;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *btnSonido;

//Flag to determine if user have answered correctly all the questions
@property (nonatomic) BOOL haGanadoBandera;

//Google Play Games IDs
@property (strong, nonatomic) NSString *leaderboardSpanish;
@property (strong, nonatomic) NSString *leaderboardEnglish;
@property (strong, nonatomic) NSString *leaderboardFrench;


@property (strong, nonatomic) NSString *logroNuevo;
@property (strong, nonatomic) NSString *logroNovato;
@property (strong, nonatomic) NSString *logroAprendiz;
@property (strong, nonatomic) NSString *logroAvanzado;
@property (strong, nonatomic) NSString *logroProfesional;
@property (strong, nonatomic) NSString *logroErudito;

@property (strong, nonatomic) NSString *logroNewbie;
@property (strong, nonatomic) NSString *logroFreshman;
@property (strong, nonatomic) NSString *logroApprentice;
@property (strong, nonatomic) NSString *logroAdvanced;
@property (strong, nonatomic) NSString *logroProfessional;
@property (strong, nonatomic) NSString *logroScholar;

@property (strong, nonatomic) NSString *logroDebutant;
@property (strong, nonatomic) NSString *logroNovice;
@property (strong, nonatomic) NSString *logroApprenti;
@property (strong, nonatomic) NSString *logroAdvance;
@property (strong, nonatomic) NSString *logroProfessionnel;
@property (strong, nonatomic) NSString *logroSavant;

//GADInterstitial
@property(strong, nonatomic) GADInterstitial *interstitial;

@end
