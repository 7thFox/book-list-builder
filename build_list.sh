lookup() {
	[ -z "$1" ] && echo "No ISBN given" && exit 1
	url="https://openlibrary.org/api/books?bibkeys=ISBN:$1&format=json"
	path=".\"ISBN:$1\".info_url"
	info=$(curl -s $url | jq -r $path)
	([ "$info" == "null" ] || [ -z "$info" ]) && echo "ISBN not found." && exit 1
	curl -s $(echo $info | sed 's|\(.*\)/.*|\1.json|')
}

format_line() {
	json=$(lookup "$1")
	[ ${PIPESTATUS[0]} -ne 0 ] && echo $json && exit 1
	echo $json \
		| jq -r '.lc_classifications[0], .title, .edition_name, .by_statement, .publish_date, .publishers[0]' \
		| awk -vRS="\n" -vORS="|" '1'\
		| awk 'BEGIN{RS="";FS="|";ORS=""} {print $1 "\t" $2 } {if ($3 != "null") print " ("$3 ")"} { print " -" } {if ($4 != "null") print " " $4}{if ($6 != "null") print " " $6 }{if ($5 != "null") print " " $5 } { print "\n" }'
}

format_all() {
	[ -z $1 ] && echo "Enter file." && exit 1
	err="$1_errors.txt"
	echo "# Errors from run on $(date)" > $err
	(while IFS= read -r line; do
		isbn=$(echo $line | sed 's|\(.*\)#.*|\1|')
		[ -z $isbn ] && continue
		formatted=$(format_line $isbn)
		[ ${PIPESTATUS[0]} -eq 0 ] && echo "$formatted"\
       			|| echo "$line" >> $err
	done < "$1") | sort
}

[ -z $1 ] && echo "Input file required." && exit 1
[ -z $2 ] && echo "Output file required." && exit 1

format_all $1 > $2
echo "Done."
