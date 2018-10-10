#import <XCTest/XCTest.h>
#import <Specta/Specta.h>

#import "SpectaUtility.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000 || __MAC_OS_X_VERSION_MAX_ALLOWED >= 101100

@interface XCTestObservationCenter (SPTTestSuspention)

- (void)_suspendObservationForBlock:(void (^)(void))block;

@end

#else

@interface XCTestObservationCenter

+ (id)sharedObservationCenter;
- (void)_suspendObservationForBlock:(void (^)(void))block;

@end

#endif

#define RunSpec(TestClass) RunSpecClass([TestClass class])

XCTestRun *RunSpecClass(Class testClass);

#define assertTrue(expression)        assertWithCurrentSpec(XCTAssertTrue((expression), @""))
#define assertFalse(expression)       assertWithCurrentSpec(XCTAssertFalse((expression), @""))
#define assertNil(a1)                 assertWithCurrentSpec(XCTAssertNil((a1), @""))
#define assertNotNil(a1)              assertWithCurrentSpec(XCTAssertNotNil((a1), @""))
#define assertEqual(a1, a2)           assertWithCurrentSpec(XCTAssertEqual((a1), (a2), @""))
#define assertEqualObjects(a1, a2)    assertWithCurrentSpec(XCTAssertEqualObjects((a1), (a2), @""))
#define assertNotEqual(a1, a2)        assertWithCurrentSpec(XCTAssertNotEqual((a1), (a2), @""))
#define assertNotEqualObjects(a1, a2) assertWithCurrentSpec(XCTAssertNotEqualObjects((a1), (a2), @""))
#define assertWithCurrentSpec(...) do { SPTSpec *self = SPTCurrentSpec; __VA_ARGS__; } while (0)
