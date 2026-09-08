#import <Foundation/Foundation.h>
#import <mach/mach.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryManager : NSObject

+ (instancetype)sharedManager;
- (mach_vm_address_t)findCameraSystem;
- (BOOL)writeFloat:(float)value atOffset:(uintptr_t)offset;
- (BOOL)writeBool:(BOOL)value atOffset:(uintptr_t)offset;
- (float)readFloatAtOffset:(uintptr_t)offset;
- (BOOL)readBoolAtOffset:(uintptr_t)offset;

@property (nonatomic, assign, readonly) uintptr_t offsetZoom;
@property (nonatomic, assign, readonly) uintptr_t offsetFreeCamera;
@property (nonatomic, assign, readonly) uintptr_t offsetFreeRotate;
@property (nonatomic, assign, readonly) uintptr_t offsetFogEnable;

@end

NS_ASSUME_NONNULL_END
