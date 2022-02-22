#! /bin/bash

figlet -f standard Press-Enum

echo ''
echo '**********************************************************************************************************************************'
echo "*                                                                                                                                *"
echo "* Author: Kharim Mchatta                                                                                                         *"
echo "*                                                                                                                                *"
echo "* Tool-Name: Press - Enum                                                                                                        *"
echo "*                                                                                                                                *"
echo "* Version: 1.0                                                                                                                   *"
echo "*                                                                                                                                *"
echo "* Wpenum is a script that enumerates for usernames from  Wordpress sites                                                         *"
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

curl -s https://$url/wp-json/wp/v2/users | jq -r 'map({id: .id, name: .name, slug: .slug})'


echo ''
echo ''
echo ''
echo "----------- User enumeration via rest route -------------------"

curl -s https://$url/?rest_route=/wp/v2/users | jq -r 'map({id: .id, name: .name, slug: .slug})'


echo ''
echo ''
echo ''
echo "----------- User enumeration via author archive ---------------"

n=0

while (($n<=200)) do

curl -isL https://$url/?author=$n | grep "og:url" | grep -Eo "(https)://[a-zA-Z0-9./?=_%:-]*" | grep "author" | uniq

((n++))

done

echo ''
echo ''
echo ''
echo "----------- User enumeration via feeds ------------------------"

curl -s https://$url/feed/ | grep -Eo "(https)://[a-zA-Z0-9./?=_%:-]*" | grep "author" |tee -a 

echo ''
echo ''
echo ''
echo "----------- Sitemap xml user url ----------------------------"

curl -s https://$url/author-sitemap.xml | grep "<loc>" | awk -F"<loc>" '{print $2} ' | awk -F"</loc>" '{print $1}'

