//
//  CameraPanel.m
//  CameraResearch
//

#import "CameraPanel.h"
#import "MemoryManager.h"

@implementation CameraPanel {
    UIView *_containerView;
    UISlider *_zoomSlider;
    UISwitch *_freeCameraSwitch;
    UISwitch *_fogSwitch;
    UIButton *_resetButton;
    UILabel *_zoomLabel;
    UILabel *_statusLabel;
    
    MemoryManager *_memoryManager;
}

- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        _memoryManager = [MemoryManager sharedManager];
        [self setupWindow];
        [self setupUI];
        [self setupGestures];
        [self updateStatus];
    }
    return self;
}

- (void)setupWindow {
    self.windowLevel = UIWindowLevelStatusBar + 1;
    self.backgroundColor = [UIColor clearColor];
    self.hidden = NO;
    self.userInteractionEnabled = YES;
}

- (void)setupUI {
    // Container
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, 230, 330)];
    _containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.88];
    _containerView.accessibilityIdentifier = @"CameraPanelContainer";
    _containerView.layer.cornerRadius = 14;
    _containerView.layer.borderColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.8].CGColor;
    _containerView.layer.borderWidth = 1.5;
    _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _containerView.layer.shadowOpacity = 0.5;
    _containerView.layer.shadowOffset = CGSizeMake(0, 2);
    _containerView.layer.shadowRadius = 8;
    [self addSubview:_containerView];
    
    CGFloat y = 12;
    CGFloat padding = 12;
    CGFloat width = _containerView.frame.size.width - padding * 2;
    
    // Title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, width, 28)];
    title.text = @"🔬 Camera Research Panel";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:15];
    title.textAlignment = NSTextAlignmentCenter;
    [_containerView addSubview:title];
    
    // Divider
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(padding, y + 32, width, 1)];
    divider.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    [_containerView addSubview:divider];
    
    y += 42;
    
    // 1. Zoom
    UILabel *zoomTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, width, 20)];
    zoomTitle.text = @"📷 Zoom";
    zoomTitle.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    zoomTitle.font = [UIFont systemFontOfSize:13];
    [_containerView addSubview:zoomTitle];
    
    y += 18;
    
    _zoomLabel = [[UILabel alloc] initWithFrame:CGRectMake(width - 50, y - 2, 50, 20)];
    _zoomLabel.text = @"32.0";
    _zoomLabel.textColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0];
    _zoomLabel.font = [UIFont boldSystemFontOfSize:14];
    _zoomLabel.textAlignment = NSTextAlignmentRight;
    [_containerView addSubview:_zoomLabel];
    
    _zoomSlider = [[UISlider alloc] initWithFrame:CGRectMake(padding, y, width - 50, 30)];
    _zoomSlider.minimumValue = 10;
    _zoomSlider.maximumValue = 80;
    _zoomSlider.value = 32;
    _zoomSlider.tintColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    [_zoomSlider addTarget:self action:@selector(zoomChanged:) forControlEvents:UIControlEventValueChanged];
    [_containerView addSubview:_zoomSlider];
    
    y += 42;
    
    // 2. Free Camera
    UILabel *freeLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, 120, 28)];
    freeLabel.text = @"🔄 Free Camera";
    freeLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    freeLabel.font = [UIFont systemFontOfSize:13];
    [_containerView addSubview:freeLabel];
    
    _freeCameraSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 51, y - 2, 51, 31)];
    _freeCameraSwitch.on = NO;
    _freeCameraSwitch.onTintColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0];
    [_freeCameraSwitch addTarget:self action:@selector(freeCameraToggled:) forControlEvents:UIControlEventValueChanged];
    [_containerView addSubview:_freeCameraSwitch];
    
    y += 44;
    
    // 3. No Fog
    UILabel *fogLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, 120, 28)];
    fogLabel.text = @"🌫️ No Fog";
    fogLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    fogLabel.font = [UIFont systemFontOfSize:13];
    [_containerView addSubview:fogLabel];
    
    _fogSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(width - 51, y - 2, 51, 31)];
    _fogSwitch.on = NO;
    _fogSwitch.onTintColor = [UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0];
    [_fogSwitch addTarget:self action:@selector(fogToggled:) forControlEvents:UIControlEventValueChanged];
    [_containerView addSubview:_fogSwitch];
    
    y += 48;
    
    // 4. Reset Button
    _resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _resetButton.frame = CGRectMake(padding, y, width, 38);
    [_resetButton setTitle:@"🔄 Reset Camera" forState:UIControlStateNormal];
    [_resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _resetButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _resetButton.backgroundColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:0.7];
    _resetButton.layer.cornerRadius = 8;
    [_resetButton addTarget:self action:@selector(resetCamera) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_resetButton];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.frame = CGRectMake(width - 32, 8, 28, 28);
    [closeButton setTitle:@"×" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithWhite:0.7 alpha:1.0] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:closeButton];
    
    y += 50;
    
    // 5. Status Label
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, width, 18)];
    _statusLabel.text = @"🔬 Research Mode | Simulated";
    _statusLabel.textColor = [UIColor colorWithRed:0.2 green:0.8 blue:1.0 alpha:1.0];
    _statusLabel.font = [UIFont systemFontOfSize:10];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [_containerView addSubview:_statusLabel];
    
    y += 22;
    
    // 6. Info Label
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, y, width, 14)];
    infoLabel.text = @"📚 Nghiên cứu Camera - AOV";
    infoLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
    infoLabel.font = [UIFont systemFontOfSize:9];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    [_containerView addSubview:infoLabel];
}

- (void)setupGestures {
    // Kéo thả panel
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_containerView addGestureRecognizer:pan];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self || hitView == nil) {
        return nil;
    }
    return hitView;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    CGRect frame = _containerView.frame;
    frame.origin.x += translation.x;
    frame.origin.y += translation.y;
    
    // Giới hạn không ra khỏi màn hình
    if (frame.origin.x < 0) frame.origin.x = 0;
    if (frame.origin.y < 20) frame.origin.y = 20;
    if (frame.origin.x + frame.size.width > self.frame.size.width) {
        frame.origin.x = self.frame.size.width - frame.size.width;
    }
    if (frame.origin.y + frame.size.height > self.frame.size.height) {
        frame.origin.y = self.frame.size.height - frame.size.height;
    }
    
    _containerView.frame = frame;
    [gesture setTranslation:CGPointZero inView:self];
}

#pragma mark - Actions

- (void)zoomChanged:(UISlider *)slider {
    float value = slider.value;
    _zoomLabel.text = [NSString stringWithFormat:@"%.1f", value];
    
    // Ghi vào memory (simulated)
    [_memoryManager writeFloat:value atOffset:_memoryManager.offsetZoom];
    [self updateStatus];
}

- (void)freeCameraToggled:(UISwitch *)sender {
    BOOL enabled = sender.on;
    [_memoryManager writeBool:enabled atOffset:_memoryManager.offsetFreeCamera];
    
    // Cập nhật màu
    sender.onTintColor = enabled ? 
        [UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0] :
        [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    
    [self updateStatus];
}

- (void)fogToggled:(UISwitch *)sender {
    BOOL enabled = sender.on;
    // Khi switch ON = tắt fog (m_baseFogEnable = false)
    [_memoryManager writeBool:!enabled atOffset:_memoryManager.offsetFogEnable];
    
    sender.onTintColor = enabled ? 
        [UIColor colorWithRed:0.2 green:0.8 blue:0.4 alpha:1.0] :
        [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    
    [self updateStatus];
}

- (void)resetCamera {
    // Reset Zoom
    _zoomSlider.value = 32;
    _zoomLabel.text = @"32.0";
    [_memoryManager writeFloat:32.0 atOffset:_memoryManager.offsetZoom];
    
    // Reset Free Camera
    _freeCameraSwitch.on = NO;
    [_memoryManager writeBool:NO atOffset:_memoryManager.offsetFreeCamera];
    _freeCameraSwitch.onTintColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    
    // Reset Fog
    _fogSwitch.on = NO;
    [_memoryManager writeBool:YES atOffset:_memoryManager.offsetFogEnable];
    _fogSwitch.onTintColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
    
    [self updateStatus];
    
    NSLog(@"[CameraPanel] 🔄 Camera reset to default");
}

- (void)closeButtonTapped {
    [self hide];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuDidClose" object:nil];
}

- (void)updateStatus {
    float zoom = [_memoryManager readFloatAtOffset:_memoryManager.offsetZoom];
    BOOL freeCam = [_memoryManager readBoolAtOffset:_memoryManager.offsetFreeCamera];
    BOOL fogEnabled = [_memoryManager readBoolAtOffset:_memoryManager.offsetFogEnable];
    
    _statusLabel.text = [NSString stringWithFormat:@"🔬 Zoom:%.1f | Free:%@ | Fog:%@",
                         zoom,
                         freeCam ? @"ON" : @"OFF",
                         fogEnabled ? @"ON" : @"OFF"];
}

#pragma mark - Show/Hide

- (void)show {
    self.hidden = NO;
    [self updateStatus];
}

- (void)hide {
    self.hidden = YES;
}

- (void)toggleVisibility {
    self.hidden = !self.hidden;
}

@end