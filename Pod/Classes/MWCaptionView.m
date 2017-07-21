//
//  MWCaptionView.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 30/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MWCommon.h"
#import "MWCaptionView.h"
#import "MWPhoto.h"

// Private
@interface MWCaptionView () {
    id <MWPhoto> _photo;
    UITextView *_textView;
    CGFloat _labelPadding;
    NSMutableParagraphStyle *_paragraphStyle;
    UIFont *_font;
}
@end

@implementation MWCaptionView

- (id)initWithPhoto:(id<MWPhoto>)photo {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)]; // Random initial frame
    if (self) {
        //self.userInteractionEnabled = NO;
        _photo = photo;
        self.barStyle = UIBarStyleBlackTranslucent;
        self.tintColor = nil;
        self.barTintColor = nil;
        self.barStyle = UIBarStyleBlackTranslucent;
        [self setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        _paragraphStyle.alignment = NSTextAlignmentJustified;
        _paragraphStyle.lineHeightMultiple = 20.0f;
        _paragraphStyle.maximumLineHeight = 20.0f;
        _paragraphStyle.minimumLineHeight = 20.0f;
        
        UIFont *font = [UIFont fontWithName:@"GothamPro" size:17];
        if (font != nil) {
            _font = font;
        } else {
            _font = [UIFont systemFontOfSize:17];
        }
        
        [self setupCaption];
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    _labelPadding = size.width * 0.1;
    CGFloat maxHight = (CGFloat)CGRectGetHeight([[UIScreen mainScreen] bounds]) / 2;
    _textView.frame = CGRectIntegral(CGRectMake(_labelPadding, 10,
                                                self.bounds.size.width - _labelPadding * 2,
                                                self.bounds.size.height - 20));
    
    CGSize textSize = [_textView.text boundingRectWithSize:CGSizeMake(size.width - _labelPadding * 2, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:_font,
                                                          NSParagraphStyleAttributeName : _paragraphStyle}
                                                context:nil].size;
    return CGSizeMake(size.width, MIN(maxHight, textSize.height + 40));
}

- (void)setupCaption {
    _textView = [[UITextView alloc] initWithFrame:CGRectIntegral(CGRectMake(_labelPadding, 10,
                                                                            self.bounds.size.width - _labelPadding * 2,
                                                                            self.bounds.size.height - 20))];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _textView.opaque = NO;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = NO;
    
    __block NSString *text = @" ";
    if ([_photo respondsToSelector:@selector(caption)]) {
        text = [_photo caption] ? [_photo caption] : @" ";
    }
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:text];
    [title addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, title.length)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSParagraphStyleAttributeName value:_paragraphStyle range:NSMakeRange(0, title.length)];
    
    _textView.attributedText = title;
    
    [self addSubview:_textView];
}


@end
