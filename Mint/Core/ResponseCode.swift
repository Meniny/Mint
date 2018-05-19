//
//  Defines.swift
//  HTTPDefines
//
//  Blog  : https://meniny.cn
//  Github: https://github.com/Meniny
//
//  No more shall we pray for peace
//  Never ever ask them why
//  No more shall we stop their visions
//  Of selfdestructing genocide
//  Dogs on leads march to war
//  Go ahead end it all...
//
//  Blow up the world
//  The final silence
//  Blow up the world
//  I don't give a damn!
//
//  Screams of terror, panic spreads
//  Bombs are raining from the sky
//  Bodies burning, all is dead
//  There's no place left to hide
//  Dogs on leads march to war
//  Go ahead end it all...
//
//  Blow up the world
//  The final silence
//  Blow up the world
//  I don't give a damn!
//
//  (A voice was heard from the battle field)
//
//  "Couldn't care less for a last goodbye
//  For as I die, so do all my enemies
//  There's no tomorrow, and no more today
//  So let us all fade away..."
//
//  Upon this ball of dirt we lived
//  Darkened clouds now to dwell
//  Wasted years of man's creation
//  The final silence now can tell
//  Dogs on leads march to war
//  Go ahead end it all...
//
//  Blow up the world
//  The final silence
//  Blow up the world
//  I don't give a damn!
//
//  When I wrote this code, only I and God knew what it was.
//  Now, only God knows!
//
//  So if you're done trying 'optimize' this routine (and failed),
//  please increment the following counter
//  as a warning to the next guy:
//
//  total_hours_wasted_here = 67
//
//  Created by 李二狗 on 2018/4/9.
//  Copyright © 2018年 Mobi Magic. All rights reserved.
//

import Foundation

public extension Mint {
    
    /// Response Status Codes
    public enum ResponseCode: Int {
        case invalidURL = -1001
        case unknown = 0
        
        case `continue` = 100,
        switchingProtocols = 101
        
        case ok = 200,
        created = 201,
        accepted = 202,
        nonAuthoritativeInformation = 203,
        noContent = 204,
        resetContent = 205,
        partialContent = 206
        
        case multipleChoices = 300,
        movedPermanently = 301,
        found = 302,
        seeOther = 303,
        notModified = 304,
        useProxy = 305,
        unused = 306,
        temporaryRedirect = 307
        
        case badRequest = 400,
        unauthorized = 401,
        paymentRequired = 402,
        forbidden = 403,
        notFound = 404,
        methodNotAllowed = 405,
        notAcceptable = 406,
        proxyAuthenticationRequired = 407,
        requestTimeout = 408,
        conflict = 409,
        gone = 410,
        lengthRequired = 411,
        preconditionFailed = 412,
        requestEntityTooLarge = 413,
        requestURITooLong = 414,
        unsupportedMediaType = 415,
        requestedRangeNotSatisfiable = 416,
        expectationFailed = 417
        
        case internalServerError = 500,
        notImplemented = 501,
        badGateway = 502,
        serviceUnavailable = 503,
        gatewayTimeout = 504,
        httpVersionNotSupported = 505
        
        public init(statusCode: Int) {
            self = ResponseCode.init(rawValue: statusCode) ?? ResponseCode.unknown
        }
        
        public var statusDescription: String {
            switch self {
            case .continue:
                return "Continue"
            case .switchingProtocols:
                return "Switching protocols"
            case .ok:
                return "OK"
            case .created:
                return "Created"
            case .accepted:
                return "Accepted"
            case .nonAuthoritativeInformation:
                return "Non authoritative information"
            case .noContent:
                return "No content"
            case .resetContent:
                return "Reset content"
            case .partialContent:
                return "Partial Content"
            case .multipleChoices:
                return "Multiple choices"
            case .movedPermanently:
                return "Moved Permanently"
            case .found:
                return "Found"
            case .seeOther:
                return "See other URI"
            case .notModified:
                return "Not modified"
            case .useProxy:
                return "Use proxy"
            case .unused:
                return "Unused"
            case .temporaryRedirect:
                return "Temporary redirect"
            case .badRequest:
                return "Bad request"
            case .unauthorized:
                return "Access denied"
            case .paymentRequired:
                return "Payment required"
            case .forbidden:
                return "Forbidden"
            case .notFound:
                return "Page not found"
            case .methodNotAllowed:
                return "Method not allowed"
            case .notAcceptable:
                return "Not acceptable"
            case .proxyAuthenticationRequired:
                return "Proxy authentication required"
            case .requestTimeout:
                return "Request timeout"
            case .conflict:
                return "Conflict request"
            case .gone:
                return "Page is gone"
            case .lengthRequired:
                return "Lack content length"
            case .preconditionFailed:
                return "Precondition failed"
            case .requestEntityTooLarge:
                return "Request entity is too large"
            case .requestURITooLong:
                return "Request URI is too long"
            case .unsupportedMediaType:
                return "Unsupported media type"
            case .requestedRangeNotSatisfiable:
                return "Request range is not satisfiable"
            case .expectationFailed:
                return "Expected request is failed"
            case .internalServerError:
                return "Internal server error"
            case .notImplemented:
                return "Server does not implement a feature for request"
            case .badGateway:
                return "Bad gateway"
            case .serviceUnavailable:
                return "Service unavailable"
            case .gatewayTimeout:
                return "Gateway timeout"
            case .httpVersionNotSupported:
                return "Http version not supported"
            case .invalidURL:
                return "Invalid URL"
            default:
                return "Unknown status code"
            }
        }
    }
}
