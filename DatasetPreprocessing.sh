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
		First=$(grep "^1;" dataset.txt)
		case $CatFeature in

		   "gender")
		    	   Gen=$(echo "$First" | cut -d';' -f3)
		           echo $Gen
                          if [ "$Gen" == "male" ]
				echo "male:0 , female:1"
				then sed 's/;male/;0/;s/female/1/' dataset.txt > Gen.txt
			   else
				  echo "female:0 , male:1"
				  sed 's/;male/;1/;s/female/0/' dataset.txt > Gen.txt
			  fi;;

                   "active")
                           Act=$(echo "$First" | cut -d';' -f6)
                           echo $Act
                          if [ "$Act" == "yes" ]
                                then
					echo "yes:0 , no:1"
	sed 's/yes;yes/0;yes/;s/no;no/1;no/;s/yes;no/0;no/;s/no;yes/1;yes/' dataset.txt > Act.txt
              		  else
				echo "no:0 , yes:1"
	sed 's/yes;yes/1;yes/;s/no;no/0;no/;s/yes;no/1;no/;s/no;yes/0;yes/' dataset.txt > Act.txt    
                          fi;;
	
                   "smoke")
                           Smk=$(echo "$First" | cut -d';' -f7)
                           echo $Smk
                          if [ "$Smk" == "yes" ]
     				then
				    echo "yes:0 , no:1"
			            sed 's/yes;yes/yes;0/;s/no;no/no;1/;s/yes;no/yes;1/;s/no;yes/no;0/' dataset.txt > Smk.txt
			  else
				echo "no:0 , yes:1"
  				sed 's/yes;yes/yes;1/;s/no;no/no;0/;s/yes;no/yes;0/;s/no;yes/no;1/' dataset.txt > Smk.txt
                          fi;;
		"governorate")
			     Gover=$(cat dataset.txt | cut -d';' -f8 )
			     echo "$Gover" | tr ' ' '\12' | sed '1d' > test.txt 
			     cat -n test.txt | sort -uk2 | sort -n | cut -f2- > TEST
			     mv TEST test.txt
			     cat dataset.txt > CopyDataset.txt
			     value=0
			     for  i in `cat test.txt`
				do
				   echo "${i}:${value}"
				   sed "s/${i}/${value}/" CopyDataset.txt > temp
				   mv temp CopyDataset.txt
				   value=$(( value + 1 ))
				done
				cat CopyDataset.txt > Gover.txt
			     ;;
		esac
	 else
	    echo "the name of categorical feature is wrong"
         fi
else
  echo "You must first read a dataset from a file"

fi;;
#//////////////////////////////////////////////////////////////////////////////////////////////////
o)if [ $correctFormat -eq 0 ]
    then echo "correct format"
         echo "Please input the name of the categorical feature for label encoding"
         read CatFeature
       	     if [ "$CatFeature" == "gender" -o "$CatFeature" == "active" -o "$CatFeature" == "smoke" -o "$CatFeature" == "governorate" ]
                then echo "correct categorical feature"
                First=$(grep "^1;" dataset.txt)
                case $CatFeature in

                   "gender")
                           Gen=$(echo "$First" | cut -d';' -f3)
                           echo $Gen
                          if [ "$Gen" == "male" ]
                                echo "male:1;0 , female:0;1"
                                then sed 's/;male/;1;0/;s/female/0;1/' dataset.txt > Gen.txt
                           else
                                  echo "female:1;0 , male:0;1"
                                  sed 's/;male/;0;1/;s/female/1;0/' dataset.txt > Gen.txt
                          fi;;

                   "active")
                           Act=$(echo "$First" | cut -d';' -f6)
                           echo $Act
                          if [ "$Act" == "yes" ]
                                then  
                                        echo "yes:1;0 , no:0;1"
				        sed 's/yes;yes/1;0;yes/;s/no;no/0;1;no/;s/yes;no/1;0;no/;s/no;yes/0;1;yes/' dataset.txt > Act.txt
                          else
                                echo "no:1;0 , yes:0;1"
  				sed 's/yes;yes/0;1;yes/;s/no;no/1;0;no/;s/yes;no/0;1;no/;s/no;yes/1;0;yes/' dataset.txt > Act.txt    
                          fi;;

                   "smoke")
                           Smk=$(echo "$First" | cut -d';' -f7)
                           echo $Smk
                          if [ "$Smk" == "yes" ]
                                then
                                        echo "yes:1;0 , no:0;1"
				        sed 's/yes;yes/1;0;yes/;s/no;no/0;1;no/;s/yes;no/1;0;no/;s/no;yes/0;1;yes/' dataset.txt > Act.txt
                          else
                                echo "no:1;0 , yes:0;1"
 			        sed 's/yes;yes/0;1;yes/;s/no;no/1;0;no/;s/yes;no/0;1;no/;s/no;yes/1;0;yes/' dataset.txt > Act.txt  
                          fi;;

                "governorate")
                             Gover=$(cat dataset.txt | cut -d';' -f8 )
                             echo "$Gover" | tr ' ' '\12' | sed '1d' > test.txt 
                             cat -n test.txt | sort -uk2 | sort -n | cut -f2- > TEST
                             mv TEST test.txt
			     Number=$(wc -l test.txt | cut -c 1)
			     echo "Number is :${Number}"
			     zeros=""
			     while [ "$Number" -gt 0 ]
				do
				  zeros+="0;"
			          Number=$((Number - 1 ))
				done
			     echo "${zeros}" > zeros.txt
                             cat dataset.txt > CopyDataset.txt
			     n=1
                             for  i in `cat test.txt`
                                do
				  value=$(sed "s/0/1/${n}" zeros.txt)
                                   echo "${i}:${value}"
                                   sed "s/${i};/${value}/" CopyDataset.txt > temp
                                   mv temp CopyDataset.txt
                                   n=$(( n + 1 ))
                                done
                                cat CopyDataset.txt > Gover.txt
                             ;;

                esac
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

*) echo "Invalid option,please try again"
esac

done

