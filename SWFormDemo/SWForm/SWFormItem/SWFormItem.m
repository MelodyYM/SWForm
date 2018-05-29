//
//  SWFormItem.m
//  SWFormDemo
//
//  Created by zijin on 2018/5/28.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "SWFormItem.h"
#import "SWFormCompat.h"

@interface SWFormItem()

+ (instancetype)sw_itemWithTitle:(NSString *)title info:(NSString *)info itemType:(SWFormItemType)itemType editable:(BOOL)editable required:(BOOL)required keyboardType:(UIKeyboardType)keyboardType;

+ (instancetype)sw_itemWithTitle:(NSString *)title info:(NSString *)info itemType:(SWFormItemType)itemType;

@end

inline SWFormItem *SWFormItem_Add(NSString *title, NSString *info, SWFormItemType itemType, BOOL editable, BOOL required, UIKeyboardType keyboardType) {
    return [SWFormItem sw_itemWithTitle:title info:info itemType:itemType editable:editable required:required keyboardType:keyboardType];
}

inline SWFormItem *SWFormItem_Info(NSString *title, NSString *info, SWFormItemType itemType) {
    return [SWFormItem sw_itemWithTitle:title info:info itemType:itemType];
}

@implementation SWFormItem

+ (instancetype)sw_itemWithTitle:(NSString *)title info:(NSString *)info itemType:(SWFormItemType)itemType editable:(BOOL)editable required:(BOOL)required keyboardType:(UIKeyboardType)keyboardType {
    return [[self alloc]initWithTitle:title info:info itemType:itemType editable:editable required:required keyboardType:keyboardType images:nil showPlaceholder:YES];
}

+ (instancetype)sw_itemWithTitle:(NSString *)title info:(NSString *)info itemType:(SWFormItemType)itemType {
    return [[self alloc]initWithTitle:title info:info itemType:itemType editable:NO required:NO keyboardType:UIKeyboardTypeDefault images:nil showPlaceholder:NO];
}

- (instancetype)initWithTitle:(NSString *)title info:(NSString *)info itemType:(SWFormItemType)itemType editable:(BOOL)editable required:(BOOL)required keyboardType:(UIKeyboardType)keyboardType images:(NSArray *)images showPlaceholder:(BOOL)showPlaceholder{
    self = [super init];
    if (self) {
        self.defaultHeight = 44.0f;
        self.title = title;
        self.info = info;
        self.itemType = itemType;
        self.editable = editable;
        self.required = required;
        self.keyboardType = keyboardType;
        self.images = images;
        [self sw_setPlaceholderWithShow:showPlaceholder];
        [self sw_setAttributedTitleWithRequired:required title:title itemType:itemType];
    }
    return self;
}

- (void)sw_setPlaceholderWithShow:(BOOL)show {
    if (!show) {
        self.placeholder = @"";
        return;
    }
    switch (self.itemType) {
        case SWFormItemTypeInput:
        case SWFormItemTypeTextViewInput:
        {
            self.placeholder = @"请输入";
        }
            break;
        case SWFormItemTypeSelect:
        {
            self.placeholder = @"请选择";
        }
            break;
            
        default:
            self.placeholder = @"";
            break;
    }
}

- (void)sw_setAttributedTitleWithRequired:(BOOL)required title:(NSString *)title itemType:(SWFormItemType)itemType{
    if (required) {
        if (SW_RequriedType == SWRequriedTypeDefault) {
            switch (self.itemType) {
                case SWFormItemTypeInput:
                case SWFormItemTypeTextViewInput:
                {
                    title = [NSString stringWithFormat:@"%@(必填)", title];
                }
                    break;
                case SWFormItemTypeSelect:
                case SWFormItemTypeImage:
                {
                    title = [NSString stringWithFormat:@"%@(必选)", title];
                }
                    break;
                default:
                    break;
            }
        }
        else if (SW_RequriedType == SWRequriedTypeRedStarFront) {
            title = [NSString stringWithFormat:@"*%@", title];
        }
        else if (SW_RequriedType == SWRequriedTypeRedStarBack) {
            title = [NSString stringWithFormat:@"%@*", title];
        }
    }
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SW_TitleFont], NSForegroundColorAttributeName:SW_TITLECOLOR}];
    
    if (required) {
        if (SW_RequriedType == SWRequriedTypeRedStarFront) {
            [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        }
        else if (SW_RequriedType == SWRequriedTypeRedStarBack) {
            [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(title.length - 1, 1)];
        }
    }
    self.attributedTitle = attributedTitle;
}

#pragma mark -- 重写属性set方法，防止单独改变属性无响应效果
- (void)setTitle:(NSString *)title {
    _title = title;
    [self sw_setAttributedTitleWithRequired:self.required title:title itemType:self.itemType];
}

- (void)setRequired:(BOOL)required {
    _required = required;
    [self sw_setAttributedTitleWithRequired:required title:self.title itemType:self.itemType];
}

- (void)setItemType:(SWFormItemType)itemType {
    _itemType = itemType;
    [self sw_setAttributedTitleWithRequired:self.required title:self.title itemType:itemType];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    NSMutableAttributedString *attributedPlaceholder = [[NSMutableAttributedString alloc]initWithString:placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SW_TitleFont],NSForegroundColorAttributeName:SW_PLACEHOLDERCOLOR}];
    self.attributedPlaceholder = attributedPlaceholder;
}

@end
