//
//  MemoryManager.m
//  CameraResearch
//

#import "MemoryManager.h"
#import <dlfcn.h>

@implementation MemoryManager

+ (instancetype)sharedManager {
    static MemoryManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MemoryManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _offsetZoom = 0xDC;
        _offsetFreeCamera = 0x28;
        _offsetFreeRotate = 0x29;
        _offsetFogEnable = 0x88;
        _offsetMobaCamera = 0x20;
        
        // Giá trị giả lập
        _currentZoom = 32.0f;
        _isFreeCamera = NO;
        _isFogEnabled = YES;
    }
    return self;
}

#pragma mark - Memory Operations (Simulated for Research)

- (BOOL)writeFloat:(float)value atOffset:(uintptr_t)offset {
    // Trong môi trường nghiên cứu, ta giả lập việc ghi memory
    // Khi triển khai thực tế, thay bằng mach_vm_write
    
    if (offset == _offsetZoom) {
        _currentZoom = value;
        NSLog(@"[MemoryManager] 🔬 Zoom changed to: %.1f (Offset: 0x%lx)", value, (unsigned long)offset);
        return YES;
    }
    
    NSLog(@"[MemoryManager] 🔬 Write float at offset 0x%lx: %.1f", (unsigned long)offset, value);
    return YES;
}

- (BOOL)writeBool:(BOOL)value atOffset:(uintptr_t)offset {
    if (offset == _offsetFreeCamera) {
        _isFreeCamera = value;
        NSLog(@"[MemoryManager] 🔬 Free Camera: %@", value ? @"ON" : @"OFF");
        return YES;
    }
    
    if (offset == _offsetFogEnable) {
        _isFogEnabled = value;
        NSLog(@"[MemoryManager] 🔬 Fog: %@", value ? @"ON" : @"OFF");
        return YES;
    }
    
    NSLog(@"[MemoryManager] 🔬 Write bool at offset 0x%lx: %d", (unsigned long)offset, value);
    return YES;
}

- (float)readFloatAtOffset:(uintptr_t)offset {
    if (offset == _offsetZoom) {
        return _currentZoom;
    }
    return 0.0f;
}

- (BOOL)readBoolAtOffset:(uintptr_t)offset {
    if (offset == _offsetFreeCamera) {
        return _isFreeCamera;
    }
    if (offset == _offsetFogEnable) {
        return _isFogEnabled;
    }
    return NO;
}

#pragma mark - Real Memory Operations (For Future Implementation)

- (BOOL)writeFloatReal:(float)value atOffset:(uintptr_t)offset {
    // TODO: Implement real memory writing with mach_vm_write
    // Cần import <mach/mach_vm.h> và có quyền truy cập memory
    
    /*
    mach_vm_address_t cameraSystem = [self findCameraSystem];
    if (cameraSystem == 0) {
        NSLog(@"[MemoryManager] CameraSystem not found");
        return NO;
    }
    
    mach_vm_address_t targetAddr = cameraSystem + offset;
    kern_return_t kr = mach_vm_write(mach_task_self(), targetAddr,
                                      (vm_offset_t)&value, sizeof(float));
    return kr == KERN_SUCCESS;
    */
    
    return [self writeFloat:value atOffset:offset];
}

@end