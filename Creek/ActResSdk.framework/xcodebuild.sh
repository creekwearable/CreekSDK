# Sets the target folders and the final framework product.

# 如果工程名称和Framework的Target名称不一样的话，要自定义FMKNAME

# 例如: FMK_NAME = "SDKFramework"

FMK_NAME="SDKFramework"

if [ "${ACTION}" = "build" ]
then
INSTALL_DIR=${SRCROOT}/Products/${FMK_NAME}.framework

DEVICE_DIR=${BUILD_ROOT}/${CONFIGURATION}-iphoneos/${FMK_NAME}.framework

SIMULATOR_DIR=${BUILD_ROOT}/${CONFIGURATION}-iphonesimulator/${FMK_NAME}.framework

# 如果真机包或模拟包不存在，则退出合并
if [ ! -d "${DEVICE_DIR}" ] || [ ! -d "${SIMULATOR_DIR}" ]
then
exit 0
fi

# 如果合并包已经存在，则替换
if [ -d "${INSTALL_DIR}" ]
then
rm -rf "${INSTALL_DIR}"
fi

mkdir -p "${INSTALL_DIR}"

cp -R "${DEVICE_DIR}/" "${INSTALL_DIR}/"

# 使用lipo命令将其合并成一个通用framework
# 最后将生成的通用framework放置在工程根目录下新建的Products目录下
lipo -create "${DEVICE_DIR}/${FMK_NAME}" "${SIMULATOR_DIR}/${FMK_NAME}" -output "${INSTALL_DIR}/${FMK_NAME}"

#给模拟器的Modules文件夹下的.swiftmodule文件夹赋值
simulator_modules_path="${SIMULATOR_DIR}/Modules/${FMK_NAME}.swiftmodule/."
cp -R "${simulator_modules_path}" "${INSTALL_DIR}/Modules/${FMK_NAME}.swiftmodule"

#合并完成后打开目录
open "${SRCROOT}/Products"

fi

