//
//  SystemInfoHeaderView.h
//  Signature
//
//  Created by Andrei Zaharia on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemInfoHeaderView;

typedef void (^OnTogglePressed)(SystemInfoHeaderView *headerView);

@interface SystemInfoHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel   *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel   *lbName;
@property (nonatomic      ) BOOL                collapsed;
@property (nonatomic, copy) OnTogglePressed     onToggle;

@end
