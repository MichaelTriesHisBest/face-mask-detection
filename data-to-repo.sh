#!/bin/zsh
CURR_DIR=$(pwd)
PROJ_ROOT=/Users/brtonnies/ArtificialIntelligence/face-mask-detection
cd $PROJ_ROOT || null

IMAGES=/Users/brtonnies/ArtificialIntelligence/semester-project/data/images
IMAGES_DEST=/Users/brtonnies/ArtificialIntelligence/face-mask-detection/data/images
ANNOTATIONS=/Users/brtonnies/ArtificialIntelligence/semester-project/data/annotations
ANNOTATIONS_DEST=/Users/brtonnies/ArtificialIntelligence/face-mask-detection/data/annotations

# do images, 100 at a time
#cd $IMAGES || null
#NUM_IMAGES=$(find $IMAGES -type f | wc -l)
#START=3570
#END=3670
#
#while [[ $END -lt $NUM_IMAGES ]]; do
#  echo "Start At File # $START"
#  echo "End At File # $END"
#  for n in {$START..$END}; do
#
#    cd $IMAGES || null
#    if [[ $n -lt 10 ]]; then
#      ZEROES="000"
#    elif [[ $n -lt 100 ]]; then
#      ZEROES="00"
#    elif [[ $n -lt 1000 ]]; then
#      ZEROES="0"
#    else
#      ZEROES=""
#    fi
#
#    f=$(find . -type f -name "$ZEROES$n\.*")
#    fpath="$IMAGES/${f:2}"
#    dest="$IMAGES_DEST/${f:2}"
#    if [[ -f "$fpath" ]]; then
#      cp "$fpath" "$dest"
#    fi
#  done
#
#  cd $PROJ_ROOT || null
#  git add .
#  git commit -am "adding images $START -> $END to repository"
#  git push -u origin main
#
#  if [[ ${END+100} -gt $NUM_IMAGES ]]; then
#    END=$NUM_IMAGES
#  else
#    END=$((END+100))
#  fi
#
#  if [[ ${START+100} -gt $NUM_IMAGES ]]; then
#    START=$NUM_IMAGES
#  else
#    START=$((START+100))
#  fi
#done

#cd $PROJ_ROOT || null
cd $ANNOTATIONS || null
NUM_ANNOT=$(find $ANNOTATIONS -type f | wc -l)
NUM_ANNOT=$((NUM_ANNOT+1801))
START=1801
END=1901

while [[ $END -lt $NUM_ANNOT ]]; do
  echo "Start At File # $START"
  echo "End At File # $END"
  for n in {$START..$END}; do

    f=$(find $ANNOTATIONS -type f -name "$n\.*")
    echo $f
    fpath="$ANNOTATIONS/${f:2}"
    dest="$ANNOTATIONS_DEST/${f:2}"
    if [[ -f "$fpath" ]]; then
      cp "$fpath" "$dest"
    fi
  done

  cd $PROJ_ROOT || null
  git add .
  git commit -am "adding annotations $START -> $END to repository"
  git push -u origin main

  if [[ $((END+100)) -gt $NUM_ANNOT ]]; then
    END=$NUM_ANNOT
  else
    END=$((END+100))
  fi

  if [[ $((START+100)) -gt $NUM_ANNOT ]]; then
    START=$NUM_ANNOT
  else
    START=$((START+100))
  fi
done