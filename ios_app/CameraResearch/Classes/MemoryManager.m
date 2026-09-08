//
//  MemoryManager.m
//  CameraResearch
//

#import "MemoryManager.h"
#import <dlfcn.h>
#import <mach/mach.h>

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
    }
    return self;
}

#pragma mark - Find CameraSystem

- (mach_vm_address_t)findCameraSystem {
    // Lấy task hiện tại (process của app)
    mach_port_t task = mach_task_self();
    
    // Lấy thông tin vùng nhớ
    vm_address_t address = 0;
    vm_size_t size = 0;
    vm_region_basic_info_data_64_t info;
    mach_msg_type_number_t info_count = VM_REGION_BASIC_INFO_COUNT_64;
    mach_port_t object_name;
    
    // Quét memory để tìm CameraSystem
    // Pattern: CameraSystem là MonoSingleton, nằm trong heap
    // Có thể tìm bằng cách scan pattern hoặc dùng symbol
    
    // Cách 1: Tìm symbol (nếu có)
    void *handle = dlopen(NULL, RTLD_NOW);
    if (handle) {
        // Thử tìm symbol CameraSystem
        void *symbol = dlsym(handle, "_ZN12CameraSystemC1Ev");
        if (symbol) {
            return (mach_vm_address_t)symbol;
        }
        dlclose(handle);
    }
    
    // Cách 2: Scan memory pattern (demo - cần implement thực tế)
    // Trong thực tế, cần scan các vùng nhớ để tìm pattern đặc trưng
    // Hoặc dùng debug symbols để xác định địa chỉ
    
    NSLog(@"[MemoryManager] CameraSystem not found");
    return 0;
}

#pragma mark - Read/Write Memory

- (BOOL)writeFloat:(float)value atOffset:(uintptr_t)offset {
    mach_vm_address_t cameraSystem = [self findCameraSystem];
    if (cameraSystem == 0) {
        NSLog(@"[MemoryManager] CameraSystem not found");
        return NO;
    }
    
    mach_vm_address_t targetAddr = cameraSystem + offset;
    kern_return_t kr = mach_vm_write(mach_task_self(), targetAddr, 
                                      (vm_offset_t)&value, sizeof(float));
    
    if (kr != KERN_SUCCESS) {
        NSLog(@"[MemoryManager] Write failed: %d", kr);
        return NO;
    }
    
    NSLog(@"[MemoryManager] Write float success at 0x%llx: %f", targetAddr, value);
    return YES;
}

- (BOOL)writeBool:(BOOL)value atOffset:(uintptr_t)offset {
    mach_vm_address_t cameraSystem = [self findCameraSystem];
    if (cameraSystem == 0) {
        NSLog(@"[MemoryManager] CameraSystem not found");
        return NO;
    }
    
    mach_vm_address_t targetAddr = cameraSystem + offset;
    bool boolValue = value ? true : false;
    kern_return_t kr = mach_vm_write(mach_task_self(), targetAddr,
                                      (vm_offset_t)&boolValue, sizeof(bool));
    
    if (kr != KERN_SUCCESS) {
        NSLog(@"[MemoryManager] Write failed: %d", kr);
        return NO;
    }
    
    NSLog(@"[MemoryManager] Write bool success at 0x%llx: %d", targetAddr, value);
    return YES;
}

- (float)readFloatAtOffset:(uintptr_t)offset {
    mach_vm_address_t cameraSystem = [self findCameraSystem];
    if (cameraSystem == 0) {
        return 0.0f;
    }
    
    mach_vm_address_t targetAddr = cameraSystem + offset;
    float value = 0;
    vm_size_t size = sizeof(float);
    
    kern_return_t kr = mach_vm_read(mach_task_self(), targetAddr,
                                     size, (vm_offset_t*)&value, &size);
    
    if (kr != KERN_SUCCESS) {
        NSLog(@"[MemoryManager] Read failed: %d", kr);
        return 0.0f;
    }
    
    return value;
}

- (BOOL)readBoolAtOffset:(uintptr_t)offset {
    mach_vm_address_t cameraSystem = [self findCameraSystem];
    if (cameraSystem == 0) {
        return NO;
    }
    
    mach_vm_address_t targetAddr = cameraSystem + offset;
    bool value = false;
    vm_size_t size = sizeof(bool);
    
    kern_return_t kr = mach_vm_read(mach_task_self(), targetAddr,
                                     size, (vm_offset_t*)&value, &size);
    
    if (kr != KERN_SUCCESS) {
        NSLog(@"[MemoryManager] Read failed: %d", kr);
        return NO;
    }
    
    return value;
}

@end