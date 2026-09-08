//
//  MemoryManager.h
//  CameraResearch
//

#import <Foundation/Foundation.h>
#import <mach/mach.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryManager : NSObject

+ (instancetype)sharedManager;

// Memory Operations
- (BOOL)writeFloat:(float)value atOffset:(uintptr_t)offset;
- (BOOL)writeBool:(BOOL)value atOffset:(uintptr_t)offset;
- (float)readFloatAtOffset:(uintptr_t)offset;
- (BOOL)readBoolAtOffset:(uintptr_t)offset;

// Camera System Offsets (từ dump.cs)
@property (nonatomic, assign, readonly) uintptr_t offsetZoom;          // 0xDC
@property (nonatomic, assign, readonly) uintptr_t offsetFreeCamera;    // 0x28
@property (nonatomic, assign, readonly) uintptr_t offsetFreeRotate;    // 0x29
@property (nonatomic, assign, readonly) uintptr_t offsetFogEnable;     // 0x88
@property (nonatomic, assign, readonly) uintptr_t offsetMobaCamera;    // 0x20

@end

NS_ASSUME_NONNULL_END