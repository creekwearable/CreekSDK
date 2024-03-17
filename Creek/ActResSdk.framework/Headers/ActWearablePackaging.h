//
//  ActWearablePackaging.h
//  ActWearablePackaging
//
//  Created by inidhu on 2022/3/22.
//  Copyright © 2022 Actions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActWearablePackaging : NSObject

/**
 * 图片是否需要压缩, 非 jpeg 图片直接返回 false
 * 参数含义见 replacePicture()
 */
+(bool)isNeedJpegCompress:(NSDictionary *)info;

/**
 * 替换图片接口（替换图片宽高必须一致，否则替换失败）
 * @param in_sty_path       输入：原始的sty文件路径
 * @param in_res_path       输入：原始的res文件路径
 * @param in_scene_name     输入：场景名
 * @param in_pic_name       输入：图片名
 * @param in_picture_path   输入：替换图片路径
 * @param out_res_path      输出：替换图片后的res文件路径
 * @param out_sty_path      输出：替换图片后相应的修改
 * @param in_jpeg_min_width       输入：最小宽
 * @param in_jpeg_min_height      输入：最小高
 * @param in_jpeg_min_SplitWidth  输入：分块宽
 * @param in_jpeg_min_SplitHeight 输入：分块高
 * @param in_jpeg_quality         输入：图片质量
 * @param in_is_raw_jpeg          输入：是否打包原始 jpeg
 * @return                        返回值：1：替换成功 其他值：替换失败
 */
+(int)replacePictureWithInfo:(NSDictionary *)info;

/**
* @param "OutputPath"          输出文件
* @param "PicPath"             图片路径
* @param "JPEGMinWidth"        jpeg 最小宽
* @param "JPEGMinHeight"       jpeg 最小高
* @param "JPEGMinSplitWidth"   jpeg 分块宽
* @param "JPEGMinSplitHeight"  jpeg 分块高
* @param "JPEGQuality"         jpeg 图片质量
* @param "IsRawJPEG"           jpeg 是否打包原始
* @param "PicFormat"           图片格式
* @param "IsCompress"          是否压缩
* @param "IsBestQuarlity"      是否质量优先
* @param "TitleWidth"          分块压缩宽度
* @param "TitleHeight"         分块压缩高度
 */
+(int)addSinglePicture:(NSDictionary *)info;

@end
