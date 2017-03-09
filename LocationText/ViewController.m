//
//  ViewController.m
//  LocationText
//
//  Created by 张俊彬 on 16/8/15.
//  Copyright © 2016年 Jamfer. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate> {
    CLLocationManager *_locationManager;
    CLLocation* _startingLocation;
}
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *dids;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeLocationService];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //将经度显示到label上
    NSLog(@"经度：%@",[NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude]);
    //将纬度现实到label上
    NSLog(@"纬度：%@",[NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude]);
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSLog(@"看看:%@",placemark);
            //将获得的所有信息显示到label上
            NSLog(@"信息:%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    NSLog(@"longitude = %f", (newLocation.coordinate.longitude));
    NSLog(@"latitude = %f", (newLocation.coordinate.latitude));
    [manager stopUpdatingLocation];
}
- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    [_locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    [_locationManager startUpdatingLocation];
}
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    if (_startingLocation == nil) {
//        _startingLocation = (CLLocation *)[locations firstObject];
//    }
//    CLLocation *currentLocation = (CLLocation *)[locations lastObject];
//    float speed = currentLocation.speed;
//    NSLog(@"statr:%@",_startingLocation);
//    self.speedLabel.text = [NSString stringWithFormat:@"速度:%f",speed];
//    float didtance = [currentLocation distanceFromLocation:_startingLocation];
//    self.dids.text = [NSString stringWithFormat:@"didtance:%f",didtance];
//    NSLog(@"end:%@",currentLocation);
//}
@end
