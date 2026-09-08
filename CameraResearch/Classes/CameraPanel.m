#import "CameraPanel.h"
#import "MemoryManager.h"

@implementation CameraPanel {
    UIView *_containerView;
    UISlider *_zoomSlider;
    UISwitch *_freeCameraSwitch;
    UISwitch *_fogSwitch;
    UILabel *_zoomLabel;
    MemoryManager *_memoryManager;
}

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _memoryManager = [MemoryManager sharedManager];
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = UIColor.clearColor;
        self.hidden = NO;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 220, 280)];
    _containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.88];
    _containerView.layer.cornerRadius = 14.0;
    [self addSubview:_containerView];

    CGFloat padding = 12.0;
    CGFloat width = _containerView.bounds.size.width - (padding * 2.0);
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(padding, 12, width, 28)];
    title.text = @"Camera Research Panel";
    title.textColor = UIColor.whiteColor;
    title.textAlignment = NSTextAlignmentCenter;
    [_containerView addSubview:title];

    UILabel *zoomTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding, 60, width, 20)];
    zoomTitle.text = @"Zoom";
    zoomTitle.textColor = UIColor.whiteColor;
    [_containerView addSubview:zoomTitle];

    _zoomLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 50, 60, 50, 20)];
    _zoomLabel.text = @"32.0";
    _zoomLabel.textColor = UIColor.greenColor;
    _zoomLabel.textAlignment = NSTextAlignmentRight;
    [_containerView addSubview:_zoomLabel];

    _zoomSlider = [[UISlider alloc] initWithFrame:CGRectMake(padding, 84, width - 50, 30)];
    _zoomSlider.minimumValue = 10.0;
    _zoomSlider.maximumValue = 80.0;
    _zoomSlider.value = 32.0;
    [_zoomSlider addTarget:self action:@selector(zoomChanged:) forControlEvents:UIControlEventValueChanged];
    [_containerView addSubview:_zoomSlider];

    UILabel *freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 130, 130, 28)];
    freeLabel.text = @"Free Camera";
    freeLabel.textColor = UIColor.whiteColor;
    [_containerView addSubview:freeLabel];
    _freeCameraSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 51, 128, 51, 31)];
    [_freeCameraSwitch addTarget:self action:@selector(freeCameraToggled:) forControlEvents:UIControlEventValueChanged];
    [_containerView addSubview:_freeCameraSwitch];

    UILabel *fogLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 178, 130, 28)];
    fogLabel.text = @"No Fog";
    fogLabel.textColor = UIColor.whiteColor;
    [_containerView addSubview:fogLabel];
    _fogSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 51, 176, 51, 31)];
    [_fogSwitch addTarget:self action:@selector(fogToggled:) forControlEvents:UIControlEventValueChanged];
    [_containerView addSubview:_fogSwitch];
}

- (void)zoomChanged:(UISlider *)slider {
    _zoomLabel.text = [NSString stringWithFormat:@"%.1f", slider.value];
    [_memoryManager writeFloat:slider.value atOffset:_memoryManager.offsetZoom];
}

- (void)freeCameraToggled:(UISwitch *)sender {
    [_memoryManager writeBool:sender.isOn atOffset:_memoryManager.offsetFreeCamera];
}

- (void)fogToggled:(UISwitch *)sender {
    [_memoryManager writeBool:!sender.isOn atOffset:_memoryManager.offsetFogEnable];
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

@end
