#!/bin/bash

echo "Enter file to read URLs:"
read file
echo ""
echo "Enter search string:"
read string

while read line
do
    name=$line
    echo =============================================================================
    echo "$name" && echo "is js directly in page?" && echo "" && python find_da_JS.py "$name" |grep "$string"

	if [[ -n $(python find_da_JS.py "$name" |grep "$string") ]]; then
    		echo "(+) found the JS in the direct page"
	else
		echo ""
    		echo "JS is not in the direct page... checking for other scripts"
		echo "" 
		echo "" > srcscript.tmp
    		python srcsoup.py "$name" > srcscript.tmp
                	while read srcscript
                	do
                        	url=$srcscript
                        	domain=`echo $name | awk -F/ '{print $3}'`
                        	domainsrc=http://$domain$url
                        	echo $domainsrc
				if [[ -n $(python find_da_JS.py $domainsrc |grep "$string") ]]; then
					echo "(+) JS found in script"
					python find_da_JS.py $domainsrc |grep "$string"
				else
					echo "JS not found"
				fi
				echo ""
                	done < srcscript.tmp
	fi
    echo ""
done < $file

rm srcscript.tmp
