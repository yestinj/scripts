#!/bin/sh
TARGET_DIR=$1
TV_SHOW_DIR_PATH="/Users/yestin/Downloads/tvshows"
#for path in $( find $TARGET_DIR -iname '*.mkv' | tr ' ' . );
IFS=$'\n'; for path in $( find $TARGET_DIR -iname '*.mkv' );
do
  #echo Path is $path
  showname=""
  seasonnum="Season"  
  IFS='.'; for word in $path;
    do
      #echo $word
      if [ -n "$showname" ]; then
        if [[ $word == s* ]] || [[ $word == S* ]]; then
	  TMP=${word:1}
	  # If we've found the start of the season string, S[0-9]
	  if [[ $TMP == [0-9]* ]]; then
	    seasonnum="$seasonnum ${TMP:0:1}"
	    TMP=${TMP:1}
	    if [[ $TMP == [0-9]* ]]; then
	      seasonnum="$seasonnum${TMP:0:1}"
	    fi
            #echo "Season number $seasonnum"
	    break
	  else
	    showname="$showname $word"
	  fi
        else
          showname="$showname $word"
	fi
      else 	      
        showname=$( echo $word | sed 's/.*\///' )
      fi
    done
    if [[ $showname == "Naruto Shippuuden"* ]] || [[ $showname == "Fariy Tail"* ]]; then
      continue
    fi
  IFS=$'\n'
  echo TV Shows name is: $showname
  echo Season is: $seasonnum
  echo $path
  DEST_PATH="$TV_SHOW_DIR_PATH/$showname/$seasonnum/"
  echo "Destination path is $DEST_PATH"
  if [ ! -d "$DEST_PATH" ]; then
    read -p "Directory doesn't exist, create it? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      CREATE_DIR_CMD="mkdir -p \"$DEST_PATH\""
      eval $CREATE_DIR_CMD 
    fi
  fi
  CMD="mv -v \"$path\" \"$DEST_PATH\""
  read -p "Run command $CMD? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    eval $CMD
  fi
done
