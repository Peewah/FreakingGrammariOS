//
//  Pregunta.h (Question in english)
//  FreakingGrammariOS
//
//  Created by Juan Camilo Sacanamboy on 4/06/15.
//  Copyright (c) 2015 Peewah. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Pregunta : NSObject
//Phrase
@property (strong, nonatomic) NSString *frase;
//Good answer
@property (strong, nonatomic) NSString *respuestaBuena;
//Bad answer
@property (strong, nonatomic) NSString *respuestaMala;
@end
