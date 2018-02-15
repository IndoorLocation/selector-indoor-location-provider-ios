#import <IndoorLocation/IndoorLocation.h>

@interface ILSelectorIndoorLocationProvider : ILIndoorLocationProvider <ILIndoorLocationProviderDelegate>

- (instancetype)initWithValidity:(double) validity;

- (void) addIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider;

- (void) removeIndoorLocationProvider:(ILIndoorLocationProvider*) indoorLocationProvider;

@end
