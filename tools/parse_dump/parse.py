#!/usr/bin/env python3
import re
import json

def parse_dump(dump_file):
    with open(dump_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Tìm CameraSystem
    camera_system = re.search(r'public class CameraSystem : MonoSingleton<CameraSystem>.*?}', 
                              content, re.DOTALL)
    
    # Tìm các offset
    offsets = {
        'Zoom': {'offset': '0xDC', 'type': 'float'},
        'bFreeCamera': {'offset': '0x28', 'type': 'bool'},
        'bFreeRotate': {'offset': '0x29', 'type': 'bool'},
        'm_baseFogEnable': {'offset': '0x88', 'type': 'bool'},
        'MobaCamera': {'offset': '0x20', 'type': 'Moba_Camera'},
        'm_curZoom': {'offset': '0x94', 'type': 'float'},
    }
    
    return {
        'camera_system': camera_system.group(0) if camera_system else None,
        'offsets': offsets
    }

if __name__ == '__main__':
    result = parse_dump('dump.cs')
    print(json.dumps(result, indent=2))