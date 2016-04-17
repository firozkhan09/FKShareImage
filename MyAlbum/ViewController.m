//
//  ViewController.m
//  MyAlbum
//
//  Created by Firoz Khan on 12/04/16.
//  Copyright (c) 2016 Firoz Khan. All rights reserved.
//

#import "ViewController.h"

static NSString *const kSharedImagesKey = @"sharedImages";

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (copy, nonatomic) NSMutableArray *albumImagesArray;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  _albumImagesArray  = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"myAlbum"]];
  [self getSharedImages];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Functional Methods

-(void)getSharedImages
{
  NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.MyAlbum.com"];
  NSArray *sharedImages = [defaults arrayForKey:kSharedImagesKey];
  for (NSData *imageData in sharedImages) {
    [_albumImagesArray addObject:imageData];
  }
  
  [defaults removeObjectForKey:kSharedImagesKey];
  [[NSUserDefaults standardUserDefaults] setObject:_albumImagesArray forKey:@"myAlbum"];
  [_albumCollectionView reloadData];
}

#pragma mark - CollectionView DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return [_albumImagesArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  UICollectionViewCell *albumCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
  UIImageView *cellImageView = (UIImageView *)[albumCell viewWithTag:100];
  cellImageView.image = [UIImage imageWithData:_albumImagesArray[indexPath.row]];
  return albumCell;
}
@end
