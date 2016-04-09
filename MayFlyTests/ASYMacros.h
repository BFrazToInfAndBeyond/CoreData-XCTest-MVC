// From ASYTesting framework:  https://github.com/asynchrony/ASYTesting
#import <XCTest/XCTest.h>

#define ASYSignal(signal) \
[self asySignal:signal]
#define ASYWaitForSignal(signal, signalTimeout) \
if (![self asyWaitForSignal:signal timeout:signalTimeout]) { \
XCTFail(@"Timeout"); \
}
#define ASYWaitForSignalQuiet(signal, signalTimeout) \
![self asyWaitForSignal:signal timeout:signalTimeout]
