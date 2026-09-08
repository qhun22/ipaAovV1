#import "MemoryManager.h"
#import <dlfcn.h>

@implementation MemoryManager

+ (instancetype)sharedManager {
    static MemoryManager *instance;
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

- (mach_vm_address_t)findCameraSystem {
    void *handle = dlopen(NULL, RTLD_NOW);
    if (handle != NULL) {
        void *symbol = dlsym(handle, "_ZN12CameraSystemC1Ev");
        if (symbol != NULL) {
            dlclose(handle);
            return (mach_vm_address_t)symbol;
        }
        dlclose(handle);
    }
    return 0;
}

- (BOOL)writeFloat:(float)value atOffset:(uintptr_t)offset {
    mach_vm_address_t base = [self findCameraSystem];
    if (base == 0) return NO;
    return mach_vm_write(mach_task_self(), base + offset, (vm_offset_t)&value, sizeof(value)) == KERN_SUCCESS;
}

- (BOOL)writeBool:(BOOL)value atOffset:(uintptr_t)offset {
    bool rawValue = value;
    mach_vm_address_t base = [self findCameraSystem];
    if (base == 0) return NO;
    return mach_vm_write(mach_task_self(), base + offset, (vm_offset_t)&rawValue, sizeof(rawValue)) == KERN_SUCCESS;
}

- (float)readFloatAtOffset:(uintptr_t)offset {
    mach_vm_address_t base = [self findCameraSystem];
    if (base == 0) return 0.0f;
    float value = 0.0f;
    mach_vm_size_t size = sizeof(value);
    vm_offset_t data = 0;
    kern_return_t result = mach_vm_read(mach_task_self(), base + offset, size, &data, &size);
    if (result == KERN_SUCCESS) {
        memcpy(&value, (const void *)data, sizeof(value));
        vm_deallocate(mach_task_self(), data, size);
    }
    return value;
}

- (BOOL)readBoolAtOffset:(uintptr_t)offset {
    mach_vm_address_t base = [self findCameraSystem];
    if (base == 0) return NO;
    bool value = false;
    mach_vm_size_t size = sizeof(value);
    vm_offset_t data = 0;
    kern_return_t result = mach_vm_read(mach_task_self(), base + offset, size, &data, &size);
    if (result == KERN_SUCCESS) {
        memcpy(&value, (const void *)data, sizeof(value));
        vm_deallocate(mach_task_self(), data, size);
    }
    return value;
}

@end
