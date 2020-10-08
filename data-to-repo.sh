#!/bin/zsh
CURR_DIR=$(pwd)
PROJ_ROOT=/Users/brtonnies/ArtificialIntelligence/face-mask-detection
cd $PROJ_ROOT || null

IMAGES=/Users/brtonnies/ArtificialIntelligence/semester-project/data/images
IMAGES_DEST=/Users/brtonnies/ArtificialIntelligence/face-mask-detection/data/images
ANNOTATIONS=/Users/brtonnies/ArtificialIntelligence/semester-project/data/annotations
ANNOTATIONS_DEST=/Users/brtonnies/ArtificialIntelligence/face-mask-detection/data/annotations

# do images, 100 at a time
cd $IMAGES || null
NUM_IMAGES=$(find $IMAGES -type f | wc -l)
START=433
END=533

while [[ $END -le $NUM_IMAGES ]]; do
  echo "Start At File # $START"
  echo "End At File # $END"
  for n in {$START..$END}; do
    if [[ $n -lt 10 ]]; then
      ZEROES="000"
    elif [[ $n -lt 100 ]]; then
      ZEROES="00"
    elif [[ $n -lt 1000 ]]; then
      ZEROES="0"
    else
      ZEROES=""
    fi

    f=$(find . -type f -name "$ZEROES$n\.*")
    fpath="$IMAGES/${f:2}"
    dest="$IMAGES_DEST/${f:2}"
    if [[ -f "$fpath" ]]; then
      cp "$fpath" "$dest"
    fi
  done

  $(git add .)
  $(git commit -am "adding images $START -> $END to repository")
  $(git push --set-upstream origin master)

  if [[ ${END+100} -gt $NUM_IMAGES ]]; then
    END=$NUM_IMAGES
  else
    END=$((END+100))
  fi

  if [[ ${START+100} -gt $NUM_IMAGES ]]; then
    START=$NUM_IMAGES
  else
    START=$((START+100))
  fi
done

cd $PROJ_ROOT || null
