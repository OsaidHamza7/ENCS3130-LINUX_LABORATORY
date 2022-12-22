dos="True"
savedValue=0
correctFormat=0
gg=1
vv=1
aa=1
ss=1
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
	if [ -e $FileName ];then
		 echo "file does exist"
               firstLine=$(sed -n 1p dataset.txt)
	       secondLine=$(sed -n 2p dataset.txt)
		a=$(echo $firstLine | tr ";" "\n" | wc -l)
	       b=$(echo $secondLine | tr ";" "\n" | wc -l)
	      	if [ $a -eq $b ];then
		       echo "The format of the data in the dataset file is verified correctly"
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
	echo "correct format"
        echo "--------------------------------------------------------"
	echo
	echo "names of all features of the dataset file:"
	echo
         for i in `cat CopyDataset.txt`
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
if [ $correctFormat -eq 1 ];then
	 echo "Please input the name of the categorical feature for label encoding"
    	 read CatFeature
     	checkFeature=$(sed -n 1p CopyDataset.txt| grep "$CatFeature"|wc -c)
      	if [ $checkFeature -gt 0 ];then
			echo "correct categorical feature"
       			sed -n 1p dataset.txt | tr ";" "\12" > f.txt
       			i=1
       			for j in `cat f.txt`
       			do
       			     if [ "$j" == "$CatFeature" ]
				then break
			     fi
				i=$(( i + 1 ))
	   		done
         
	     		     cat CopyDataset.txt | cut -d";" -f"$i"> column.txt
			     cat column.txt > copy.txt
	     		     cat -n column.txt | sort -uk2 | sort -n | cut -f2- > Temp
			     mv Temp column.txt
			     value=-1
                             for c in `cat column.txt`
                             do	  if [ $value -ge 0 ];then
                                   echo "$c:$value"
                                   sed "s/^$c/$value/" copy.txt > temp
                                   mv temp copy.txt
				  fi
                                   value=$(( value + 1 ))
                             done
			   cat CopyDataset.txt | tr ";" "\11" > dota.txt			  
			   readarray -t re < copy.txt
			   awk 'NR == FNR {a[FNR] = $B;next}{$A = a[FNR]; print}' B=1 A=$i "copy.txt" "dota.txt"  > "file3.txt"
			
			   
			

	else echo "wrong categorical feature"
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
			   gg=0
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
			   aa=0
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
			   ss=0
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
			     vv=0
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

#/////////////////////////////////////////////////////////////////////
m)  if [ $correctFormat -eq 0 ]
	then echo "Please input the name of the feature to be scaled"
	    read Feature
                case $Feature in
		"gender")if [ $gg -eq 0 ]
			    then echo "correct" 
                         else echo "this feature is categorical feature and must be ecnocded first"			
                         fi;;
    
		"active") 
			if [ $aa -eq 0 ]
                            then echo "correct" 
			 else echo "this feature is categorical feature and must be ecnocded first"
			fi;;
		
		"smoke")if [ $ss -eq 0 ]
                            then echo "correct" 
			else echo "this feature is categorical feature and must be ecnocded first"
			fi;;

		"governorate")if [ $vv -eq 0 ]
				then echo "correct"
			      else echo "this feature is categorical feature and must be encoded first"
			      fi;;
		

		esac
   else echo "You must first read a dataset from a file" 
    fi;;

#//////////////////////////////////////////////////////////////////////////////////////////////
s)   if [ $correctFormat -eq 1 ]
      then
	echo "Please input the name of dataset file"
        read saveFile
        cat dataset.txt > $saveFile
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

