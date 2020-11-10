#!/bin/zsh
CURR_DIR=$(pwd)
PROJ_ROOT=/Users/brtonnies/ArtificialIntelligence/face-mask-detection
OLD_IMG_DIR=/Users/brtonnies/ArtificialIntelligence/images
cd $PROJ_ROOT || null

IMAGES=/Users/brtonnies/ArtificialIntelligence/face-mask-detection/data/images
IMAGES_DEST=/Users/brtonnies/ArtificialIntelligence/face-mask-detection/data/images
ANNOTATIONS=/Users/brtonnies/ArtificialIntelligence/face-mask-detection/data/annotations
ANNOTATIONS_DEST=/Users/brtonnies/ArtificialIntelligence/face-mask-detection/data/annotations

CMFD_ROOT=/Users/brtonnies/ArtificialIntelligence/face-mask-detection/data/images/IMFD
CMFD_IMAGES_ROOT="$CMFD_ROOT/images"
CMFD_ERROR_ROOT="$CMFD_ROOT/error"

# first up is images
cd $OLD_IMG_DIR || null
#NUM_DIRS=$(find "$OLD_IMG_DIR" -maxdepth 0 -type d | wc -l)
#
#NUM_IMAGES=0
#for i in */ ; do
#    echo -n $i": " ;
#    RES=$(find "$i" -type f | wc -l) ;
#    echo $RES
#    NUM_IMAGES=$((NUM_IMAGES + RES)) ;
#done


NUM_IMAGES=$(find $OLD_IMG_DIR -type f | wc -l)
START=0
END=$((START + 100))


#find $CMFD_IMAGES_ROOT/* -maxdepth 1 -mindepth 1 -type d | while (read dir && $END -lt $NUM_IMAGES); do
#  find "$dir" -type f | while (read f && $START -lt $END); do
#    echo "$f"
#  done
#done

cd $OLD_IMG_DIR || null
while [[ $END -lt $NUM_IMAGES ]]; do
    cd $OLD_IMG_DIR || null
    echo "Start At File # $START"
    echo "End At File # $END"

    for n in {$START..$END}; do
      if [[ $n -lt 10 ]]; then
        ZEROES="0000"
      elif [[ $n -lt 100 ]]; then
        ZEROES="000"
      elif [[ $n -lt 1000 ]]; then
        ZEROES="00"
      elif [[ $n -lt 10000 ]]; then
        ZEROES="0"
      else
        ZEROES=""
      fi

#      echo "Checking for file name $ZEROES$n\_Mask"

      f=$(find . -type f -name "$ZEROES$n\_Mask*\.*")
      fpath="$OLD_IMG_DIR/${f:2}"
      dest="$CMFD_IMAGES_ROOT/${f:2}"
#      echo "$fpath"
#      echo "$dest"
      if [[ -f "$fpath" ]]; then
        cp "$fpath" "$dest"
#        echo "would copy $fpath to $dest"
      fi
    done
#            done



    cd $PROJ_ROOT || null
#    echo "Would add images $START -> $END to repository"
    git add .
    git commit -am "adding IMFD images $START -> $END to repository"
    git push -u origin main

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
#cd $ANNOTATIONS || null
#NUM_ANNOT=$(find $ANNOTATIONS -type f | wc -l)
#NUM_ANNOT=$((NUM_ANNOT + 1801))
#START=1801
#END=1901
#
#while [[ $END -lt $NUM_ANNOT ]]; do
#  echo "Start At File # $START"
#  echo "End At File # $END"
#  for n in {$START..$END}; do
#
#    cd $ANNOTATIONS
#    f=$(find . -type f -name "$n\.*")
#    echo $f
#    fpath="$ANNOTATIONS/${f:2}"
#    dest="$ANNOTATIONS_DEST/${f:2}"
#    if [[ -f "$fpath" ]]; then
#      cp "$fpath" "$dest"
#    fi
#  done
#
#  cd $PROJ_ROOT || null
#  git add .
#  git commit -am "adding annotations $START -> $END to repository"
#  git push -u origin main
#
#  if [[ $((END + 100)) -gt $NUM_ANNOT ]]; then
#    END=$NUM_ANNOT
#  else
#    END=$((END + 100))
#  fi
#
#  if [[ $((START + 100)) -gt $NUM_ANNOT ]]; then
#    START=$NUM_ANNOT
#  else
#    START=$((START + 100))
#  fi
#done
