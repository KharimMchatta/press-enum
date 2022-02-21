#! /bin/bash
 
read -p 'enter the website you want to scan: ' url

echo ''
echo ''
echo ''

echo "----------user enumeration via rest api-------------------"

curl -s https://$url/wp-json/wp/v2/users | jq -r 'map({id: .id, name: .name, slug: .slug})'


echo ''
echo ''
echo ''
echo "----------user enumeration via rest route----------------"

curl -s https://$url/?rest_route=/wp/v2/users | jq -r 'map({id: .id, name: .name, slug: .slug})'

echo ''
echo ''
echo ''
echo "----------- sitemap xml user url ----------------------------"

curl -s https://$url/author-sitemap.xml grep "<loc>" | awk -F"<loc>" '{print $2} ' | awk -F"</loc>" '{print $1}' 
