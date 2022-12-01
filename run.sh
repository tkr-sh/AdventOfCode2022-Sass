# Choosing if this is with or without built-ins
firstpart=false;

while true; do
    printf 'Do you want to run the first part of the program ? [Y/n]\n>>>'
    read yn

    if [[ "$yn" = '' ]]; then
        firstpart=true;break;
    fi

    case $yn in
        [Yy]* ) firstpart=true; break ;;
        [Nn]* ) firstpart=false; break ;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Create the temp scss file and the temp STDOUT
touch temp.scss
touch STDOUT


# Adding the STDIN
cat ../use.scss >> temp.scss #Adding the use in the temp file
echo -n '$STDIN: "' >> temp.scss # Declare the variable STDIN
sed -E ':a;N;$!ba;s/\r{0,1}\n/\\a /g' STDIN >> temp.scss  # Replace \n by \\a[SPACE]
echo '";' >> temp.scss
cat ../functions.scss >> temp.scss


# If firstpart or not
if [[ $firstpart = true ]]; then
    cat first.scss >> temp.scss
else
    cat second.scss >> temp.scss
fi


# Execute the file
echo "===== Program ====="
sass temp.scss &> STDOUT


while read line; do
    echo $line | sed -r 's/temp\.scss\:[0-9]+\sDEBUG:\s//g'
done <STDOUT



# Remove the temporary file
rm temp.scss
rm STDOUT