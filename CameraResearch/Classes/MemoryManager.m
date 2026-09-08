//
//  MemoryManager.m
//  CameraResearch
//

#import "MemoryManager.h"
#import <dlfcn.h>
#import <mach/mach.h>
#import <mach/mach_vm.h>      // 🔥 THÊM DÒNG NÀY!

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
    }
    return self;
}

#pragma mark - Find CameraSystem

- (mach_vm_address_t)findCameraSystem {
    // Phương thức tìm CameraSystem trong memory
    // Trong thực tế, cần scan memory hoặc dùng debug symbols
    
    // Cách 1: Tìm symbol (nếu có)
    void *handle = dlopen(NULL, RTLD_NOW);
    if (handle) {
        void *symbol = dlsym(handle, "_ZN12CameraSystemC1Ev");
        if (symbol) {
            return (mach_vm_address_t)symbol;
        }
        dlclose(handle);
    }
    
    // Cách 2: Trả về địa chỉ giả cho demo
    // Trong thực tế, sẽ scan heap để tìm CameraSystem
    // Hoặc dùng các công cụ như Frida để lấy địa chỉ thật
    // Vì đây là nghiên cứu học thuật, ta dùng giá trị mẫu
    return 0x0000000100000000;  // Demo address - Cần thay bằng địa chỉ thật khi test
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
        NSLog(@"[MemoryManager] Write float failed: %d", kr);
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
        NSLog(@"[MemoryManager] Write bool failed: %d", kr);
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
    vm_size_t dataSize = sizeof(float);
    mach_vm_read(mach_task_self(), targetAddr, dataSize, (vm_offset_t*)&value, &dataSize);
    
    return value;
}

- (BOOL)readBoolAtOffset:(uintptr_t)offset {
    mach_vm_address_t cameraSystem = [self findCameraSystem];
    if (cameraSystem == 0) {
        return NO;
    }
    
    mach_vm_address_t targetAddr = cameraSystem + offset;
    bool value = false;
    vm_size_t dataSize = sizeof(bool);
    mach_vm_read(mach_task_self(), targetAddr, dataSize, (vm_offset_t*)&value, &dataSize);
    
    return value;
}

@end