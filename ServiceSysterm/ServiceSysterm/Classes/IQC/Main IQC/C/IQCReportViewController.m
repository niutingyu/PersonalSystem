//
//  IQCReportViewController.m
//  ServiceSysterm
//
//  Created by Andy on 2024/3/8.
//  Copyright © 2024 SLPCB. All rights reserved.
//

#import "IQCReportViewController.h"
#import <WebKit/WebKit.h>
#import "IQCFileModel.h"
@interface IQCReportViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong) UIProgressView *progressView;



@property (nonatomic,strong)WKWebView *webView;

@end

@implementation IQCReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"检验报告";
   // [self.webView loadRequest:self.urlRequest];
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSString *str1 = [self.httpPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str1]]];
    
   // [self getFilePath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
 
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
   
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
  
    [self.view bringSubviewToFront:self.progressView];
}
 
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
 
    self.webView.hidden  =NO;
   
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
}
 
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
   
    [Units showErrorStatusWithString:@"加载失败!!!"];
    self.webView.hidden  =YES;
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        //[webView loadRequest:navigationAction.request];
 //     NSURL *url=  navigationAction.request.URL;
//        SFSafariViewController *sfController  =[[SFSafariViewController alloc]initWithURL:url];
//        [self presentViewController:sfController animated:YES completion:nil];
        
       
        
        
    }
    return nil;
}

-(WKWebView*)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.UIDelegate  =self;
        _webView.navigationDelegate  =self;
        
        _webView.backgroundColor  =RGBA(242, 242, 242, 1);
        _webView.frame  = CGRectMake(0, 80, kScreenWidth, kScreenHeight);
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        _webView.autoresizesSubviews  =YES;
        _webView.allowsBackForwardNavigationGestures =true;
        _webView.multipleTouchEnabled  =YES;

    }
    return _webView;
}



-(UIProgressView*)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.backgroundColor = [UIColor whiteColor];
            //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:_progressView];
        [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.mas_offset(0);
            make.height.mas_equalTo(1.5);
        }];
    }
    return _progressView;
}


-(void)getFilePath{
    NSString *url =@"http://192.168.15.26:8001/mk/file/getUpLoadFileByfItemID";
    NSMutableDictionary *parms =[NSMutableDictionary dictionary];
    [parms setObject:self.httpPath forKey:@"fItemID"];
    [parms setObject:@"161" forKey:@"type"];
    KWeakSelf
    [HttpTool POST:url param:parms success:^(id  _Nonnull responseObject) {
        if([[responseObject objectForKey:@"status"]intValue]==0){
            NSArray *jsonArray = [Units jsonToArray:responseObject[@"data"]];
            NSMutableArray *modelArray =[IQCFileModel mj_objectArrayWithKeyValuesArray:jsonArray];
            if (modelArray.count >0) {
                IQCFileModel *model = modelArray.firstObject;
                NSString *str1 = [model.FilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str1]]];
                
            }
        }
        debugLog(@"res %@",responseObject);
    } error:^(NSString * _Nonnull error) {
        
    }];
}
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
