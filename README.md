# brb
brb - bash right back - the directory bookmarking tool.

## Setup

To install ```brb``` just execute following command:
```
bash <(curl -s https://raw.githubusercontent.com/bytebutcher/brb/master/install)
```

Since ```brb``` requires ```fzf``` to work properly you also need to execute the following commands: 
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
If you like to know more about ```fzf``` check out the [documentation of fzf](https://github.com/junegunn/fzf).

## Usage

### Selecting bookmarks

```brb``` uses ```fzf``` to allow selecting bookmarks using an interactive fuzzy search. 
A filter can be used to show only bookmarks matching the filter term. 
If there is only one bookmark matching ```brb``` automatically changes the current 
directory to the associated location. In addition bookmarks can be selected by index.

```
# Search and select bookmark using an interactive fuzzy search
$ brb
# Pre-filter bookmarks before showing an interactive fuzzy search
$ brb "filter string"
# Select bookmark by index
$ brb 1
```

### Adding bookmarks

The ```-a | --add``` argument can be used to add a path as bookmark.
When no parameter is specified the current working directory will be used as bookmark.

```
# Add /some/path/ as bookmark
$ brb -a /some/path/
# Add the current working directory as bookmark
$ brb -a
```

### Removing bookmarks

The ```-r | --remove``` argument can be used to remove a path from the bookmarks.
The index parameter can be used to specify which bookmark to remove.
When no index is specified ```fzf``` is used to allow selecting bookmarks using an interactive fuzzy search.

```
# Remove the directory from your bookmarks by index
$ brb -r 1
# Use fzf to search for the bookmark which should be removed
$ brb -r
```

### Listing bookmarks

The ```-l | --list``` argument can be used to list all bookmarks (including their indices).

```
$ brb -l
0   /usr/bin
1   /some/path
```

### Getting help

If you want to see a brief description of all arguments and their usage use the ```-? | -h | --help``` argument.
