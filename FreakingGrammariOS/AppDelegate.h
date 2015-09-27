//
//  AppDelegate.h
//  FreakingGrammariOS
//
//  Created by Juan Camilo Sacanamboy on 14/10/14.
//  Copyright (c) 2014 Peewah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Appirater/Appirater.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//Lista de preguntas español
@property (strong, nonatomic) NSMutableArray *preguntasEspanol;

//Lista de preguntas inglés
@property (strong, nonatomic) NSMutableArray *preguntasIngles;

//Lista de preguntas francés
@property (strong, nonatomic) NSMutableArray *preguntasFrances;

@end

