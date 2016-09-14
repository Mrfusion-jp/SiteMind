#!/bin/bash

	source env.bash

taxonomy(){
	echo -e "Domain~$DOMAIN~whois"
	echo -e "Creation Date~$CREATION_DATE~whois"
	echo -e "Registrant Name~$REGISTRANT_NAME~whois"
	echo -e "Tech Name~$TECH_NAME~whois"
	echo -e "Admin Name~$ADMIN_NAME~whois"
	echo -e "Registrant Organization~$REGISTRANT_ORGANIZATION~whois"
	echo -e "Tech Organization~$TECH_ORGANIZATION~whois"
	echo -e "Admin Organization~$ADMIN_ORGANIZATION~whois"
	echo -e "Registrant Email~$REGISTRANT_EMAIL~whois"
	echo -e "Admin Email~$ADMIN_EMAIL~whois"
	echo -e "Tech Email~$TECH_EMAIL~whois"
	echo -e "Registrant Country~$REGISTRANT_COUNTRY~whois"
	echo -e "Tech Country~$TECH_COUNTRY~whois"
	echo -e "Admin Country~$ADMIN_COUNTRY~whois"	
}

menu_item(){
	echo -e "          <ul class='"nav nav-sidebar"'>"
	echo -e "            <li><a href=scorecard.html>scorecard</a></li>"
	echo -e "            <li><a href=overview.html>overview<span class=sr-only>(current)</span></a></li>"
	echo -e "            <li><a href=traffic.html>traffic</a></li>"
	echo -e "            <li><a href=upstream.html>upstream</a></li>"
	echo -e "            <li><a href=blacklist.html>blacklist</a></li>"
	echo -e "            <li class="active"><a href=whois.html>whois</a></li>"
	echo -e "          </ul>"
	echo -e "        </div>"
}

create_row(){
	echo -e "        <div class='"col-md-offset-2 main"'>"
	echo -e "          <div class='"row placeholders"'>"
}

domain(){
	echo -e "            <div class='"col-xs-4 col-sm-3 placeholder"'>"
	echo -e "          <h2>"$DOMAIN"</h2>"
	echo -e "              <span class="text-muted"><a href=http://"$DOMAIN" target="_blank">visit site</a></span>"
	echo -e "            </div>"
}

scoring(){
	echo -e "            <div class='"col-sm-5 placeholder"'>"
	SCORING=$(echo -e "scale=2; 1 - ($CHECK_TRUE / $CHECKS_TOTAL)" | bc -l | sed 's/.//' | sed 's/.00/100/')
	echo -e "				<h1>"$SCORING"</h1>"
}

summary(){
	SUMMARY=$(echo -e "failed $CHECK_TRUE out of $CHECKS_TOTAL checks")
	echo -e "              <span class="text-muted">"$SUMMARY"</span>"
	echo -e "            </div>"
	echo -e "            <div>"
}

scoring_reference(){

	## creating the scoring reference

	ZEROZEROFOUR=50
	ZEROZEROTHREE=50
	ZEROZEROTWO=70
	ZEROZEROONE=90

	if [ $SCORING -le $ZEROZEROFOUR ]
		then
			echo -e "   		<div class="holder-image"><img class="meter-image" src="./graphics/004.jpeg"></div>"
			echo -e "              <span class="text-muted">not safe to buy</span></div>"
		elif [ $SCORING -ge $ZEROZEROONE ]
			then
			echo -e "   		<div class="holder-image"><img class="meter-image" src="./graphics/001.jpeg"></div>"
			echo -e "              <span class="text-muted">may be safe to buy</span>"
		elif [ $SCORING -ge $ZEROZEROTWO ]
			then
			echo -e "   		<div class="holder-image"><img class="meter-image" src="./graphics/002.jpeg"></div>"
			echo -e "             <span class="text-muted">likely to have issues</span>"
		elif [ $SCORING -ge $ZEROZEROTHREE ]
			then
			echo -e "   		<div class="holder-image"><img class="meter-image" src="./graphics/003.jpeg"></div>"
			echo -e "              <span class="text-muted">high risk</span>"
		fi 

	echo -e "            </div>"	
	echo -e "          </div>"
	echo -e "         </div>"

}

main_content(){
	echo -e "				<div class='col-md-offset-2 main'>"
	echo -e "				<div class="row">"
	echo -e "				<div class="col-sm-12">"
	echo -e "				<table class='table table-striped'>"
	echo -e "              <thead>"
	echo -e "                <tr>"
	echo -e "                  <th>Item</th>"
	echo -e "                  <th>Value</th>"
	echo -e "                  <th>Source</th>"
	echo -e "                </tr>"
	echo -e "              </thead>"
	echo -e "              <tbody>"

while read ITEM
	do
		NAME=$(echo "$ITEM" | cut -d '~' -f1)
		RESULT=$(echo "$ITEM" | cut -d '~' -f2)
		SOURCE=$(echo "$ITEM" | cut -d '~' -f3)

		echo -e "                <tr>"
		echo -e "                  <td>"$NAME"</td>"
		echo -e "                  <td><b>"$RESULT"</b></td>"
		echo -e "                  <td><i>"$SOURCE"</i></td>"
		echo -e "                </tr>"

done <taxonomy_data.temp

	echo -e "\n"
}

	## P R O G R A M   S T A R T S

	cat ./templates/header.html			# builds the header of the page
	taxonomy > taxonomy_data.temp
	menu_item
	create_row
	domain
	scoring
	summary
	scoring_reference
	main_content
	cat ./templates/footer.html 			# builds the footer of the page
