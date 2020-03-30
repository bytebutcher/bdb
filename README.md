# bdb
bdb - bash directory bookmarking

## Usage

### Selecting bookmarks

```bdb``` uses ```fzf``` to allow selecting bookmarks using an interactive fuzzy search. 
A filter can be used to show only bookmarks matching the filter term. 
If there is only one bookmark matching ```bdb``` automatically changes the current 
directory to the associated location. In addition bookmarks can be selected by index.

```
# Search and select bookmark using an interactive fuzzy search
$ bdb
# Pre-filter bookmarks before showing an interactive fuzzy search
$ bdb "filter string"
# Select bookmark by index
$ bdb 1
```

### Adding bookmarks

The ```-a | --add``` argument can be used to add a path as bookmark.
When no parameter is specified the current working directory will be used as bookmark.

```
# Add /some/path/ as bookmark
$ bdb -a /some/path/
# Add the current working directory as bookmark
$ bob -a
```

### Removing bookmarks

The ```-r | --remove``` argument can be used to remove a path from the bookmarks.
The index parameter can be used to specify which bookmark to remove.
When no parameter is specified the current working directory is used as path.

```
# Remove the directory from your bookmarks by index
$ bdb -r 1
# Remove the current working directory from your bookmarks
$ bdb -r
```

### Listing bookmarks

The ```-l | --list``` argument can be used to list all bookmarks (including their indices).

```
$ bdb -l
0   /usr/bin
1   /some/path
```

### Getting help

If you want to see a brief description of all arguments and their usage use the ```-? | -h | --help``` argument.

## Installation

To install ```bdb``` just execute following command:
```
bash <(curl -s https://raw.githubusercontent.com/bytebutcher/bdb/master/install)
```

Since ```bdb``` requires ```fzf``` to work properly you also need to execute the following commands: 
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
If you like to know more about ```fzf``` check out the [documentation of fzf](https://github.com/junegunn/fzf).
