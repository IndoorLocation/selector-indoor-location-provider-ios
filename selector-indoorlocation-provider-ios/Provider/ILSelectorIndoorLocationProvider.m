#import "ILSelectorIndoorLocationProvider.h"

@implementation ILSelectorIndoorLocationProvider {
    
    NSMutableArray<ILIndoorLocationProvider*>* indoorLocationProviderList;
    NSMutableDictionary<NSString*, ILIndoorLocation*>* indoorLocationByProvider;
    double indoorLocationValidity;
    BOOL started;
}

- (instancetype)initWithValidity:(double) validity {
    self = [super init];
    if (self) {
        indoorLocationValidity = validity;
        started = NO;
        indoorLocationProviderList = [[NSMutableArray alloc] init];
        indoorLocationByProvider = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) addIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider {
    [indoorLocationProviderList addObject:indoorLocationProvider];
    [indoorLocationProvider addDelegate:self];
    if (started) {
        [indoorLocationProvider start];
    }
}

- (void) removeIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider {
    [indoorLocationProviderList removeObject:indoorLocationProvider];
    [indoorLocationProvider stop];
}

- (BOOL) supportsFloor {
    for (ILIndoorLocationProvider* provider in indoorLocationProviderList) {
        if ([provider supportsFloor]) {
            return YES;
        }
    }
    return NO;
}

- (void) start {
    for (ILIndoorLocationProvider* provider in indoorLocationProviderList) {
        [provider start];
    }
}

- (void) stop {
    for (ILIndoorLocationProvider* provider in indoorLocationProviderList) {
        [provider stop];
    }
    started = NO;
}

- (ILIndoorLocation*) selectIndoorLocation:(NSArray<ILIndoorLocation*>*) indoorLocations {
    
    NSMutableArray<ILIndoorLocation*>* validIndoorLocations = [[NSMutableArray alloc] init];
    for (ILIndoorLocation* indoorLocation in indoorLocations) {
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:indoorLocation.timestamp];
        if (secondsBetween*1000 < indoorLocationValidity) {
            [validIndoorLocations addObject:indoorLocation];
        }
    }
    
    NSMutableArray<ILIndoorLocation*>* withFloorIndoorLocations = [[NSMutableArray alloc] init];
    NSMutableArray<ILIndoorLocation*>* withoutFloorIndoorLocations = [[NSMutableArray alloc] init];
    for (ILIndoorLocation* indoorLocation in validIndoorLocations) {
        if (indoorLocation.floor) {
            [withFloorIndoorLocations addObject:indoorLocation];
        }
        else {
            [withoutFloorIndoorLocations addObject:indoorLocation];
        }
    }
    
    if (withFloorIndoorLocations.count > 0) {
        [withFloorIndoorLocations sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ILIndoorLocation* first = (ILIndoorLocation*) obj1;
            ILIndoorLocation* second = (ILIndoorLocation*) obj2;
            return second.accuracy - first.accuracy;
        }];
        return withFloorIndoorLocations[0];
    }
    
    if (withoutFloorIndoorLocations.count > 0) {
        [withoutFloorIndoorLocations sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ILIndoorLocation* first = (ILIndoorLocation*) obj1;
            ILIndoorLocation* second = (ILIndoorLocation*) obj2;
            return second.accuracy - first.accuracy;
        }];
        return withoutFloorIndoorLocations[0];
    }
    
    return nil;
}

#pragma mark ILIndoorLocationProviderDelegate

- (void)provider:(ILIndoorLocationProvider *)provider didFailWithError:(NSError *)error {
    [self dispatchDidFailWithError:error];
}

- (void)provider:(ILIndoorLocationProvider *)provider didUpdateLocation:(ILIndoorLocation *)location {
    indoorLocationByProvider[[provider getName]] = location;
    ILIndoorLocation* selectedLocation = [self selectIndoorLocation:[indoorLocationByProvider allValues]];
    if (selectedLocation) {
        [self dispatchDidUpdateLocation:selectedLocation];
    }
}

- (void)providerDidStart:(ILIndoorLocationProvider *)provider {
    if (!started) {
        [self dispatchDidStart];
    }
    started = YES;
}

- (void)providerDidStop:(ILIndoorLocationProvider *)provider {
    BOOL allAreStop = YES;
    for (ILIndoorLocationProvider* provider in indoorLocationProviderList) {
        if ([provider isStarted]) {
            allAreStop = NO;
        }
    }
    if (allAreStop) {
        [self dispatchDidStop];
    }
}

@end
