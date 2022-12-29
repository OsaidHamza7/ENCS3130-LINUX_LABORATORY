dos="True"
savedValue=0
correctFormat=0
while ((dos=="True")) 
do
echo
echo "********************************************************"
echo
echo "r) read a dataset from a file"
echo "p) print the names of the features"
echo "l) encode a features using label encoding"
echo "o) encode a features using one-hot encoding"
echo "m) apply MinMax scalling"
echo "s) save the processed dataset"
echo "e) exit"
echo
echo "********************************************************" 
echo
echo "please enter your option:"
read option
case $option in 

#//////////////////////////////////////////////////////////////////////////////////////////////

r) echo "Please input the name of dataset file:"
	read FileName
	if [ -e $FileName ];then
               firstLine=$(sed -n 1p dataset.txt)
	       secondLine=$(sed -n 2p dataset.txt)
		a=$(echo $firstLine | tr ";" "\n" | wc -l)
	       b=$(echo $secondLine | tr ";" "\n" | wc -l)
	      	if [ $a -eq $b ];then
		       echo "The format of the data in the dataset file was verified correctly"
                       correctFormat=1
			cat dataset.txt > CopyDataset.txt
		else
		   echo "The format of the data in the dataset file is wrong"
		   correctFormat=0
 		fi

  	else
	    echo "file does not exist"
	    correctFormat=0
	fi;;
#//////////////////////////////////////////////////////////////////////////////////////////////

p) if [ $correctFormat -eq 1 ];then
        echo "--------------------------------------------------------"
	     sed -n '1p' CopyDataset.txt | tr ";" ","
	echo "--------------------------------------------------------"
   else
     echo "You must first read a dataset from a file"
   fi;;

#//////////////////////////////////////////////////////////////////////////////////////////////
l)
if [ $correctFormat -eq 1 ];then
	 echo "Please input the name of the categorical feature for label encoding:"
    	 read CatFeature
     	checkFeature=$(sed -n 1p CopyDataset.txt| grep "$CatFeature"|wc -c)
      	if [ $checkFeature -gt 0 ];then
       			sed -n 1p CopyDataset.txt | tr ";" "\12" > features.txt
       			i=1
       			for j in `cat features.txt`
       			do
       			     if [ "$j" == "$CatFeature" ]
				then break
			     fi
				i=$(( i + 1 ))
	   		done
         		#i is a number of categorical in features
	     		     cat CopyDataset.txt | cut -d";" -f"$i" > column.txt
			    #column of this categorical feature
			     cat column.txt > uniqe.txt
	     		     cat -n uniqe.txt | sort -uk2 | sort -n | cut -f2- > Temp
			     mv Temp uniqe.txt
			     #make this column uniqe
			     value=-1
			     echo
			     echo "-------------------------------"
                             for c in `cat uniqe.txt`
                             do	  if [ $value -ge 0 ];then
                                   echo "$c:$value"
                                   sed -i "s/^$c/$value/" column.txt
				  fi
                                   value=$(( value + 1 ))
                             done
			    echo "-------------------------------"
			   cat CopyDataset.txt | tr ";" " " > copy.txt
			   awk 'NR == FNR {a[FNR] = $B;next}{$A = a[FNR]; print}' B=1 A=$i "column.txt" "copy.txt" > Temp
			   mv Temp CopyDataset.txt
			   cat CopyDataset.txt | tr " " ";" > Temp
			   mv Temp CopyDataset.txt
			   sed -i 's/$/;/' CopyDataset.txt

	else echo "The name of categorical feature is wrong"
        fi
else
  echo "You must first read a dataset from a file"

fi;;
#//////////////////////////////////////////////////////////////////////////////////////////////////

o)if [ $correctFormat -eq 1 ]
    then echo "Please input the name of the categorical feature for label encoding:"
         read CatFeature
       	 checkFeature=$(sed -n 1p CopyDataset.txt| grep "$CatFeature"|wc -c)
         if [ $checkFeature -gt 0 ];then
            sed -n 1p CopyDataset.txt | tr ";" "\12" > features.txt
	    numberFeatures=$(wc -l features.txt | cut -c 1)
            	 	i=1
           	 	for j in `cat features.txt`
           	 	do
                             if [ "$j" == "$CatFeature" ]
                                then break
                             fi
                                i=$(( i + 1 ))
                        done
                             #i is a number of categorical in features
                             cat CopyDataset.txt | cut -d";" -f"$i" > column.txt
                             #column of this categorical feature
			     cat column.txt > uniqe.txt
                             cat -n uniqe.txt | sort -uk2 | sort -n | cut -f2- > Temp
                             mv Temp uniqe.txt
                             #make this column uniqe
			     Number=$(wc -l uniqe.txt | cut -d" " -f1)
			     # delete a column of feature to add a new column in last
			     if [ $i -eq 1 ];then
			       cut -d ";" -f2- CopyDataset.txt > Temp
			     elif [ $i -eq $numberFeatures ];then
				v=$(( i - 1 ))
				cut -d ";" -f1-$v CopyDataset.txt > Temp
			     else
				v=$(( i + 1 ))
				d=$(( i - 1 ))
				cut -d ";" -f 1-$d,$v- CopyDataset.txt > Temp
			     fi
			     mv Temp CopyDataset.txt

			     zeros=""
			     while [ "$Number" -gt 1 ]
				do
				  zeros+="0;"
			          Number=$(( Number - 1 ))
				done
			     echo "${zeros}" > zeros.txt
			     newFeature=""
			     n=0
			     echo
                             echo "-------------------------------"
                             for  i in `cat uniqe.txt`
                                do
				   if [ $n -gt 0 ];then
				   newFeature+="${CatFeature}-${i};"
				   newValue=$(sed "s/0/1/${n}" zeros.txt)
                                   echo "${i}"
                                   sed "s/^${i}$/${newValue}/" column.txt > temp
                                   mv temp column.txt
				   fi
                                   n=$(( n + 1 ))
                                done
				echo "-------------------------------"
				sed "s/${CatFeature}/${newFeature}/" column.txt > temp
                                mv temp column.txt
                               paste -d "" CopyDataset.txt column.txt > Temp
				mv Temp CopyDataset.txt
         else
            echo "the name of categorical feature is wrong"
         fi
else
     echo "You must first read a dataset from a file"

fi;;

#/////////////////////////////////////////////////////////////////////
m)
if [ $correctFormat -eq 1 ]
	then echo "Please input the name of the feature to be scaled:"
	    read Feature 
    	checkFeature=$(sed -n 1p CopyDataset.txt | grep "$Feature" | wc -c)
	if [ $checkFeature -gt 0 ];then
       			sed -n 1p CopyDataset.txt | tr ";" "\12" > features.txt
       			i=0
       			for j in `cat features.txt`
       			do
				j=$(echo "$j" | cut -d"-" -f1)
				if [ "$j" == "$Feature" ];then
				i=$(( i + 1 ))
				 break
			     fi
				i=$(( i + 1 ))
	   		done

         		#i is a number of categorical in features
	     		     cat CopyDataset.txt | cut -d";" -f"$i"  > column.txt
			    #column of this categorical feature
			     firstValue=$(sed -n 2p column.txt)
			     checkInteger=$(echo $firstValue | grep '^[0-9]$' | wc -l )
		 	     if [ $checkInteger -eq 0 ]; then #is a categorical
				echo "this feature is categorical feature and must be encoded first"
				continue # return to main menu
			     fi
			     cat column.txt > uniqe.txt
	     		     cat -n uniqe.txt | sort -uk2 | sort -n | cut -f2- > Temp
			     mv Temp uniqe.txt
			     #make this column uniqe

			     sed -i 1d uniqe.txt
			     min=$(sort -n uniqe.txt | sed -n '1p')
			     max=$(sort -r -n uniqe.txt | sed -n '1p') #r:reverse
			     result=$(( max - min ))
			     echo "Minimun Value:$min,Maximum Value:$max"
			     value=0
			     echo
			     echo "-------------------------------"
			    if [ $min -eq $max ];then
				sed -i "s/$min/0/" column.txt
				echo "1:0"
			   else
                             for c in `cat uniqe.txt`
                             do	  if [ $value -ge 0 ];then
				   new=$(printf "%.1f" $(echo "scale=1; ($c - $min) / $result" | bc  )) # scale 1 to print 1 digit after (.) 
                                   if [ $new == "0.0" -o $new == "1.0" ];then
					new=$(echo "$new" | cut -d"." -f1)
				   fi
				   echo "$c:$new"
                                   sed -i "s/^${c}$/$new/" column.txt
				  else sed -i "s/$c/$c/" column.txt
				  fi
                                   value=$(( value + 1 ))
                             done
			   fi
			    echo "-------------------------------"
			   cat CopyDataset.txt | tr ";" " " > copy.txt
			   awk 'NR == FNR {a[FNR] = $B;next}{$A = a[FNR]; print}' B=1 A=$i "column.txt" "copy.txt" > Temp
			   mv Temp CopyDataset.txt
			   cat CopyDataset.txt | tr " " ";" > Temp
			   mv Temp CopyDataset.txt
			   sed -i 's/$/;/' CopyDataset.txt

	else echo "The name of categorical feature is wrong"
        fi
else echo "You must first read a dataset from a file" 
fi;;
#//////////////////////////////////////////////////////////////////////////////////////////////
s)   if [ $correctFormat -eq 1 ]
      then
	echo "Please input the name of the file to save the processed dataset:"
        read saveFile
        cat CopyDataset.txt > $saveFile
        savedValue=1
	echo "processed dataset was saved successfully"
     else
       echo "You must first read a dataset from a file"
     fi;;
#//////////////////////////////////////////////////////////////////////////////////////////////

e)

  if [ $savedValue -eq 1 ]
      then
	   echo "Are you sure you want to exist?"
  else
           echo "The processed dataset is not saved.Are you sure you want to exist"
  fi
  
  read saveOption
   if [ "$saveOption" == "yes" ]
         then break
   fi;;

#//////////////////////////////////////////////////////////////////////////////////////////////

*) echo "Invalid option,please try again"
esac

done

