//
//  EndScene.m
//  breakingBricks
//
//  Created by Harold_Davis on 4/15/14.
//  Copyright (c) 2014 Zendoart, inc. All rights reserved.
//

#import "EndScene.h"

@implementation EndScene

-(instancetype) initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"YOU LOSE!";
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 44;
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
    }
    return self;

}


@end
