//
//  KMacro.h
//  TSS
//
//  Created by Chenfy on 2020/10/12.
//  Copyright © 2020 Chenfy. All rights reserved.
//

#ifndef KMacro_h
#define KMacro_h

#define KImage_url @"https://image.csslcloud.net/image/88C79C053AFF11E39C33DC5901307461/FCEA8AE260A7B5BC/0.jpg"

//SCREEN_SIZE 屏幕尺寸
#define KSCREEN_WIDTH   ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGTH  ([UIScreen mainScreen].bounds.size.height)


/** RGB */
#define ssRGB(r, g, b) \
[UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define ssRGBAlpha(r, g, b, a) \
[UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

/** Hex */
#define ssRGBHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ssRGBHexAlpha(rgbValue,a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]




#endif /* KMacro_h */
