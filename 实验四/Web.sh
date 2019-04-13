#!/bin/bash

URL="/ksc.html"

# set arguement
TEMP=`getopt -o hiuces: --long sourcehost,sourceip,frenquencyurl,responcecode,errorcode,specifiedurl:,help -n 'weblog.sh' -- "$@"`
eval set -- "$TEMP"

funSourceHost()
{
  more +2 web_log.tsv | awk -F\\t '{print $1}' |  sort | uniq -c | sort -nr | head -n 100
  exit 0
}

funSourceHostIP()
{
  more +2 web_log.tsv | awk -F\\t '{print $1}' | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' | sort | uniq -c | sort -nr | head -n 100
  exit 0
}

funFrequencyUrl()
{
  more +2 web_log.tsv |awk -F\\t '{print $5}'|sort | uniq -c |sort -nr | head -n 100
  exit 0
}


funResponceCode()
{
  argu_4_code=$(more +2 web_log.tsv |awk -F\\t '{print $6}'| sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}')
  argu_4_times=$(more +2 web_log.tsv |awk -F\\t '{print $6}'| sort | uniq -c |sort -nr | head -n 10 | awk '{print $1}')
  codeArray=($argu_4_code)
  timesArray=($argu_4_times)
  for i in $argu_4_times ; do
    total=$(($total+$i))
  done
  echo -e "Responce code:\n"
  i=0
  while [ $i -lt ${#codeArray[@]} ]; do
    por=$(echo "scale=2; 100 * ${timesArray[${i}]} / $total" | bc)
    echo -e "code:"${codeArray[${i}]}"   times: "${timesArray[${i}]}"    proportion "$por"%"
    i=$(($i+1))
  done
  exit 0
}

funResponceCodeErr()
{
  echo -e "404 responce code:"
  more +2 web_log.tsv |awk -F\\t '{print $6,$5}' | grep '404 ' | sort | uniq -c |sort -nr|head -n 10

  echo -e "403 responce code:"
  more +2 web_log.tsv |awk -F\\t '{print $6,$5}' | grep '403 ' | sort | uniq -c |sort -nr|head -n 10
  exit 0
}

funSpecifiedUrl()
{
  url=""$URL""
  temp="more +2 web_log.tsv |grep \""'${url}'"\"|awk -F'\t' '{print "'$1'"}'|sort|uniq -c|sort -nr|head -n 100"
  eval -- $temp
  exit 0
}

while true ; do
    case "$1" in
        -h|--sourcehost) funSourceHost ; shift ;;
        -i|--sourceip) funSourceHostIP ; shift ;;
        -u|--frenquencyurl) funFrequencyUrl ; shift ;;
        -c|--responcecode) funResponceCode ; shift ;;
        -e|--errorcode) funResponceCodeErr ; shift ;;
        -s|--specifiedurl) URL=$2 ; funSpecifiedUrl ; shift 2;;
        --help) echo -e "Web.sh supports the statistical task of 'The Athlete Data of 2014 World Cup'\n
Usage: bash Web.sh [OPTIONS] [PARAMETER] \n
-h, --sourcehost          统计访问来源主机TOP 100和分别对应出现的总次数\n
-i, --sourceip            统计访问来源主机TOP 100 IP和分别对应出现的总次数\n
-u, --frenquencyurl        统计最频繁被访问的URL TOP 100\n
-c, --responcecode         统计不同响应状态码的出现次数和对应百分比\n
-e, --errorcode            分别统计不同4XX状态码对应的TOP 10 URL和对应出现的总次数\n
-s, --specifiedurl[=URL]   给定URL输出TOP 100访问来源主机\n
--help                     请求帮助\n"; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


