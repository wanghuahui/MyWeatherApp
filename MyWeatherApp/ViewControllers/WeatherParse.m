//
//  WeatherParse.m
//  NMBottomTabBarControllerExample
//
//  Created by Adele on 7/22/15.
//  Copyright (c) 2015 Prianka Liz. All rights reserved.
//

#import "WeatherParse.h"

@interface WeatherParse () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableString *zhishuString;

@end

@implementation WeatherParse
{
    BOOL _bBasic;
    BOOL _bEnvir;
    BOOL _bAlarm;
    BOOL _bForecast;
    BOOL _bZhishu;
}

+ (id)sharedInstance {
    static WeatherParse *weatherInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weatherInstance = [[self alloc] init];
    });
    return weatherInstance;
}

- (void)parseWeatherURL:(NSString *)weatherURL {
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:weatherURL]];
    [parser setDelegate:self];
    [parser parse];
}

#pragma mark - NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"resp"]) {
        _bBasic = NO;
        _bEnvir = NO;
        _bAlarm = NO;
        _bForecast = NO;
        
        self.basicArray = [[NSMutableArray alloc] init];
        self.envirArray = [[NSMutableArray alloc] init];
        self.forecastArray = [NSMutableArray array];
        self.zhishuArray = [NSMutableArray array];
        self.zhishuString = [NSMutableString string];
    }
    else if ([elementName isEqualToString:@"updatetime"]) {
        _bBasic = YES;
    }
    else if ([elementName isEqualToString:@"environment"]) {
        _bEnvir = YES;
        
    }
    else if ([elementName isEqualToString:@"yesterday"]) {
        _bForecast = YES;
    }
    else if ([elementName isEqualToString:@"zhishu"]) {
        _bZhishu = YES;
        [self.zhishuString setString:@""];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"sunset_1"]) {
        _bBasic = NO;
    }
    else if ([elementName isEqualToString:@"environment"]) {
        _bEnvir = NO;
    }
    else if ([elementName isEqualToString:@"forecast"]) {
        _bForecast = NO;
    }
    else if ([elementName isEqualToString:@"zhishu"]) {
        NSString *str = [NSString stringWithString:_zhishuString];
        [self.zhishuArray addObject:str];
    }
    if ([elementName isEqualToString:@"zhishus"]) {
        _bZhishu = NO;
        self.zhishuString = [NSMutableString string];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (_bBasic) {
        if ([string isEqualToString:@"级"]) {
            return;
        }
        [self.basicArray addObject:string];
    }
    if (_bEnvir) {
        [self.envirArray addObject:string];
    }
    if (_bForecast) {
        [self.forecastArray addObject:string];
    }
    if (_bZhishu) {
        [self.zhishuString appendString:string];
        [self.zhishuString appendString:@"|"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
//    NSString *alarm = [NSString stringWithUTF8String:[CDATABlock bytes]];
}

@end
