#!/bin/bash

# Function that prints help message
usage () {
echo "${GREEN}""Usage:${RESET} ./scripts/$0 \

" 1>&2; exit 0; }

# Make your terminal text output beautiful <3
# The following variables are used to define the color in the functions below
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr 0)

showdate () {
	local DATE
	DATE=$(date "+%F %T")
	printf "$DATE"
}

err () {
	local DATE
	DATE=$(showdate)
	printf "[$DATE][${RED}ERROR${RESET}]: $1\n" 1>&2
}

warn () {
	local DATE
	DATE=$(showdate)
	printf "[$DATE][${YELLOW}WARNING${RESET}]: $1\n"
}

inf () {
	local DATE
	DATE=$(showdate)
	printf "[$DATE][INFO]: $1\n"
}

succ () {
	local DATE
	DATE=$(showdate)
	printf "[$DATE][${GREEN}SUCCESS${RESET}]: $1\n"
}

rprog () {
	rsync -ah --progress $@
}

happy-snake-ascii () {
inf "Starting hap.py"
cat << "EOF"


       L$$$$$$$}`              
     $           `$$;          
     $.             ;$$        
      $+               $$i     
       h$        k$$     }$k   
         $\      h$$       .$$\
           $$                  
             $$.               
              +$$$;            
             $h   ;$$$`        
          \$i           '$$i   
        k$i    $l      k$i     
     L$$    _$l     `$$'       
 u$$v     -i$    +$$/          
.$$+.         $$$`             
  ;$$i       .ik$$$$$$$;       
     '/$$$$$/;         _$$`    
                          _$$$\


EOF
}
