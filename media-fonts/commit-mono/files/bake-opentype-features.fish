#!/usr/bin/env fish
set -l options 'srcPath=?' 'localPath=?' 'inputFontFormat='
argparse $options -- $argv

set command /usr/bin/pyftfeatfreeze

# echo this is the pwd
# echo $PWD
for font in "$_flag_srcPath"/*."$_flag_inputFontFormat"
  # This enables those flags, and gets the font filename (without the original font format) to save the font file
  $command -f 'ss03,ss04,ss05,cv02,cv06,cv10' -S -U Retblast -R 'CommitMonoV143/CommitMono' $font "$_flag_localPath"/(string replace "$_flag_inputFontFormat" "" (string replace "$_flag_srcPath" "" $font))-Retblast."$_flag_inputFontFormat"

  # Delete the original fonts
  rm $font
end