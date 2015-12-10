#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage: ./show_shorter.sh [TARGET_DIRECTORY] [DESTINATION_DIRECTORY]"
  exit 1
fi
TARGET_DIR=$1
TV_SHOW_DIR_PATH=$2
# Iterate over each tv shows found, we assume no spaces in the show name.
# TODO: Handle if there is.
for path in $( find $TARGET_DIR -iname '*.mkv' | tr ' ' . );
do
  #echo Path is: $path
  # If it's anime, this check works for now..
  if [[ $path == *HorribleSubs* ]]; then
    # TODO: Add proper sorting logic for anime >_<
    echo Detected anime in path, continuing to next file... 
    continue
  fi  
  # Initialise these appropriately for population below, and use even further below.
  showname=""
  seasonnum=""  
  # Iterate over the words in the path, separated by periods "."
  IFS='.'; for word in $path;
  do
    #echo Word in path is: $word
    # To make things easier, always capitalize the first letter, if it's a letter
    fl_word=${word:0:1}
    if [[ ${fl_word} == [a-z] ]]; then
      word=`echo $fl_word | tr '[a-z]' '[A-Z]'`${word:1}  
    fi
    # If the show name is not empty, then handle it differently.
    if [ -n "$showname" ]; then
      # If word starts with an S check if it's the season string.
      # If the word looks like the 9x1 style of episode numbering
      #if [[ $word =~ '[1-9][0-9]{0,2}x[0-9]+' ]]; then
        #echo Caught something of the weird episode number form: $word
        # strip out just the season number
        #seasonnum=`echo $word | cut -d"x" -f1`      
      if [[ ${word:0:1} == [0-9] ]]; then
        # If the word has 3 or more characters, and the next one is an x
        if [[ ${#word} -gt 2 ]] && [[ ${word:1:1} == x ]]; then
          seasonnum=${word:0:1}
          break
        fi
      elif [[ $word == S* ]]; then
	      TMP=${word:1}
	      # If we've found the start of the season string, S[0-9]
	      if [[ $TMP == [0-9]* ]]; then
	        seasonnum="$seasonnum${TMP:0:1}"
	        TMP=${TMP:1}
	        # if there's another digit in the season number.
          if [[ $TMP == [0-9]* ]]; then
	          seasonnum="$seasonnum${TMP:0:1}"
	        fi
          # Assume no more than two digit season numbers...
          # TODO: Add something to loop / recurse to allow for more.
	        break # Break here, found the full season number, no need to continue parsing words in the path.
	      else
	        # If this word is not the start of a season string, simply concat word to showname
          showname="$showname $word"
	      fi
      else
        # Again, if word is not start of season string, doesn't start with s or S just concat.
        showname="$showname $word"
	    fi
    else 	      
      # First iter, strip path up to last '/' to leave with just first word in the show name
      word=$( echo $word | sed 's/.*\///' )
      # Always capitalize the first letter, if it's a letter
      fl_word=${word:0:1}
      if [[ ${fl_word} == [a-z] ]]; then
        word=`echo $fl_word | tr '[a-z]' '[A-Z]'`${word:1}
      fi
      showname=$word
    fi
  done
  # Finished iterating words in the show name, we should have show name and season number by now.    
  # Only proceed if the show name is non=empty.
  if [ -n "$showname" ]; then
    # Reset IFS to the default
    unset IFS
    echo Path: $path
    echo TV Shows name is: $showname
    echo Season is: $seasonnum  
    if [[ ${#seasonnum} == 1 ]]; then
      seasonnum=0$seasonnum
    fi
    seasonnum="Season $seasonnum"
    echo Season is: $seasonnum
    # Prepare the destination path to move the file to
    DEST_PATH="$TV_SHOW_DIR_PATH/$showname/$seasonnum/"
    echo "Destination path is $DEST_PATH"
    if [ ! -d "$DEST_PATH" ]; then
      read -p "Directory doesn't exist, create it? " -n 1 -r
      echo    # move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        CREATE_DIR_CMD="mkdir -vp \"$DEST_PATH\""
        eval $CREATE_DIR_CMD 
      fi
    fi
    # Make sure the directory now exists before giving the option to move to it
    if [ -d "$DEST_PATH" ]; then
      CMD="mv -v \"$path\" \"$DEST_PATH\""
      read -p "Run command $CMD? " -n 1 -r
      echo    # move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        eval $CMD
      fi
    fi    
  fi
done
