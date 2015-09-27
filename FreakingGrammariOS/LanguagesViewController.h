//
//  ViewController.h
//  FreakingGrammariOS
//
//  Created by Juan Camilo Sacanamboy on 14/10/14.
//  Copyright (c) 2014 Peewah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <CustomIOSAlertView.h>
#import <gpg/GooglePlayGames.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "GAITrackedViewController.h"


@interface LanguagesViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate, GPGStatusDelegate>

//TableView de idiomas
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//Lista de idiomas disponibles
@property (strong,nonatomic) NSArray *idiomas;

//Colores
@property (strong, nonatomic) NSArray *colorEspanol;

@property (strong, nonatomic) NSArray *colorIngles;

@property (strong, nonatomic) NSArray *colorFrances;

@property (strong, nonatomic) NSArray *colorDeshabilitado;

@property (strong, nonatomic) NSArray *colorLetrasDeshabilitado;

//Diálogo
@property (strong, nonatomic) CustomIOSAlertView *alertView;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

