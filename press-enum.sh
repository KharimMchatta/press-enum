#! /bin/bash

figlet -f standard Press-Enum

echo ''
echo '**********************************************************************************************************************************'
echo "*                                                                                                                                *"
echo "* Author: Kharim Mchatta                                                                                                         *"
echo "*                                                                                                                                *"
echo "* Tool-Name: Press - Enum                                                                                                        *"
echo "*                                                                                                                                *"
echo "* Version: 2.0                                                                                                                   *"
echo "*                                                                                                                                *"
echo "* Press-Enum is a script that enumerates for usernames from  Wordpress sites                                                     *"
echo "*                                                                                                                                *"
echo "* Disclaimer: the tool is not intended for malicious use, any malicious use of the tool shall not hold the author responsible.   *"
echo "*                                                                                                                                *"
echo "**********************************************************************************************************************************"

echo ""
echo ""
echo ""
echo ""

read -p 'enter the website you want to scan: ' url

echo ''
echo ''
echo ''
echo "----------- User enumeration via rest API ---------------------"

code=$(curl --write-out %{http_code} -s --output /dev/null  $url/wp-json/wp/v2/users)
 
if  [ "$code" -eq 200 ];
 
then

 curl -s $url/wp-json/wp/v2/users | jq -r 'map({id: .id, name: .name, slug: .slug})'


 elif [ "$code" -eq 400 ];
 
  then
  echo ""

  else
  echo ""
  echo "Rest API is disabled, the site returned error code $code"

fi



echo ''
echo ''
echo ''
echo "----------- User enumeration via rest route -------------------"

code=$(curl --write-out %{http_code} -s --output /dev/null  $url/wp-json/wp/v2/users)
 
if  [ "$code" -eq 200 ];
 
then

 curl -s $url/?rest_route=/wp/v2/users | jq -r 'map({id: .id, name: .name, slug: .slug})'


 elif [ "$code" -eq 400 ];
 
  then
  echo ""

  else
  echo ""
  echo "Rest API is disabled, the site returned error code $code"

fi



echo ''
echo ''
echo ''
echo "----------- User enumeration via author archive ---------------"

n=0

while [ "$n" -le 50 ] 

do

curl -isL $url/?author=$n | grep "og:url" | grep -Eo "(https)://[a-zA-Z0-9./?=_%:-]*" | grep "author" | uniq

((n++))

done

echo ''
echo ''
echo ''
echo "----------- User enumeration via feeds ------------------------"

curl -s $url/feed/ | grep -Eo "(https)://[a-zA-Z0-9./?=_%:-]*" | grep "author" |tee -a 

echo ''
echo ''
echo ''
echo "----------- Sitemap xml user url ----------------------------"

curl -s $url/author-sitemap.xml | grep "<loc>" | awk -F"<loc>" '{print $2} ' | awk -F"</loc>" '{print $1}'

echo ''
echo ''
echo ''
echo "----------- XMLRPC STATUS ---------------------"

code=$(curl --write-out %{http_code} -s --output /dev/null  $url/xmlrpc.php)
 
if  [ "$code" -eq 405 ];
 
then

curl $url/xmlrpc.php

echo ''
echo ''
echo ""
echo "Starting XMLRP Method Listings"

curl -X POST -d "<?xml version="1.0" encoding="utf-8"?><methodCall><methodName>system.listMethods</methodName><params></params></methodCall>" $url/xmlrpc.php

 elif [ "$code" -eq 403 ];
 
  then
  echo ""

  else
  echo ""
  echo "XMLRPC is disabled"

fi
