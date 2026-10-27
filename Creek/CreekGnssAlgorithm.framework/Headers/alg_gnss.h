/**
 * alg_gnss.h - App 端 GPS 算法对外接口 (v3.0)
 *
 * 使用方式：
 *   alg_gnss_init(10.0f);                    // 运动开始前调用一次
 *   result = alg_gnss_process(loc, sport);   // 每秒 GPS 更新时调用
 *
 * 输入 loc 来自手机 NMEA/定位 SDK，经纬度为度分格式整数(×1e7)。
 * 输出 result 中 latitude/longitude 为十进制度(×1e7)，与输入格式不同，注意区分。
 */

#ifndef ALG_GNSS_C_PROJ_ALG_GNSS_H
#define ALG_GNSS_C_PROJ_ALG_GNSS_H

#include <stdint.h>

#define GNSS_QUEUE_LEN 10  /* 速度滤波队列长度(秒) */

/**
 * GPS 输入结构（App 每秒传入）
 * 无 ACC/步频/游泳等字段
 */
typedef struct {
    uint32_t utc_time;              /* Unix 时间戳(秒)，用于算相邻帧间隔 */
    uint8_t rmc_location_status;    /* 1=定位有效(A)  0=未定位(V) */
    int32_t rmc_latitude;           /* 纬度，度分×1e7，如 223456789 = 22°34.56789' */
    int32_t rmc_longitude;          /* 经度，度分×1e7 */
    uint8_t rmc_n_or_s;             /* 0=北纬  1=南纬 */
    uint8_t rmc_e_or_w;             /* 0=东经  1=西经 */
    float gsa_pdop;                 /* 精度因子，越小越好，典型 1~15 */
    float hacc;                     /* 水平精度(米)，无则传 0；超 init 阈值视为未定位 */
    float rmc_speed;                /* 对地航速(节)，无则传 0；用于热身判运动 */
    float rmc_cog;                  /* 航向角(度)，无则传 0；参与轨迹 q 调节 */
} gnss_location_t;

/**
 * 算法输出结构
 */
typedef struct {
    int32_t latitude;               /* 滤波后纬度，十进制度×1e7，如 225700000 = 22.57°N */
    int32_t longitude;              /* 滤波后经度，十进制度×1e7 */
    uint32_t distance_cm;           /* 本秒滤波距离(厘米)，累计可得总里程 */
    uint32_t speed_kmh;             /* 速度，内部单位，显示时 ÷1000 得 km/h */
    uint32_t speed_perkm;           /* 配速，单位 秒/公里 */
    uint8_t gnss_enable;            /* 0=无效  1=有效可展示/存储  255=丢信号 */
    uint8_t save_flag;              /* 1=本帧可写入轨迹/距离记录 */
    uint8_t remain_time;            /* 搜星倒计时，0 表示定位就绪 */
    uint8_t location_rssi;          /* 信号档位 0~3，越大越好 */
} alg_gnss_result_t;

/** 初始化；hacc_limit 为水平精度门限(米)，最低 10 */
extern void alg_gnss_init(float hacc_limit);

/**
 * 主处理，每秒调用
 * @param sport_type  0=跑走等通用户外  5=骑行（速度限幅策略不同）
 */
extern alg_gnss_result_t alg_gnss_process(gnss_location_t location, uint8_t sport_type);

#define ALG_GNSS_MAIN_VERSION 3
#define ALG_GNSS_SUB_VERSION 1

typedef struct {
    uint8_t main_version;
    uint8_t sub_version;
} gnss_alg_version_t;

extern gnss_alg_version_t get_gnss_alg_version(void);

#endif
