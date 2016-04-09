@interface MFSearchResult : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *secondaryName;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic) BOOL isFavorite;

@property (nonatomic, readonly) NSString *resultId;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithName:(NSString *)name secondaryName:(NSString *)secondaryName image:(UIImage *)image resultId:(NSString *)resultId isFavorite:(BOOL)isFavorite;


@end