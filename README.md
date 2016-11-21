# clean_jpgs.sh

Simple bash script to remove JPG files from a directory where a matching (same file name, with the RAW extension) exists.

## Usage

```
Usage: clean_jpgs.sh [-hvd] [-r RAW_EXT] [-j JPG_EXT] DIR
Recursively removes JPG files from DIR when a RAW file with the same filename (different extension) exists.

  -v            verbose output
  -d            dry run, won't remove any file(s)
  -r RAW_EXT    set the RAW extension to RAW_EXT (defaults to dng)
  -j JPG_EXT    set the JPG extension to JPG_EXT (defaults to jpg)
  -h            display this help and exit
```

## Example

Photos imported to /tmp/photos

```
$ find /tmp/photos
/tmp/photos
/tmp/photos/2016-11-12
/tmp/photos/2016-11-12/DSC00001.dng
/tmp/photos/2016-11-12/DSC00002.jpg
/tmp/photos/2016-11-19
/tmp/photos/2016-11-19/DSC00003.dng
/tmp/photos/2016-11-19/DSC00003.jpg
/tmp/photos/2016-11-19/DSC00004.dng
/tmp/photos/2016-11-19/DSC00004.jpg
```

In this case, DSC00001 has been taken as RAW only, DSC00002 as JPG only, and the other two photos as RAW+JPG (we want to remove the JPGs in this case), so we run clean_jpgs.sh on it

```
$ clean_jpgs.sh /tmp/photos
JPG file '/tmp/photos/2016-11-19/DSC00003.jpg' has matching RAW file '/tmp/photos/2016-11-19/DSC00003.dng': removed JPG
JPG file '/tmp/photos/2016-11-19/DSC00004.jpg' has matching RAW file '/tmp/photos/2016-11-19/DSC00004.dng': removed JPG
```

Result

```
$ find /tmp/photos
/tmp/photos
/tmp/photos/2016-11-12
/tmp/photos/2016-11-12/DSC00001.dng
/tmp/photos/2016-11-12/DSC00002.jpg
/tmp/photos/2016-11-19
/tmp/photos/2016-11-19/DSC00003.dng
/tmp/photos/2016-11-19/DSC00004.dng
```

## Installation

Copy it somewhere in your path (/usr/local/bin works well) and set the executable bit (chmod +x clean_jpgs.sh).

## Compatibility

Tested with:
- Bash 4.3 + GNU rm (Cygwin, Ubuntu 14.04)
- Bash 3.2 + BSD rm (OS X 10.12)



## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).
