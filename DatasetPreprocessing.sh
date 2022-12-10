dos="True"
savedValue=1
correctFormat=1

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
echo "please enter your option"
read option
case $option in 

#//////////////////////////////////////////////////////////////////////////////////////////////

r) echo "Please input the name of dataset file"
	read FileName
	if [ -e $FileName ]
	   then echo "file does exist"
               FirstLine=$(grep "id" dataset.txt)
		checkFormat="id;age;gender;height;weight;active;smoke;governorate;"
	      	if [ "$FirstLine" == "$checkFormat" ]
		   then
		       echo "verified that the file exists was done successfully"
                       correctFormat=0
		else
		   echo "The format of the data in the dataset file is wrong"
		   correctFormat=1
 		fi

  	else
	    echo "file does not exist"
	    correctFormat=1
	fi;;

#//////////////////////////////////////////////////////////////////////////////////////////////

p) if [ $correctFormat -eq 0 ]
    then echo "correct format"
       echo "--------------------------------------------------------"
	echo
	echo "names of all features of the dataset file:"
	echo	
         for i in `cat dataset.txt`
           do
             echo $i | tr ";" '\11'
           done
	echo    
	echo "--------------------------------------------------------"
   else
     echo "You must first read a dataset from a file"
    fi;;

#//////////////////////////////////////////////////////////////////////////////////////////////
l)
if [ $correctFormat -eq 0 ]
    then echo "correct format"
         echo "Please input the name of the categorical feature for label encoding"
	 read CatFeature
         if [ "$CatFeature" == "gender" -o "$CatFeature" == "active" -o "$CatFeature" == "smoke" -o "$CatFeature" == "governorate" ]
   	    then echo "correct categorical feature"
	    
	 else
	    echo "the name of categorical feature is wrong"
         fi 
else
  echo "You must first read a dataset from a file"


fi;;   	
#//////////////////////////////////////////////////////////////////////////////////////////////
s)   if [ $correctFormat -eq 0 ] 
      then
	echo "Please input the name of dataset file"
        read saveFile
        cat dataset.txt > $saveFile
        savedValue=0
	echo "processed dataset was saved successfully"
     else
       echo "You must first read a dataset from a file"
     fi;;
#//////////////////////////////////////////////////////////////////////////////////////////////

e)

if [ $correctFormat -eq 0 ]
 then 
  if [ $savedValue -eq 0 ]
      then
	   echo "Are you sure you want to exist"
	   read saveOption
           if [ "$saveOption" == "yes" ]
             then break	
           fi
    else
	   echo "The processed dataset is not saved.Are you sure you want to exist"
           read saveOption
           if [ "$saveOption" == "yes" ]
             then break 	
           fi

    fi
else
   echo "You must first read a dataset from a file"

fi;;

#//////////////////////////////////////////////////////////////////////////////////////////////

*) echo "Invalid option,please try agein";;

esac

done
