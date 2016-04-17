//
//  ShareViewController.m
//  ShareImage
//
//  Created by Firoz Khan on 12/04/16.
//  Copyright (c) 2016 Firoz Khan. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

static NSString *const kSharedImagesKey = @"sharedImages";

@interface ShareViewController ()

@property (nonatomic, copy) NSMutableArray *dataArray;
@property (strong, nonatomic) NSUserDefaults *albumDefaults;
@property (weak, nonatomic) IBOutlet UIImageView *sharingImageView;

- (IBAction)addButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

@implementation ShareViewController

-(void)viewDidLoad{
  [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  if(!_albumDefaults) {
    _albumDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.MyAlbum.com"];
  }
  _dataArray = [[NSMutableArray alloc]initWithArray:[_albumDefaults arrayForKey:kSharedImagesKey]];
  [self getSelectedImage];
}

#pragma mark - Data method

-(void)getSelectedImage{
  
  for (NSItemProvider* itemProvider in ((NSExtensionItem*)self.extensionContext.inputItems[0]).attachments ) {
    
    NSString *imageType = (__bridge NSString *)kUTTypeImage;
    
    if([itemProvider hasItemConformingToTypeIdentifier:imageType]) {
      
      [itemProvider loadItemForTypeIdentifier:imageType options:nil completionHandler: ^(id<NSSecureCoding> item, NSError *error) {
        
        NSData *imgData;
        if([(NSObject*)item isKindOfClass:[NSURL class]]) {
          imgData = [NSData dataWithContentsOfURL:(NSURL*)item];
        }
        if([(NSObject*)item isKindOfClass:[UIImage class]]) {
          imgData = UIImagePNGRepresentation((UIImage*)item);
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          _sharingImageView.image = [UIImage imageWithData:imgData];
          [_dataArray addObject:imgData];
        }];
        
      }];
    }
  }
}

#pragma mark - Action Methods
- (IBAction)addButtonPressed:(id)sender
{
  [_albumDefaults setObject:_dataArray forKey:kSharedImagesKey];
  [_albumDefaults synchronize];
  
  [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (IBAction)cancelButtonPressed:(id)sender{
  
  [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

@end
