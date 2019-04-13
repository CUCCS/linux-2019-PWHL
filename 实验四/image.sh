#!/bin/bash
quality="70"
RESOLUTION="50%x50%"
watermark=""
Q_FLAG="0"
R_FLAG="0"
W_FLAG="0"
C_FLAG="0"
H_FLAG="0"
PREFIX=""
POSTFIX=""
DIR=`pwd`
useage()
{
  echo "Useage:bash image.sh  -d [directory] [option|option]"
  echo "options:"
  echo "  -d [directory]                支持对指定目录下所有支持格式的图片文件进行批处理,该脚本会创建一个输出目录"
  echo "  -c                            将png / svg更改为jpg图像"
  echo "  -r|--resize [width*height]    使用700x700或50％x50％等分辨率调整图像大小"
  echo "  -q|--quality [number]         压缩jpg图像的质量 "
  echo "  -w|watermark [watermark]      支持对图片批量添加自定义文本水印"
  echo "  --prefix[prefix]              统一添加文件名前缀，不影响原始文件扩展名"
  echo "  --postfix[postfix]            统一添加文件名后缀，不影响原始文件扩展名"
}

main()
{

if [[ "$H_FLAG" == "1" ]]; then
    useage
fi

if [ ! -d "$DIR" ] ; then
  echo "No such directory"
  exit 0
fi
# 输出目录
output=${DIR}/output
mkdir -p $output

command="convert"
IM_FLAG="2"
if [[ "$Q_FLAG" == "1" ]]; then
  
  IM_FLAG="1"
  command=${command}" -quality "${quality}
fi

if [[ "$R_FLAG" == "1" ]]; then

  command=${command}" -resize "${RESOLUTION}
fi

if [[ "$W_FLAG" == "1" ]]; then
  echo ${watermark}
  command=${command}" -fill white -pointsize 40 -draw 'text 10,50 \"${watermark}\"' "
fi

if [[ "$C_FLAG" == "1" ]]; then
  IM_FLAG="2"
fi


case "$IM_FLAG" in
       # 用find找到指定目录下的图片
       1) images=`find $DIR -maxdepth 1 -regex '.*\(jpg\|jpeg\)'` ;;
       2) images=`find $DIR -maxdepth 1 -regex '.*\(jpg\|jpeg\|png\|svg\)'` ;;

esac 
# 循环遍历图片集合对其进行处理
for CURRENT_IMAGE in $images; do
     filename=$(basename "$CURRENT_IMAGE")
     name=${filename%.*}
     suffix=${filename#*.}
     if [[ "$suffix" == "png" && "$C_FLAG" == "1" ]]; then 
       suffix="jpg"
     fi
     if [[ "$suffix" == "svg" && "$C_FLAG" == "1" ]]; then
       suffix="jpg"
     fi
     savefile=${output}/${PREFIX}${name}${POSTFIX}.${suffix}
     temp=${command}" "${CURRENT_IMAGE}" "${savefile}
     eval $temp
done
exit 0
}

TEMP=`getopt -o cr:d:q:w: --long quality:arga,directory:,watermark:,prefix:,postfix:,help,resize: -n 'image.sh' -- "$@"`
eval set -- "$TEMP"
# 将选项和参数提取到变量中
while true ; do
    case "$1" in
        -c) C_FLAG="1" ; shift ;;
        -r|--resize) R_FLAG="1";
            case "$2" in
                "") shift 2 ;;
                *)RESOLUTION=$2 ; shift 2 ;;
            esac ;;
        --help) H_FLAG="1"; shift ;;
        -d|--directory)
            case "$2" in 
                "") shift 2 ;;
                 *) DIR=$2 ; shift 2 ;;
            esac ;; 
        -q|--quality) Q_FLAG="1";
            case "$2" in
                "") shift 2 ;;
        # 检测压缩的大小是否为整数
                 *) quality=$2; shift 2 ;;
            esac ;;
        -w|--watermark)W_FLAG="1"; watermark=$2; shift 2 ;;
        --prefix) PREFIX=$2; shift 2;;
        --postfix) POSTFIX=$2; shift 2 ;;
                
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


main
