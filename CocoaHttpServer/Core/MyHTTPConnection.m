//
//  MyHTTPConnection.m
//  LocalWebServer
//
//  Created by Smallfan on 23/08/2017.
//  Copyright © 2017 Smallfan. All rights reserved.
//

#import "MyHTTPConnection.h"

@implementation MyHTTPConnection

- (BOOL)isSecureServer {
    return YES;
}

- (NSArray *)sslIdentityAndCertificates {
    
    SecIdentityRef identityRef = NULL;
    SecCertificateRef certificateRef = NULL;
    SecTrustRef trustRef = NULL;
    
    NSString *thePath = [[NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Resource"]] pathForResource:@"localhost" ofType:@"p12"];
    NSData *PKCS12Data = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)PKCS12Data;
    CFStringRef password = CFSTR("b123456");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    OSStatus securityError = errSecSuccess;
    securityError =  SecPKCS12Import(inPKCS12Data, optionsDictionary, &items);
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        identityRef = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
        trustRef = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failed with error code %d",(int)securityError);
        return nil;
    }
    
    SecIdentityCopyCertificate(identityRef, &certificateRef);
    NSArray *result = [[NSArray alloc] initWithObjects:(__bridge id)identityRef, (__bridge id)certificateRef, nil];
    
    return result;
}

@end
