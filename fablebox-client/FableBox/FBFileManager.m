//
//  FBFableFileManager.m
//  FableBox
//
//  Created by Halil AYYILDIZ on 9/13/13.
//  Copyright (c) 2013 Halil AYYILDIZ. All rights reserved.
//

#import "FBFileManager.h"

@interface FBFileManager()

- (NSString*) getFilePathForFileDir:(NSString*)fileDir withGuid:(NSString*)fableGuid;

@end

@implementation FBFileManager

+ (FBFileManager *)sharedSingleton
{
    static FBFileManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[FBFileManager alloc] init];
        }
        return sharedSingleton;
    }
}

- (NSURL*) getUrlForAPI:(NSString*)urlPath withGuid:(NSString*)fableGuid
{
    NSString *baseUrl = [NSString stringWithFormat:@"http://%@:%@%@", SERVER_HOSTNAME, SERVER_PORT, urlPath];
    NSString *fileUrl = [baseUrl stringByAppendingPathComponent:fableGuid];
    NSURL *url = [NSURL URLWithString:fileUrl];
    return url;
}

- (NSString*) getFilePathForFileDir:(NSString*)fileDir withGuid:(NSString*)fableGuid;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *basePath = [documentsPath stringByAppendingPathComponent:fileDir];
    NSString *filePath = [basePath stringByAppendingPathComponent:fableGuid];
    
    NSError*    theError = nil; //error setting
    if (![[NSFileManager defaultManager] fileExistsAtPath:basePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:&theError];
    }    
    
    return filePath;
}

- (void)saveFableAudioWithId:(NSString*)fableGuid downloadedData:(NSData*)downloadedData
{
    NSString *filePath = [self getFilePathForFileDir:DIR_FABLE_AUDIO withGuid:fableGuid];
    [downloadedData writeToFile:filePath atomically:YES];
}

- (void)saveFableImageSmallWithId:(NSString*)fableGuid downloadedData:(NSData*)downloadedData
{
    NSString *filePath = [self getFilePathForFileDir:DIR_FABLE_IMAGE_SMALL withGuid:fableGuid];
    [downloadedData writeToFile:filePath atomically:YES];
}

- (void)saveFableImageLargeWithId:(NSString*)fableGuid downloadedData:(NSData*)downloadedData
{
    NSString *filePath = [self getFilePathForFileDir:DIR_FABLE_IMAGE_LARGE withGuid:fableGuid];
    [downloadedData writeToFile:filePath atomically:YES];
}

- (NSData*) loadFableAudioWithId:(NSString*)fableGuid
{
    NSString *filePath = [self getFilePathForFileDir:DIR_FABLE_AUDIO withGuid:fableGuid];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

- (UIImage*) loadFableImageSmallWithId:(NSString*)fableGuid
{
    NSString *filePath = [self getFilePathForFileDir:DIR_FABLE_IMAGE_SMALL withGuid:fableGuid];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData: data];
    return image;
}

- (UIImage*) loadFableImageLargeWithId:(NSString*)fableGuid
{
    NSString *filePath = [self getFilePathForFileDir:DIR_FABLE_IMAGE_LARGE withGuid:fableGuid];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData: data];
    return image;
}

- (NSInteger) countOfDownloadedFables
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fableAudioPath = [documentsPath stringByAppendingPathComponent:DIR_FABLE_AUDIO];

    NSArray *filelist= [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fableAudioPath error:NULL];
    return [filelist count];
}

@end
