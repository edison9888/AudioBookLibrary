//
//  HTTPConnection.h
//  AudioBookLibrary
//

@protocol HTTPConnectionDelegate;


@interface HTTPConnection : NSObject
{
    NSString*           requestURL;
	NSURLConnection*    connection;
	NSMutableData*      buf;
    int                 statusCode;
    BOOL                needAuth;
}

@property (nonatomic, readonly) NSMutableData* buf;
@property (nonatomic, assign) int statusCode;
@property (nonatomic, copy) NSString* requestURL;
@property (nonatomic, retain) id<HTTPConnectionDelegate> delegate;

- (void)get:(NSString*)URL;
- (void)post:(NSString*)aURL body:(NSString*)body;
- (void)post:(NSString*)aURL data:(NSData*)data;
- (void)cancel;

// Subclasses override this for either BASIC or OAUTH 
- (void)addAuthHeader:(NSMutableURLRequest*)req;
+ (BOOL)isNetworkDataSourceAvailable:(NSString*)host;

@end


@protocol HTTPConnectionDelegate<NSObject>
- (void)HTTPConnectionDidFailWithError:(NSError*)error;
- (void)HTTPConnectionDidFinishLoading:(NSString*)content;
@end
