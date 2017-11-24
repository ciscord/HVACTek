//
//  FileModel+CoreDataClass.h
//  HvacTek
//
//  Created by Max on 11/22/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject
@property (nonatomic, strong) NSString *createAt;
@property (nonatomic, strong) NSString *desString;
@property (nonatomic, strong) NSString *fileId;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *fullUrl;
@property (nonatomic, strong) NSString *iqaId;
@property (nonatomic, strong) NSString *ord;
@property (nonatomic, strong) NSString *type;
@end

