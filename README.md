# Retblast's overlay
This houses some packages that I use, and are not in the GURU or Gentoo's repositories.

# Workflow
After creating the ebuild, do
```
  pkgdev manifest -d $distfilesFolder $ebuild
  ebuild $ebuild clean test install
  ebuild clean install merge
```
If stuff works fine, can be pushed to the repo.