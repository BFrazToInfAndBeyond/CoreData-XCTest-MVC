#import "MFSearchResult.h"

@implementation MFSearchResult

- (instancetype)initWithName:(NSString *)name secondaryName:(NSString *)secondaryName image:(UIImage *)image resultId:(NSString *)resultId isFavorite:(BOOL)isFavorite{
    if (self = [super init]) {
        _name = name;
        _secondaryName = secondaryName;
        _resultId = resultId;
        _image = image;
        _isFavorite = isFavorite;
    }
    return self;
}

@end