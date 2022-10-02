#!/bin/bash
# script based on https://github.com/graysky2/newsboat_custom_stuff 's stable-review.sh script

target="https://shadowverse.com/news/"
mapfile -t items < <(lynx -dump -listonly "$target" | grep "announce" | sed "s|.*${target}?announce_id=||" | uniq )

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
	<channel>
		<title>Shadowverse News</title>
		<link>$target</link>
EOF
{
	for i in "${items[@]}"; do
		title=$(curl "${target}?announce_id=$i" -so - | grep -iPo '(?<=<title>)(.*)(?=</title>)')
		echo "    <item>"
		echo "      <title>$title</title>"
		echo "      <link>${target}?announce_id=$i</link>"
		echo "    </item>"
	done
	echo '  </channel>'
	echo '</rss>' 
}
