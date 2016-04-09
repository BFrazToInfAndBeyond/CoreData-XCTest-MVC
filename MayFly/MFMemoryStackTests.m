#import "MFMemoryStack.h"

@interface MFMemoryStackTests : XCTestCase
{
    MFMemoryStack *testObject;
}

@end

@implementation MFMemoryStackTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    testObject = nil;
    [super tearDown];
}

- (void)test_whenCallPushMemoryStack_thenAddObject
{
    testObject = [[MFMemoryStack alloc] init];
    NSArray *expected = @[@"anElement", @"anElement"];
    XCTAssertEqualObjects(@(testObject.memoryStack.count), @0);
    [testObject pushMemoryStack:expected];
    XCTAssertEqualObjects(@(testObject.memoryStack.count), @1);
    XCTAssertEqualObjects([testObject.memoryStack objectAtIndex:0], expected);
}


- (void)test_whenCallPushMemoryStackANDCountIsGreaterThanMaxSize_thenBehaveAsExpected
{
    testObject = [[MFMemoryStack alloc] init];
    
    NSArray *firstElementSoonToBeRemoved = @[@"firstElementToBeReplacedA", @"firstElementToBeReplacedB"];
    [testObject pushMemoryStack:firstElementSoonToBeRemoved];
    NSArray *expectedFirstElement = @[@"expectedFirstElementA", @"expectedFirstElementB"];
    NSArray *expectedSecondElement = @[@"expectedSecondElementA", @"expectedSecondElementB"];
    NSArray *expectedTopElement = @[@"expectedTopElementA", @"expectedTopElementB"];
    [testObject pushMemoryStack:expectedFirstElement];
    [testObject pushMemoryStack:expectedSecondElement];
    [testObject pushMemoryStack:@[]];
    [testObject pushMemoryStack:@[]];
    [testObject pushMemoryStack:@[]];
    [testObject pushMemoryStack:@[]];
    [testObject pushMemoryStack:expectedTopElement];
    
    XCTAssertEqualObjects(@(testObject.memoryStack.count), @7);
    XCTAssertEqualObjects(testObject.memoryStack[0], expectedFirstElement);
    XCTAssertEqualObjects(testObject.memoryStack[1], expectedSecondElement);
    XCTAssertEqualObjects(testObject.memoryStack[6], expectedTopElement);
}

- (void)test_whenCallClearMemoryStack_thenExpectANewlyInitializedStack
{
    testObject = [[MFMemoryStack alloc] init];
    [testObject pushMemoryStack:@[@"someElement"]];
    XCTAssertEqualObjects(@(testObject.memoryStack.count), @1);
    [testObject clearMemoryStack];
    XCTAssertEqualObjects(@(testObject.memoryStack.count), @0);
}

- (void)test_whenCallClearANDPushMemoryStack_thenPerformAsExpected
{
    testObject = [[MFMemoryStack alloc] init];
    [testObject pushMemoryStack:@[@"someElement1"]];
    [testObject pushMemoryStack:@[@"someOtherElement"]];
    NSArray *expectedFirstElement = @[@"firstElement"];
    [testObject clearAndPushMemoryStack:expectedFirstElement];
    XCTAssertEqualObjects(@(testObject.memoryStack.count), @1);
    XCTAssertEqualObjects(testObject.memoryStack[0], expectedFirstElement);
}

- (void)test_whenPopMemoryStackIsNil_thenReturnNil
{
    testObject = nil;
    NSArray *actual = [testObject popMemoryStack];
    XCTAssertNil(actual);
}

- (void)test_whenPopMemoryStackANDCountIsOne_thenReturnNil
{
    testObject = [[MFMemoryStack alloc] init];
    [testObject pushMemoryStack:@[@"someElement"]];
    NSArray *actual = [testObject popMemoryStack];
    XCTAssertNil(actual);
}

- (void)test_whenPopStack_thenPerformAsExpected
{
    testObject = [[MFMemoryStack alloc] init];
    NSArray *expectedElement = @[@"expected"];
    [testObject pushMemoryStack:expectedElement];
    [testObject pushMemoryStack:@[@"anotherElement"]];
    NSArray *actualElement = [testObject popMemoryStack];
    XCTAssertEqualObjects(@(testObject.memoryStack.count), @1);
    XCTAssertEqualObjects(testObject.memoryStack[0], expectedElement);
    XCTAssertEqualObjects(actualElement, expectedElement);
}

- (void)test_whenLastObjectCalled_thenItReturnsAsExpected
{
    NSArray *expected = @[@"lastElement"];
    testObject = [[MFMemoryStack alloc] init];
    [testObject pushMemoryStack:@[]];
    [testObject pushMemoryStack:expected];
    XCTAssertEqualObjects([testObject lastObject], expected);
    XCTAssertTrue(testObject.memoryStack.count == 2);
    expected = @[@"otherElement"];
    [testObject pushMemoryStack:@[]];
    [testObject pushMemoryStack:@[]];
    [testObject pushMemoryStack:expected];
    XCTAssertEqualObjects([testObject lastObject], expected);
    XCTAssertTrue(testObject.memoryStack.count == 5);
}

- (void)test_whenCountRequested_thenItReturnsAsExpected
{
    testObject = [[MFMemoryStack alloc] init];
    [testObject pushMemoryStack:@[]];
    [testObject pushMemoryStack:@[]];
    XCTAssertTrue([testObject memoryStackCount] == 2);
    [testObject pushMemoryStack:@[]];
    XCTAssertTrue([testObject memoryStackCount] == 3);
}
@end