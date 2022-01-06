

second_chars="A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"

files=`ls grib2*`

for fl in $files
do

for char in $second_chars
do
cat $fl | sed s:"'M${char}":"'Z${char}":g > tmp
cat tmp | sed s:"'L${char}":"'Y${char}":g > ${fl}
done
done

# grep "'M${char}" 
# grep "'L${char}"
