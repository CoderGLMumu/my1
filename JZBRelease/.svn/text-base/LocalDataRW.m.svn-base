//
//  LocalDataRW.m
//  JZBRelease
//
//  Created by zjapple on 16/5/9.
//  Copyright © 2016年 zjapple. All rights reserved.
//

#import "LocalDataRW.h"
#import "LoginVM.h"
#import "SBJson.h"
static NSString *documentPaht;
@implementation LocalDataRW

//获取本地模块路径
+(NSString *) getDirectory : (Directory_Type) type{
    NSString *path,*name;
    NSString *home = [[LoginVM getInstance] getAccountHomePath];
    switch (type) {
        case 0:
            name = @"bangba";
            break;
        case 1:
            name = @"renmai";
            break;
        case 2:
            name = @"bangquan";
            break;
        case 3:
            name = @"xueba";
            break;
        case 4:
            name = @"zixun";
            break;
            
        default:
            break;
    }
    path = [home stringByAppendingPathComponent:name];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    [manager fileExistsAtPath:path isDirectory:&isDirectory];
    if (!isDirectory) {
        [LocalDataRW makeDir:path];
    }
    return path;
}

+(BOOL) writeDataToLocaOfDocument : (NSArray *) ary AtFileName : (NSString *) fileName{
    BOOL isSuccess = NO;
    if (!documentPaht) {
        documentPaht = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *completePath = [[LocalDataRW getDirectory:Directory_BQ] stringByAppendingPathComponent:fileName];
    
    if (ary) {
        isSuccess = [ary writeToFile:completePath atomically:YES];
    }
    return isSuccess;
}


+(NSString *) makeDir : (NSString *) directoryPath{
    
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isExist,isDirectory;
    isExist = [filemanager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if (isDirectory && isExist) {
        return directoryPath;
    }else{
        if ([filemanager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return directoryPath;
        }
        return nil;
    }
}


+(NSMutableArray *) readDataFromLocalOfDocument : (NSString *) atFileName{
    NSMutableArray *ary;
    if (!documentPaht) {
        documentPaht = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSLog(@"%@",documentPaht);
    NSString *complete = [[LocalDataRW getDirectory:Directory_BQ] stringByAppendingPathComponent:atFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:complete]) {
        ary = [NSMutableArray arrayWithContentsOfFile:complete];
    }
    return ary;
}

+(BOOL) writeDataToLocaOfDocument : (NSArray *) ary WithDirectory_Type : (Directory_Type) type AtFileName : (NSString *) fileName{
    BOOL isSuccess = NO;
    if (!documentPaht) {
        documentPaht = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *completePath = [[LocalDataRW getDirectory:type] stringByAppendingPathComponent:fileName];
    
    if (ary) {
        isSuccess = [ary writeToFile:completePath atomically:YES];
    }
    return isSuccess;
}

+(NSMutableArray *) readDataFromLocalOfDocument : (NSString *) atFileName WithDirectory_Type : (Directory_Type) type{
    NSMutableArray *ary;
    if (!documentPaht) {
        documentPaht = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSLog(@"%@",documentPaht);
    NSString *complete = [[LocalDataRW getDirectory:type] stringByAppendingPathComponent:atFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:complete]) {
        ary = [[NSMutableArray alloc]initWithArray:[NSArray arrayWithContentsOfFile:complete]];
    }
    return ary;

}

+(BOOL) writeDictToLocaOfDocument : (NSDictionary *) dict WithDirectory_Type : (Directory_Type) type AtFileName : (NSString *) fileName{
    BOOL isSuccess = NO;
    if (!documentPaht) {
        documentPaht = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSString *completePath = [[LocalDataRW getDirectory:type] stringByAppendingPathComponent:fileName];
    
    if (dict) {
        NSString *string = [dict mj_JSONString];
        isSuccess = [string writeToFile:completePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    return isSuccess;

}

+(NSDictionary *) readDictFromLocalOfDocument : (NSString *) atFileName WithDirectory_Type : (Directory_Type) type{
    NSDictionary *dict;
    if (!documentPaht) {
        documentPaht = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    NSLog(@"%@",documentPaht);
    NSString *complete = [[LocalDataRW getDirectory:type] stringByAppendingPathComponent:atFileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:complete]) {
        NSString *string = [[NSString alloc]initWithContentsOfFile:complete encoding:NSUTF8StringEncoding error:nil];
        dict = [string mj_JSONObject];
    }
    return dict;

}

//获取图片
+(UIImage *) getImageWithDirectory : (Directory_Type) type RetalivePath : (NSString *) path{
    NSString *imageName = [[path stringByReplacingOccurrencesOfString:@"/" withString:@"_"] stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    UIImage *image = [UIImage imageWithContentsOfFile:[[LocalDataRW getDirectory:type] stringByAppendingPathComponent:imageName]];
    
    if (!image) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        if (data) {
            [data writeToFile:[[LocalDataRW getDirectory:type] stringByAppendingPathComponent:imageName] atomically:YES];
            image = [UIImage imageWithData:data];
        }
    }
    return image;
}

+(BOOL) writeImageWithDirectory : (Directory_Type) type RetalivePath : (NSString *) path WithImageData : (NSData *) data{
    NSString *imageName = [[path stringByReplacingOccurrencesOfString:@"/" withString:@"_"] stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    
    NSString *allPath = [[LocalDataRW getDirectory:type] stringByAppendingPathComponent:imageName];
    BOOL isSuccess = [data writeToFile:allPath atomically:YES];
    return isSuccess;
}

+(void)addCountWithType:(NSString *) type{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if (!type) {
        return;
    }
    NSNumber *count = [userDefault objectForKey:type];
    if (!count) {
        count = [NSNumber numberWithInt:1];
    }else{
        count = [NSNumber numberWithInt:([count intValue] + 1)];
    }
    [userDefault setObject:count forKey:type];
}

+(void)reduceCountWithType:(NSString *) type{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSNumber *count = [userDefault objectForKey:type];
    if (!count || [count intValue] == 0) {
        return;
    }else{
        count = [NSNumber numberWithInt:([count intValue] - 1)];
    }
    [userDefault setObject:count forKey:type];
}

+(NSNumber *)returnCountWithType:(NSString *) type{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *count = [userDefault objectForKey:type];
    if (!count) {
        count = [NSNumber numberWithInt:0];
    }
    return count;
}


+(void)clearToZeroWithType:(NSString *) type{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithInt:0] forKey:type];
    
}

//获取以字符串结尾的所有文件
+ (NSArray *)getAllFilesNameWithDirectory:(Directory_Type) directory_type WithRelativeDir:(NSString *)dirName WithSuffix:(NSString *) suffix{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path;
    if (dirName && dirName.length > 0) {
        path = [[LocalDataRW getDirectory:directory_type] stringByAppendingPathComponent:dirName];
    }else{
        path = [LocalDataRW getDirectory:directory_type];
    }
    NSDirectoryEnumerator *myDirectoryEnumerator = [fileManager enumeratorAtPath:path];  //baseSavePath 为文件夹的路径
    
    NSMutableArray *filePathArray = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    NSString *file;
    
    while((file=[myDirectoryEnumerator nextObject]))     //遍历当前目录
    {
        NSRange range = [file rangeOfString:suffix];
        if(range.length > 0)  //取得后缀名为suffix的文件名
        {
            [filePathArray addObject:[path stringByAppendingPathComponent:file]];//存到数组
        }
    }
    return filePathArray;
}

+ (NSString *)calculateFilesSize:(NSArray *)filesArray{
    long long allSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (int i = 0; i < filesArray.count; i ++) {
        NSString *filePath = [filesArray objectAtIndex:i];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSLog(@"%ld",data.length);
        allSize += [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    if (allSize / (1024 * 1024) > 0) {
        NSString *smlSize = [NSString stringWithFormat:@"%lld",allSize % (1024 * 1024)];
        smlSize = [smlSize substringToIndex:1];
        if ([smlSize integerValue] == 0) {
            return [NSString stringWithFormat:@"%lldM",allSize / (1024 * 1024)];
        }else{
            return [NSString stringWithFormat:@"%lld.%@M",allSize / (1024 * 1024),smlSize];
        }
    }else{
        return [NSString stringWithFormat:@"%ldK",(long)allSize / 1024];
    }
    
}


+ (void)removeFileFromLocalWithPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        [fileManager removeItemAtPath:path error:nil];
    }
}

@end
