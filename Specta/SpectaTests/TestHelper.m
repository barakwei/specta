#import "TestHelper.h"

@interface XCTestObservationCenter (Redeclaration)
- (id)observers;
- (void)removeTestObserver:(id<XCTestObservation>)testObserver;
@end

@implementation XCTestObservationCenter (Suspension)

- (void)spt_suspendObservationForBlock:(void (^)(void))block {
  id originalObservers = [[self observers] copy];
  NSMutableArray *suspendedObservers = [NSMutableArray new];

  for (id observer in originalObservers) {
    [suspendedObservers addObject:observer];

    if ([self respondsToSelector:@selector(removeTestObserver:)]) {
      [self removeTestObserver:observer];
    }
    else if ([[self observers] respondsToSelector:@selector(removeObject:)]) {
      [[self observers] removeObject:observer];
    }
    else {
      NSAssert(NO, @"unexpected type: unable to remove observers: %@", originalObservers);
    }
  }

  @try {
    block();
  }
  @finally {
    for (id observer in suspendedObservers) {
      if ([[self observers] respondsToSelector:@selector(addObject:)]) {
        [[self observers] addObject:observer];
      }
      else if ([self respondsToSelector:@selector(addTestObserver:)]) {
        [self addTestObserver:observer];
      }
    }
  }
}

@end

XCTestRun *RunSpecClass(Class testClass) {
  __block XCTestRun *result;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000 || __MAC_OS_X_VERSION_MAX_ALLOWED >= 101100
  XCTestObservationCenter *observationCenter = [XCTestObservationCenter sharedTestObservationCenter];
#else
  XCTestObservationCenter *observationCenter = [XCTestObservationCenter sharedObservationCenter];
#endif
  [observationCenter spt_suspendObservationForBlock:^{
    XCTestSuite *testSuite = [XCTestSuite testSuiteForTestCaseClass:testClass];
    [testSuite runTest];
    result = testSuite.testRun;
  }];

  return result;
}
