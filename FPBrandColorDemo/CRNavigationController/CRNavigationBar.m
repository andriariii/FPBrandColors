//
//  CRNavigationBar.m
//  CRNavigationControllerExample
//
//  Created by Corey Roberts on 9/24/13.
//  Copyright (c) 2013 SpacePyro Inc. All rights reserved.
//

#import "CRNavigationBar.h"

@interface CRNavigationBar ()
@property (nonatomic, strong) CALayer *colorLayer;
@end

@implementation CRNavigationBar

static CGFloat const kDefaultColorLayerOpacity = 0.5f;
static CGFloat const kSpaceToCoverStatusBars = 20.0f;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

- (void)setBarTintColor:(UIColor *)barTintColor {

    [super setBarTintColor:barTintColor];
    
    // As of iOS 7.0.3, colors definitely seem a little bit more saturated.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.3")) {
        
        // Override the opacity if wanted.
        if(self.overrideOpacity) {
            CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
            [barTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
            [super setBarTintColor:[UIColor colorWithRed:red green:green blue:blue alpha:kDefaultNavigationBarAlpha]];
        }
        
        // This code isn't perfect and has been commented out for now. It seems like
        // the additional color layer doesn't work well now that translucency is based
        // primarily on the opacity of the navigation bar (and its respective layers).
        
        // if (self.colorLayer == nil) {
        //    self.colorLayer = [CALayer layer];
        //    self.colorLayer.opacity = kDefaultColorLayerOpacity - 0.2f;
        //    [self.layer addSublayer:self.colorLayer];
        // }
        
        // self.colorLayer.backgroundColor = barTintColor.CGColor;
    }
    else {
        
        if (self.colorLayer == nil) {
            self.colorLayer = [CALayer layer];
            self.colorLayer.opacity = kDefaultColorLayerOpacity;
            [self.layer addSublayer:self.colorLayer];
        }
        
        self.colorLayer.backgroundColor = barTintColor.CGColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.colorLayer != nil) {
        self.colorLayer.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);

        [self.layer insertSublayer:self.colorLayer atIndex:1];
    }
}

- (void)displayColorLayer:(BOOL)display {
    self.colorLayer.hidden = !display;
}

@end
