//
//  LCAddressMapViewController.m
//  weChat
//
//  Created by Lc on 16/4/19.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCAddressMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LCAnnotation.h"

#define mapViewY 64
#define maxMapViewH 400
#define minMapViewH 250
#define tableViewH self.view.height - minMapViewH - mapViewY
#define tableViewY maxMapViewH + mapViewY
#define tableViewW self.view.width

@interface LCAddressMapViewController ()<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) MKMapView *mapView;
@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *locationName;
@end

@implementation LCAddressMapViewController
static NSString * const reverseGeocodeCellId  = @"reverseGeocodeCellId";
static NSString * const LCAnnotationCellID = @"LCAnnotationCellID";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupMapView];
    
    [self setupTableView];
  
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    
    return _geocoder;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        
        // [CLLocationManager locationServicesEnabled] 经测试,在iOS9中无需判断
        // 需要在Info.plist中设置NSLocationAlwaysUsageDescription的值
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请前往隐私 -> 定位服务 ->允许当前app使用定位" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            });
        }
        
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        CLLocationDistance distance = 10.0;
        _locationManager.distanceFilter = distance;
        [_locationManager startUpdatingLocation];
    }
    
    return _locationManager;
}

- (void)setupNav
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickReturnBtn)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(clickSenderBtn)];
    self.navigationItem.title = @"位置";
    
}

- (void)setupMapView
{
    [self locationManager];
    
    MKMapView *view = [[MKMapView alloc] init];
    view.frame = CGRectMake(0, mapViewY, tableViewW, maxMapViewH);
   
    view.userTrackingMode = MKUserTrackingModeFollow;
    view.mapType = MKMapTypeStandard;
    view.delegate = self;
    
    [self.view addSubview:view];
    self.mapView = view;
    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.frame = CGRectMake(0, tableViewY, tableViewW, tableViewH);
    tableView.delegate = self;
    tableView.dataSource = self;
   
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reverseGeocodeCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reverseGeocodeCellId];
    }
    MKMapItem *mapItem = self.dataSource[indexPath.row];
    
    cell.textLabel.text = mapItem.name;
    cell.detailTextLabel.text = mapItem.placemark.addressDictionary[@"Street"];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat mapViewH = maxMapViewH;
    CGFloat translateY = 0;
    
    if (offsetY > 0) {
        mapViewH = minMapViewH;
        translateY = maxMapViewH - minMapViewH;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.tableView.frame = CGRectMake(0, tableViewY - translateY, tableViewW, tableViewH);
        self.mapView.height = mapViewH;
    }];
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = [locations firstObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.locationName = placemark.addressDictionary[@"FormattedAddressLines"][0];
    }];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 10, 10);
    MKLocalSearchRequest *requst = [[MKLocalSearchRequest alloc] init];
    requst.region = region;
    requst.naturalLanguageQuery = @"park";
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:requst];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:response.mapItems];
        [self.tableView reloadData];
        if (!error)
        {
            for (MKMapItem *mapItem in response.mapItems) {
                LCAnnotation * annotation = [[LCAnnotation alloc] init];
                annotation.coordinate = mapItem.placemark.location.coordinate;
                annotation.title = mapItem.name;
                annotation.subtitle = mapItem.placemark.addressDictionary[@"Street"];
                annotation.image = [UIImage imageNamed:@"pin_green"];
                [self.mapView addAnnotation:annotation];
            }
        }
    }];
}
#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[LCAnnotation class]]) {
        
        MKAnnotationView *annotationView=[_mapView dequeueReusableAnnotationViewWithIdentifier:LCAnnotationCellID];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:LCAnnotationCellID];
            annotationView.canShowCallout = true;
            annotationView.calloutOffset = CGPointMake(0, 1);
            annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aio_icons_red_pack"]];
        }

        annotationView.annotation = annotation;
        annotationView.image = ((LCAnnotation *)annotation).image;
        
        return annotationView;
    }else { // 返回系统的大头针
        return nil;
    }
}

#pragma mark - action
- (void)clickReturnBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSenderBtn
{
    MKMapSnapshotOptions *option = [[MKMapSnapshotOptions alloc] init];
    option.region = self.mapView.region;
    option.showsPointsOfInterest = YES;
    MKMapSnapshotter *snape = [[MKMapSnapshotter alloc] initWithOptions:option];
    [snape startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        
        if ([self.delegate respondsToSelector:@selector(addressMapViewController:didClickSenderWithMapView:locationName:)]) {
            [self.delegate addressMapViewController:self didClickSenderWithMapView:snapshot.image locationName:self.locationName];
        }
    }];
}

@end
