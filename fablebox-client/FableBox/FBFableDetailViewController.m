//
//  FBFableDetailViewController.m
//  FableBox
//
//  Created by Halil AYYILDIZ on 9/9/13.
//  Copyright (c) 2013 Halil AYYILDIZ. All rights reserved.
//

#import <IADownloadManager.h>
#import "FBAppDelegate.h"
#import "FBFable.h"
#import "FBFableDetailViewController.h"
#import "FBFileManager.h"
#import "FBFableAudioPlayer.h"


@interface FBFableDetailViewController ()

@property (strong, nonatomic) FBFileManager *fileManager;
@property (strong, nonatomic) FBFableAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSTimer *sliderTimer;

@property (strong, nonatomic) UIView *imageView;
@property (strong, nonatomic) UIView *playerView;
@property (strong, nonatomic) UIView *progressView;

@end

@implementation FBFableDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    self.fileManager = [FBFileManager sharedSingleton];
    self.audioPlayer = [FBFableAudioPlayer sharedSingleton];
    self.imageView = [self.view viewWithTag:100];
    self.playerView = [self.view viewWithTag:101];
    self.progressView = [self.view viewWithTag:102];
    
    self.slider.value = 0;
    [self.togglePlayPauseButton setImage:[UIImage imageNamed:@"fb_player_pause.png"] forState:UIControlStateNormal];
    [self.togglePlayPauseButton setImage:[UIImage imageNamed:@"fb_player_play.png"] forState:UIControlStateSelected];
    [self handleFableAudio];
    [self handleFableImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    FBAppDelegate *appDelegate = (FBAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.container.panMode = MFSideMenuPanModeNone;
    
    self.imageView.frame = CGRectMake(20, 84, 280, [FBUtils displayMaxY]-188);
    self.playerView.frame = CGRectMake(20, [FBUtils displayMaxY]-84, 280, 64);
    self.progressView.frame = CGRectMake(20, [FBUtils displayMaxY]-84, 280, 64);
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.audioPlayer stopAudio];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setFable:(id)newFable
{
    if (_fable != newFable)
    {
        _fable = newFable;
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    FBFable *theFable = self.fable;
    
    if (theFable)
    {
        self.name.text = theFable.name;
        self.dateAdded.text = [FBUtils formatDate:theFable.dateAdded];
        self.length.text = [theFable formattedLength];
        self.isPaid.text = theFable.isPaid > 0 ? @"PAID" : @"FREE";
    }
}


- (IBAction)togglePlayPauseTapped:(id)sender
{
    if(self.togglePlayPauseButton.selected)
    {
        [self.audioPlayer playAudio];
        [self.togglePlayPauseButton setSelected:NO];
    }
    else
    {
        [self.audioPlayer pauseAudio];
        [self.togglePlayPauseButton setSelected:YES];
    }
}


- (void) handleFableAudio
{
    NSString *fableGuid = self.fable.guid;
    NSData *audioData = [self.fileManager loadFableAudioWithId:fableGuid];
    
    if(audioData == nil)
    {
        [self downloadAndPlayFableAudio];
        [self.playerView setHidden:YES];
    }
    else
    {
        [self playFableAudio:audioData];
        [self.progressView setHidden:YES];
    }
}

- (void) playFableAudio:(NSData*)audioData
{
    self.downloadProgressStatus.text = @"";
    [self.audioPlayer initAudioPlayerWith:audioData];
    
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    self.slider.maximumValue = [self.audioPlayer getAudioDuration];
//    [self.slider addTarget:self action:@selector(sliderDragged:) forControlEvents:UIControlEventValueChanged];
    
    [self.audioPlayer setDelegate:self];
    [self.audioPlayer playAudio];
}

- (void) downloadAndPlayFableAudio
{
    NSURL *url = [self.fileManager getUrlForAPI:API_FABLE_AUDIO withGuid:self.fable.guid];
    [IADownloadManager downloadItemWithURL:url useCache:NO];
    
    [IADownloadManager attachListenerWithObject:self
        progressBlock:^(float progress, NSURL *url)
        {
            self.downloadProgressStatus.text = [NSString stringWithFormat:@"Downloading  %.0lf %%", (progress * 100)];
            self.downloadProgressView.progress = progress;
        }
        completionBlock:^(BOOL success, id response)
        {
            NSLog(@"Fable audio download success.");
            // save downloaded file, then play
            [self.fileManager saveFableAudioWithId:self.fable.guid downloadedData:response];
            if (self.isViewLoaded && self.view.window)
            {
                // viewController is visible
                [self playFableAudio:response];
                [self.progressView setHidden:YES];
                [self.playerView setHidden:NO];
            }
        }
    toURL:url];
}

- (IBAction)sliderDragged:(id)sender
{
    [self.audioPlayer stopAudio];
    [self.audioPlayer setCurrentTime:self.slider.value];
    [self.audioPlayer playAudio];
}

- (void)updateSlider
{
    self.slider.value = [self.audioPlayer getCurrentTime];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    // Music completed
    if (flag)
    {
        [self.sliderTimer invalidate];
    }
}

- (void) handleFableImage
{
    
    
    
}



@end
