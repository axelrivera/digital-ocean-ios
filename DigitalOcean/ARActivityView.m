//
//  ARActivityView.m
//
//  Created by Axel Rivera on 2/13/13.
//  Copyright (c) 2013 Axel Rivera. All rights reserved.
//

#import "ARActivityView.h"

#define kActivityIndicatorWidth 20.0
#define kActivityIndicatorHeight 20.0

@interface ARActivityView ()

@property (strong, nonatomic, readwrite) UIView *contentView;
@property (strong, nonatomic, readwrite) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic, readwrite) UILabel *textLabel;

@property (assign, nonatomic, readwrite, getter = isShowing) BOOL showing;
@property (assign, nonatomic, readwrite, getter = hasIndicator) BOOL indicator;

@end

@implementation ARActivityView

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
		self.opaque = YES;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		self.backgroundColor = [UIColor whiteColor];
        
        _animationDuration = 0.2;
		
		[self setTitle:NSLocalizedString(@"Loading...", @"Loading Indicator") indicator:YES];
		
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
		[self addSubview:_contentView];
		
		_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		_activityIndicator.hidesWhenStopped = YES;
		[_activityIndicator startAnimating];
		[_contentView addSubview:_activityIndicator];
		
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.font = [UIFont boldSystemFontOfSize:14.0];
		_textLabel.textColor = [UIColor darkGrayColor];
		_textLabel.textAlignment = NSTextAlignmentLeft;
		_textLabel.numberOfLines = 1;
		_textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
		_textLabel.text = _title;
		[_contentView addSubview:_textLabel];
		
		[self hide];
    }
    return self;
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title
{
	[self setTitle:title indicator:NO];
}

- (void)setTitle:(NSString *)title indicator:(BOOL)indicator
{
	_title = title;
	_indicator = indicator;
	self.textLabel.text = title;
	
	if (indicator) {
		self.activityIndicator.alpha = 1.0;
	} else {
		self.activityIndicator.alpha = 0.0;
	}
	[self setNeedsLayout];
}

- (void)show
{
    [self showAnimated:YES];
}

- (void)showAnimated:(BOOL)animated
{
	self.showing = YES;
	
    // Dismiss Keyboard if Necessary
    [self.superview endEditing:YES];
    
	// Making sure I'm on top
	[self.superview bringSubviewToFront:self];
	
	CGRect visibleRect = self.superview.bounds;
	
	if ([self.superview isKindOfClass:[UIScrollView class]]) {
		UIScrollView *scrollView = (UIScrollView *)self.superview;
		[scrollView setScrollEnabled:NO];
		
		// Kill the Scroller
		CGPoint offset = scrollView.contentOffset;
		[scrollView setContentOffset:offset animated:NO];
		
		visibleRect.origin = scrollView.contentOffset;
		visibleRect.size = scrollView.bounds.size;
		CGFloat scale = 1.0 / scrollView.zoomScale;
		visibleRect.origin.x *= scale;
		visibleRect.origin.y *= scale;
		visibleRect.size.width *= scale;
		visibleRect.size.height *= scale;
	}
	
	self.frame = visibleRect;
	[self setNeedsLayout];
    
    NSTimeInterval duration = animated ? self.animationDuration : 0.0;
	
	[UIView animateWithDuration:duration animations:^{
		[self.activityIndicator startAnimating];
		self.alpha = 1.0;
	}];
}

- (void)hide
{
    [self hideAnimated:YES];
}

- (void)hideAnimated:(BOOL)animated
{
	self.showing = NO;
    
    NSTimeInterval duration = animated ? self.animationDuration : 0.0;
    
	[UIView animateWithDuration:duration animations:^{
		[self.activityIndicator stopAnimating];
		self.alpha = 0.0;
	}];
	
	[self.superview sendSubviewToBack:self];
	
	if ([self.superview isKindOfClass:[UIScrollView class]]) {
		[(UIScrollView *)self.superview setScrollEnabled:YES];
	}
}

#pragma mark - Override Methods

- (void)layoutSubviews
{
#define kHorizontalPadding 5.0
	
	CGRect bgFrame = self.bounds;
	CGRect contentFrame;
	
	CGFloat contentWidth = 0.0;
	CGFloat activityWidth = 0.0;
	CGFloat activityPadding = 0.0;
	
	if (self.hasIndicator) {
		CGRect activityFrame;
		activityWidth = kActivityIndicatorWidth;
		activityPadding = kHorizontalPadding;
		activityFrame = CGRectMake(0.0, 0.0, kActivityIndicatorWidth, kActivityIndicatorHeight);
		self.activityIndicator.frame = activityFrame;
	}
	
	if (self.title) {
		CGRect textFrame;
        NSDictionary *attributes = @{ NSFontAttributeName : self.textLabel.font };
        CGSize textSize = [self.title sizeWithAttributes:attributes];
        CGFloat maxTextWidth = self.hasIndicator ? kActivityIndicatorWidth + 20.0 : 20.0;
		CGFloat cappedWidth = bgFrame.size.width - maxTextWidth;
		CGFloat textWidth = textSize.width > cappedWidth ? cappedWidth : textSize.width;
		
		textFrame = CGRectMake(0.0 + activityWidth + activityPadding,
							   0.0,
							   textWidth,
							   kActivityIndicatorHeight);
		self.textLabel.frame = textFrame;
		
		contentWidth = activityWidth + activityPadding + textWidth;
	}
	
	contentFrame = CGRectMake((bgFrame.size.width / 2.0) - (contentWidth / 2.0),
							  (bgFrame.size.height / 2.0) - (kActivityIndicatorHeight / 2.0),
							  contentWidth,
							  kActivityIndicatorHeight);
	self.contentView.frame = contentFrame;
}

@end
