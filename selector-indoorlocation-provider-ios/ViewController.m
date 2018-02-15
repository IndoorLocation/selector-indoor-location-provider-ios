#import "ViewController.h"
#import "ILGPSIndoorLocationProvider.h"
#import "ILManualIndoorLocationProvider.h"
#import "ILSelectorIndoorLocationProvider.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    MapwizePlugin* mapwizePlugin;
    ILGPSIndoorLocationProvider* gpsProvider;
    ILManualIndoorLocationProvider* manualProvider;
    ILSelectorIndoorLocationProvider* selectorProvider;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapwizePlugin = [[MapwizePlugin alloc] initWith:_mglMapView options:[[MWZOptions alloc] init]];
    mapwizePlugin.delegate = self;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) mapwizePluginDidLoad:(MapwizePlugin *)mapwizePlugin {
    
    gpsProvider = [[ILGPSIndoorLocationProvider alloc] init];
    manualProvider = [[ILManualIndoorLocationProvider alloc] init];
    selectorProvider = [[ILSelectorIndoorLocationProvider alloc] initWithValidity:5000];
    [selectorProvider addIndoorLocationProvider:gpsProvider];
    [selectorProvider addIndoorLocationProvider:manualProvider];
    
    [mapwizePlugin setIndoorLocationProvider:selectorProvider];
    
}

- (void) plugin:(MapwizePlugin *)plugin didTapOnMap:(MWZLatLngFloor *)latLngFloor {
    
    NSLog(@"Did tap on map");
    ILIndoorLocation* location = [[ILIndoorLocation alloc] initWithProvider: manualProvider latitude: latLngFloor.coordinates.latitude longitude:latLngFloor.coordinates.longitude floor:latLngFloor.floor];
    [manualProvider setIndoorLocation:location];
    
}

@end
