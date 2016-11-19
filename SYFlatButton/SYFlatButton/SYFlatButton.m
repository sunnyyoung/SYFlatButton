//
//  SYFlatButton.m
//  SYFlatButton
//
//  Created by Sunnyyoung on 2016/11/17.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "SYFlatButton.h"

@interface SYFlatButton () <CALayerDelegate>

@property (nonatomic, strong) CAShapeLayer *imageLayer;
@property (nonatomic, strong) CATextLayer *titleLayer;
@property (nonatomic, assign) BOOL mouseDown;

@end

@implementation SYFlatButton

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
        [self setupImageLayer];
        [self setupTitleLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self setup];
        [self setupImageLayer];
        [self setupTitleLayer];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTrackingArea:[[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingActiveAlways|NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited owner:self userInfo:nil]];
}

#pragma mark - Drawing method

- (void)drawRect:(NSRect)dirtyRect {
    // Do nothing
}

- (BOOL)layer:(CALayer *)layer shouldInheritContentsScale:(CGFloat)newScale fromWindow:(NSWindow *)window {
    return YES;
}

#pragma mark - Setup method

- (void)setup {
    // Setup layer
    self.wantsLayer = YES;
    self.layer.masksToBounds = YES;
    self.layer.delegate = self;
    self.layer.backgroundColor = [NSColor redColor].CGColor;
    self.alphaValue = self.isEnabled ? 1.0 : 0.5;
    [self.layer addSublayer:self.imageLayer];
    [self.layer addSublayer:self.titleLayer];
}

- (void)setupImageLayer {
    if (!self.image) {
        return;
    }
    CALayer *maskLayer = [CALayer layer];
    CGSize imageSize = self.image.size;
    maskLayer.frame = NSMakeRect(round((CGRectGetWidth(self.bounds)-imageSize.width)/2.0),
                                 round((CGRectGetHeight(self.bounds)-imageSize.height)/2.0),
                                 imageSize.width,
                                 imageSize.height);
    NSRect imageRect = NSMakeRect(0.0, 0.0, imageSize.width, imageSize.height);
    CGImageRef imageRef = [self.image CGImageForProposedRect:&imageRect context:nil hints:nil];
    maskLayer.contents = (__bridge id _Nullable)(imageRef);
    self.imageLayer.frame = self.bounds;
    self.imageLayer.mask = maskLayer;
}

- (void)setupTitleLayer {
    if (!self.layer || !self.font) {
        return;
    }
    CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName: self.font}];
    self.titleLayer.frame = NSMakeRect(round((CGRectGetWidth(self.bounds)-titleSize.width)/2.0),
                                       round((CGRectGetHeight(self.bounds)-titleSize.height)/2.0),
                                       titleSize.width,
                                       titleSize.height);
    self.titleLayer.string = self.title;
    self.titleLayer.font = (__bridge CFTypeRef _Nullable)(self.font);
    self.titleLayer.fontSize = self.font.pointSize;
}

#pragma mark - Animation method

- (void)removeAllAnimations {
    [self.layer removeAllAnimations];
    if (self.layer.sublayers.count) {
        for (CALayer *layer in self.layer.sublayers) {
            [layer removeAllAnimations];
        }
    }
}

- (void)animateColorWithState:(NSCellStateValue)state {
    [self removeAllAnimations];
    CGFloat duration = (state == NSOnState) ? self.onAnimateDuration : self.offAnimateDuration;
    NSColor *borderColor = (state == NSOnState) ? self.borderHighlightColor : self.borderNormalColor;
    NSColor *backgroundColor = (state == NSOnState) ? self.backgroundHighlightColor : self.backgroundNormalColor;
    NSColor *titleColor = (state == NSOnState) ? self.titleHighlightColor : self.titleNormalColor;
    NSColor *imageColor = (state == NSOnState) ? self.imageHighlightColor : self.imageNormalColor;
    [self animateLayer:self.layer color:borderColor keyPath:@"borderColor" duration:duration];
    [self animateLayer:self.layer color:backgroundColor keyPath:@"backgroundColor" duration:duration];
    [self animateLayer:self.imageLayer color:imageColor keyPath:@"backgroundColor" duration:duration];
    [self animateLayer:self.titleLayer color:titleColor keyPath:@"foregroundColor" duration:duration];
}

- (void)animateLayer:(CALayer *)layer color:(NSColor *)color keyPath:(NSString *)keyPath duration:(CGFloat)duration {
    if ((__bridge CGColorRef _Nullable)[layer valueForKeyPath:keyPath] != color.CGColor) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
        animation.fromValue = [layer valueForKeyPath:keyPath];
        animation.toValue = (__bridge id _Nullable)(color.CGColor);
        animation.duration = duration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [layer addAnimation:animation forKey:keyPath];
        [layer setValue:(__bridge id _Nullable)color.CGColor forKey:keyPath];
    }
}

#pragma mark - Event Response

- (NSView *)hitTest:(NSPoint)point {
    return self.isEnabled ? [super hitTest:point] : nil;
}

- (void)mouseDown:(NSEvent *)event {
    if (self.isEnabled) {
        self.mouseDown = YES;
        self.state = (self.state == NSOnState) ? NSOffState : NSOnState;
    }
}

- (void)mouseEntered:(NSEvent *)event {
    if (self.mouseDown) {
        self.state = (self.state == NSOnState) ? NSOffState : NSOnState;
    }
}

- (void)mouseExited:(NSEvent *)event {
    if (self.mouseDown) {
        self.mouseDown = NO;
        self.state = (self.state == NSOnState) ? NSOffState : NSOnState;
    }
}

- (void)mouseUp:(NSEvent *)event {
    if (self.mouseDown) {
        self.mouseDown = NO;
        if (self.momentary) {
            self.state = (self.state == NSOnState) ? NSOffState : NSOnState;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
    }
}

#pragma mark - Property method

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    [self setupTitleLayer];
}

- (void)setFont:(NSFont *)font {
    [super setFont:font];
    [self setupTitleLayer];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [self setupTitleLayer];
}

- (void)setImage:(NSImage *)image {
    [super setImage:image];
    [self setupImageLayer];
}

- (void)setState:(NSInteger)state {
    [super setState:state];
    [self animateColorWithState:state];
}

- (void)setMomentary:(BOOL)momentary {
    _momentary = momentary;
    [self animateColorWithState:self.state];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

- (void)setBorderNormalColor:(NSColor *)borderNormalColor {
    _borderNormalColor = borderNormalColor;
    [self animateColorWithState:self.state];
}

- (void)setBorderHighlightColor:(NSColor *)borderHighlightColor {
    _borderHighlightColor = borderHighlightColor;
    [self animateColorWithState:self.state];
}

- (void)setBackgroundNormalColor:(NSColor *)backgroundNormalColor {
    _backgroundNormalColor = backgroundNormalColor;
    [self animateColorWithState:self.state];
}

- (void)setBackgroundHighlightColor:(NSColor *)backgroundHighlightColor {
    _backgroundHighlightColor = backgroundHighlightColor;
    [self animateColorWithState:self.state];
}

- (void)setImageNormalColor:(NSColor *)imageNormalColor {
    _imageNormalColor = imageNormalColor;
    [self animateColorWithState:self.state];
}

- (void)setImageHighlightColor:(NSColor *)imageHighlightColor {
    _imageHighlightColor = imageHighlightColor;
    [self animateColorWithState:self.state];
}

- (void)setTitleNormalColor:(NSColor *)titleNormalColor {
    _titleNormalColor = titleNormalColor;
    [self animateColorWithState:self.state];
}

- (void)setTitleHighlightColor:(NSColor *)titleHighlightColor {
    _titleHighlightColor = titleHighlightColor;
    [self animateColorWithState:self.state];
}

- (CAShapeLayer *)imageLayer {
    if (_imageLayer == nil) {
        _imageLayer = [[CAShapeLayer alloc] init];
        _imageLayer.delegate = self;
    }
    return _imageLayer;
}

- (CATextLayer *)titleLayer {
    if (_titleLayer == nil) {
        _titleLayer = [[CATextLayer alloc] init];
        _titleLayer.delegate = self;
    }
    return _titleLayer;
}

@end
