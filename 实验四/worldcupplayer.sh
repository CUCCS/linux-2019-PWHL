YearsData=$(awk -F '\t' '{print $6}' worldcupplayerinfo.tsv)
All=0
YearsData20=0
YearsData20to30=0
YearsData30=0
oldest=0
oldestname=''
youngest=50
youngestname=''
longestname=''
shortestname=''
maxlength=0
minlength=50
for data in $YearsData
do
        if [[ $data != 'Age' ]]
        then
                All=$[$All+1]
                if [[ $data -lt 20 ]]
                then
                        YearsData20=$[$YearsData20+1]
 fi
                if [[ $data -ge 20 && $data -le 30 ]]
                then
                        YearsData20to30=$[$YearsData20to30+1]
                fi
                if [[ $data -gt 30 ]]
                then
                        YearsData30=$[$YearsData30+1]
                fi
                if [[ $data -gt $oldest ]]
                then
                        oldest=$data
                        oldestname=$(awk -F '\t' 'NR=='$[$All+1]' {print $9}' worldcupplayerinfo.tsv)
                fi
                if [[ $data -lt $youngest ]]
                then
                        youngest=$data
                        youngestname=$(awk -F '\t' 'NR=='$[$All+1]' {print $9}' worldcupplayerinfo.tsv)
 fi
        fi
done
echo '20岁的运动员人数为:'$YearsData20' 所占的比例为:'$(awk 'BEGIN{printf "%.2f",'$YearsData20*100/$All'}')'%'
echo '20岁到30岁的运动员人数为:'$YearsData20to30' 所占的比例为:'$(awk 'BEGIN{printf "%.2f",'$YearsData20to30*100/$All'}')'%'
echo '30岁以上的运动员人数为:'$YearsData30' 所占的比例为:'$(awk 'BEGIN{printf "%.2f",'$YearsData30*100/$All'}')'%'
echo '年龄最大的运动员是: '$oldestname' '$oldest'岁'
echo '年龄最小的运动员是: '$youngestname' '$youngest'岁'

Positions=$(awk -F '\t' '{print $5}' worldcupplayerinfo.tsv)
declare -A dic
for data in $Positions
do
        if [[ $data != 'Position' ]]
        then
                if [[ !${dic[$data]} ]]
                then
                        dic[$data]=$[${dic[$data]}+1]
 else
                        dic[$data]=0
                fi
        fi
done
for key in ${!dic[@]}
do
        echo "$key : ${dic[$key]}""所占比例为:"$(awk 'BEGIN{printf "%.2f",'${dic[$key]}*100/$All'}')'%'
done

NameLength=$( awk -F '\t' '{print length($9)}' worldcupplayerinfo.tsv)
COUNT=0
for length in $NameLength
do
        COUNT=$[$COUNT + 1]
        if [[ $length -gt $maxlength ]]
        then
                maxlength=$length
                longestname=$(sed -n $COUNT'p' 'worldcupplayerinfo.tsv'|awk -F '\t'  '{print $9}')
fi
        if [[ $length -lt $minlength ]]
        then
                minlength=$length
                shortestname=$(sed -n $COUNT'p' 'worldcupplayerinfo.tsv'|awk -F '\t' '{print $9}')
        fi
done

echo '名字最长的运动员是:'$longestname
echo '名字最短的运动员是:'$shortestname

