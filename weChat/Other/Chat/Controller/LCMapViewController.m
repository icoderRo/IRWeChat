//
//  LCMapViewController.m
//  weChat
//
//  Created by Lc on 16/4/28.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "LCMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LCAnnotation.h"

#define mapViewY 64

@interface LCMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@end

@implementation LCMapViewController
static NSString * const LCAnnotationCellID = @"LCAnnotationCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self setupMapView];
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
    self.navigationItem.title = @"位置";
    
}

- (void)setupMapView
{
    [self locationManager];
    
    MKMapView *view = [[MKMapView alloc] init];
    view.frame = CGRectMake(0, mapViewY, self.view.width, self.view.height);
    
    view.userTrackingMode = MKUserTrackingModeFollow;
    view.mapType = MKMapTypeStandard;
    view.delegate = self;
    
    [self.view addSubview:view];
    self.mapView = view;
    
}

#pragma mark - MKMapViewDelegate

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

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.009, 0.009);
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, span);
    [self.mapView setRegion:region animated:true];
    
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
         userLocation.title = placemark.addressDictionary[@"FormattedAddressLines"][0];
    }];
}
@end
