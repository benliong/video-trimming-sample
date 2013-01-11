//
//  VDOExistingVideoListViewController.m
//  Video Demo
//
//  Created by Ben Liong on 11/1/13.
//  Copyright (c) 2013 Pixls Limited. All rights reserved.
//

#import "VDOExistingVideoListViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "VDOVideoCell.h"

@interface VDOExistingVideoListViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIVideoEditorControllerDelegate>
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *videosArray;

@end

@implementation VDOExistingVideoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didPressAddButton:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"VDOVideoCell";
    VDOVideoCell *cell = (VDOVideoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (VDOVideoCell *)[array objectAtIndex:0];
    }
    
    
    cell.videoThumbnailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", indexPath.row + 1]];
    cell.videoTitleLabel.text = [[NSArray arrayWithObjects:@"Reporting 1 at UCSF", @"Interview with Security Head", @"Riot at Uganda downtown", @"First day of trail of Indian landmark case", @"Reporting roundup", nil] objectAtIndex:indexPath.row];
    cell.videoDetailsLabel.text = [NSString stringWithFormat:@"%@%% Completed",  [[NSArray arrayWithObjects:@"45", @"33", @"100", @"80", @"4", nil] objectAtIndex:indexPath.row]];
    switch (indexPath.row) {
        case 0:
            cell.progressView.progress = 0.45f;
            break;
        case 1:
            cell.progressView.progress = 0.33f;
            break;
        case 2:
            cell.progressView.progress = 1.0f;
            break;
        case 3:
            cell.progressView.progress = 0.80f;
            break;
        case 4:
            cell.progressView.progress = 0.04f;
            break;
        default:
            cell.progressView.progress = 0.0f;
            break;
    }
    
    if (indexPath.row == 2)
        cell.completed = YES;
    else
        cell.completed = NO;

    
    return cell;
}

#pragma mark -
#pragma mark Buttons Actions

- (void)didPressAddButton:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeVideo] ||
        [type isEqualToString:(NSString *)kUTTypeMovie]) { // movie != video
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSNumber *start = [info objectForKey:@"_UIImagePickerControllerVideoEditingStart"];
        NSNumber *end = [info objectForKey:@"_UIImagePickerControllerVideoEditingEnd"];
        
        int startMilliseconds = ([start doubleValue] * 1000);
        int endMilliseconds = ([end doubleValue] * 1000);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSString *outputURL = [documentsDirectory stringByAppendingPathComponent:@"output"] ;
        [manager createDirectoryAtPath:outputURL withIntermediateDirectories:YES attributes:nil error:nil];
        
        outputURL = [outputURL stringByAppendingPathComponent:@"output.mp4"];
        // Remove Existing File
        [manager removeItemAtPath:outputURL error:nil];
        
        
        //[self loadAssetFromFile:videoURL];
                
        AVURLAsset *videoAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:AVAssetExportPresetHighestQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:outputURL];
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        CMTimeRange timeRange = CMTimeRangeMake(CMTimeMake(startMilliseconds, 1000), CMTimeMake(endMilliseconds - startMilliseconds, 1000));
        exportSession.timeRange = timeRange;
        
        NSLog(@"begin trimming .. ");
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch (exportSession.status) {
                case AVAssetExportSessionStatusCompleted:
                    // Custom method to import the Exported Video
                    [self.videosArray addObject:exportSession.outputURL];
                    NSLog(@"Trimmed video to %@", exportSession.outputURL);
                    break;
                case AVAssetExportSessionStatusFailed:
                    //
                    NSLog(@"Failed:%@",exportSession.error);
                    break;
                case AVAssetExportSessionStatusCancelled:
                    //
                    NSLog(@"Canceled:%@",exportSession.error);
                    break;
                default:
                    break;
            }
        }];
        
        
        
        //NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        //NSString *videoStoragePath;//Set your video storage path to this variable
        //[videoData writeToFile:videoStoragePath atomically:YES];
        //You can store the path of the saved video file in sqlite/coredata here.
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    NSLog(@"saved to path: %@", editedVideoPath);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    NSLog(@"Failed with error: %@", [error localizedDescription]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
