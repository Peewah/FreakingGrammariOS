//
//  MenuViewController.h
//  FreakingGrammariOS
//
//  Created by Juan Camilo Sacanamboy on 16/10/14.
//  Copyright (c) 2014 Peewah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <gpg/GooglePlayGames.h>
#import "GAITrackedViewController.h"


@interface MenuViewController : GAITrackedViewController

//Lenguaje seleccionado
@property (nonatomic, strong) NSString *language;
//Color de fondo
@property (nonatomic, strong) UIColor *backgroundColor;
//Label que muestra el lenguaje
@property (weak, nonatomic) IBOutlet UILabel *lblLanguage;
//Botón calificar
@property (weak, nonatomic) IBOutlet UIButton *btnCalificar;

//GPG IDs
@property (strong, nonatomic) NSString *leaderboardSpanish;
@property (strong, nonatomic) NSString *leaderboardEnglish;
@property (strong, nonatomic) NSString *leaderboardFrench;

@end
