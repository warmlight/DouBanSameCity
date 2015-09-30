//
//  API.m
//  DoubanSameCity
//
//  Created by yiban on 15/4/16.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "API.h"
#import "Config.h"
#import "CityList.h"
#import "City.h"

@implementation API
+ (Account*)get_access_token:(NSString *)code{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:APIKey forKey:@"client_id"];
    [params setObject:Secret forKey:@"client_secret"];
    [params setObject:RedirectURL forKey:@"redirect_uri"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    [params setObject:code forKey:@"code"];
    NSArray *result = [HttpUtils postSync:@"https://www.douban.com/service/auth2/token" dict:params];
    return (result == nil? nil : [Account fromJsonData:result[0]]);
}

+ (Account *)update_access_token{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:APIKey forKey:@"client_id"];
    [params setObject:Secret forKey:@"client_secret"];
    [params setObject:RedirectURL forKey:@"redirect_uri"];
    [params setObject:@"refresh_token" forKey:@"grant_type"];
    [params setObject:[Config loadAccount].refresh_token forKey:@"refresh_token"];
    NSArray *result = [HttpUtils postSync:@"https://www.douban.com/service/auth2/token" dict:params];
    return (result == nil? nil : [Account fromJsonData:result[0]]);
}

+ (User *)get_user:(NSString *)id{
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/user/%@", id];
    NSArray *result = [HttpUtils getSync:url];
    return (result == nil? nil : [User fromJsonData:result[0]]);
}

+ (EventList *)get_eventlist:(NSNumber *)count star:(NSNumber *)star loc:(NSString *)loc type:(NSString *)type day_type:(NSString *)day_type{
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/event/list?loc=%@&day_type=%@&type=%@&count=%@&start=%@", loc, day_type, type, count, star];
    NSArray *result = [HttpUtils getSync:url];
    return (result == nil? nil : [EventList fromJsonData:result[0]]);
}

+ (CityList *)get_cityList:(NSNumber *)count start:(NSNumber *)start{
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/loc/list?count=%@&start=%@", count, start];
    NSArray *result = [HttpUtils getSync:url];
    return (result == nil? nil : [CityList fromJsonData:result[0]]);
}

+ (EventList *)get_wishedEvent:(NSNumber *)count start:(NSNumber *)start status:(NSString *)status{
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/event/user_wished/%@?count=%@&start=%@&status=%@",Config.getLoginUserId,count, start, status];
    NSArray *result = [HttpUtils getSync:url];
    return (result == nil? nil : [EventList fromJsonData:result[0]]);
}

+ (EventList *)get_participateEvent:(NSNumber *)count start:(NSNumber *)start status:(NSString *)status{
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/event/user_participated/%@?count=%@&start=%@&status=%@",Config.getLoginUserId,count, start, status];
    NSArray *result = [HttpUtils getSync:url];
    return (result == nil? nil : [EventList fromJsonData:result[0]]);
}

+ (ResponseCode *)wishEvent:(NSString *)eventId {
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/event/%@/wishers",eventId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[@"Bearer " stringByAppendingString:[Config loadAccount].access_token] forHTTPHeaderField:@"Authorization"];
    NSHTTPURLResponse * resp;
    NSError * error;
    NSData * retData =[NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
    if (resp.statusCode == 202) {
        ResponseCode *responseCode = [[ResponseCode alloc] init];
        responseCode.code = [NSNumber numberWithInt:202];
        return responseCode;
    }else {
       ResponseCode *code = (retData == nil? nil : [ResponseCode fromJsonData:retData]);
        NSLog(@"请求code = %@", code.code);
        return code;

    }
}

+ (ResponseCode *)participateEvent:(NSString *)eventId {
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/event/%@/participants",eventId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[@"Bearer " stringByAppendingString:[Config loadAccount].access_token] forHTTPHeaderField:@"Authorization"];
    NSHTTPURLResponse * resp;
    NSError * error;
    NSData * retData =[NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
    if (resp.statusCode == 202) {
        ResponseCode *responseCode = [[ResponseCode alloc] init];
        responseCode.code = [NSNumber numberWithInt:202];
        return responseCode;
    }else {
        return (retData == nil? nil : [ResponseCode fromJsonData:retData]);
    }
}

+ (ResponseCode *)didNotWish:(NSString *)eventId {
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/event/%@/wishers",eventId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [request setValue:[@"Bearer " stringByAppendingString:[Config loadAccount].access_token] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"DELETE"];
    NSHTTPURLResponse * resp;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:nil];
    if (resp.statusCode == 202) {
        ResponseCode *responseCode = [[ResponseCode alloc] init];
        responseCode.code = [NSNumber numberWithInt:202];
        return responseCode;
    }else {
        return (received == nil? nil : [ResponseCode fromJsonData:received]);
    }
}

+ (ResponseCode *)didNotParticipate:(NSString *)eventId {
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/event/%@/participants",eventId];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [request setValue:[@"Bearer " stringByAppendingString:[Config loadAccount].access_token] forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"DELETE"];
    NSHTTPURLResponse * resp;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:nil];
    if (resp.statusCode == 202) {
        ResponseCode *responseCode = [[ResponseCode alloc] init];
        responseCode.code = [NSNumber numberWithInt:202];
        return responseCode;
    }else {
        return (received == nil? nil : [ResponseCode fromJsonData:received]);
    }
}

+ (NSInteger)login:(NSString *)mail password:(NSString *)pasword{
    NSURL *url = [NSURL URLWithString:@"https://www.douban.com/service/auth2/auth"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod = @"POST";
    NSString *param=[NSString stringWithFormat:@"user_alias=%@&user_passwd=%@&client_id=%@&redirect_uri=%@&response_type=code",mail,pasword,APIKey,RedirectURL];
    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = postData;

    //把拼接后的字符串转换为data，设置请求体
    NSHTTPURLResponse *response;
   [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: nil];
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSLog(@"%@", response.URL);
        NSString *localurl = [[NSString alloc] initWithFormat:@"%@",response.URL];
        NSRange range = [localurl rangeOfString:@"code="];
        if (range.length) {
            NSInteger index = range.location + range.length;
            NSString *token = [localurl substringFromIndex:index];
            Account *account = [API get_access_token:token];
            User *user = [API get_user:account.douban_user_id];
            [account toString];
            [Config saveAccount:account];                   //存储account
            [Config saveUser:user];
        }
    }
    return response.statusCode;
}

+ (CityList *)getSearchCity:(NSString *)keyWords cout:(NSNumber *)count start:(NSNumber *)start{
    NSString *url = [BASE_URL stringByAppendingFormat:@"/v2/loc/search?count=%@&start=%@&apikey=%@&q=%@", count,start,APIKey,keyWords];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *result = [HttpUtils getSync:url];
    return (result == nil? nil : [CityList fromJsonData:result[0]]);
}

@end
