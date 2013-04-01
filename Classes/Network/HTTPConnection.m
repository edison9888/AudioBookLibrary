//
//  HTTPConnection.m
//  AudioBookLibrary
//

#import <SystemConfiguration/SCNetworkReachability.h>

#import "HTTPConnection.h"
#import "NSStringAdditions.h"

#define NETWORK_TIMEOUT 120.0

@implementation HTTPConnection

@synthesize buf;
@synthesize statusCode;
@synthesize requestURL;
@synthesize delegate;

NSString *APP_FORM_BOUNDARY = @"0194784892923";

- (void)dealloc
{
    [requestURL release];
	[connection release];
	[buf release];
	[super dealloc];
}

- (void)addAuthHeader:(NSMutableURLRequest*)req
{
    if (!needAuth) return;
    
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
	NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    
    NSString* auth = [NSString stringWithFormat:@"%@:%@", username, password];
    NSString* basicauth = [NSString stringWithFormat:@"Basic %@", [NSString base64encode:auth]];
    [req setValue:basicauth forHTTPHeaderField:@"Authorization"];
}

- (void)get:(NSString*)aURL
{
    [connection release];
	[buf release];
    statusCode = 0;
    
    self.requestURL = aURL;
    
    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    [URL autorelease];
    NSLog(@"%@", URL);
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                  timeoutInterval:NETWORK_TIMEOUT];

    [self addAuthHeader:req];
    
  	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)post:(NSString*)aURL body:(NSString*)body
{
    [connection release];
	[buf release];
    statusCode = 0;
    
    self.requestURL = aURL;
    
    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    NSLog(@"%@", URL);    
	[URL autorelease];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:NETWORK_TIMEOUT];
    
    
    [req setHTTPMethod:@"POST"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [self addAuthHeader:req];
    
    int contentLength = [body lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    [req setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:[NSData dataWithBytes:[body UTF8String] length:contentLength]];
    
	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)post:(NSString*)aURL data:(NSData*)data
{
    [connection release];
	[buf release];
    statusCode = 0;

    self.requestURL = aURL;

    NSString *URL = (NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)aURL, (CFStringRef)@"%", NULL, kCFStringEncodingUTF8);
    [URL autorelease];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                   timeoutInterval:NETWORK_TIMEOUT];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", APP_FORM_BOUNDARY];
    [req setHTTPMethod:@"POST"];
    [req setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    [req setHTTPBody:data];
    [self addAuthHeader:req];
    
	buf = [[NSMutableData data] retain];
	connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)cancel
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;    
    if (connection) {
        [connection cancel];
        [connection autorelease];
        connection = nil;
    }
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
    NSHTTPURLResponse *resp = (NSHTTPURLResponse*)aResponse;
    if (resp) {
        statusCode = resp.statusCode;
        // NSLog(@"Response: %d", statusCode);
    }
	[buf setLength:0];
}

- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data
{
	[buf appendData:data];
}

- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	[connection autorelease];
	connection = nil;
	[buf autorelease];
	buf = nil;
    
    NSString* msg = [NSString stringWithFormat:@"Error: %@ %@",
                     [error localizedDescription],
                     [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    
    NSLog(@"Connection failed: %@", msg);
    
    [delegate HTTPConnectionDidFailWithError:error];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)aConn
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString* s = [[[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding] autorelease];
    
    [delegate HTTPConnectionDidFinishLoading:s];

    [connection autorelease];
    connection = nil;
    [buf autorelease];
    buf = nil;
}


+ (BOOL)isNetworkDataSourceAvailable:(NSString*)host  
{  		
	const char *host_name = [host cStringUsingEncoding:NSASCIIStringEncoding];  
		
	SCNetworkReachabilityRef reachability =  
	SCNetworkReachabilityCreateWithName(NULL, host_name);  
	SCNetworkReachabilityFlags flags;  
	BOOL success = SCNetworkReachabilityGetFlags(reachability, &flags);  
	CFRelease(reachability);
	BOOL isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
		
    return isDataSourceAvailable;  
}  

@end
