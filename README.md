# bdb
bdb - bash directory bookmarking

## Usage

```
# Search and select bookmark (interactive fuzzy search)
bdb
# Select bookmark by index
bdb 1
# Add the current working directory as bookmark
bdb -a
# Add the specified directory as bookmark
bdb -a /some/path/
# Remove the current working directory from your bookmarks
bdb -r
# Remove the directory from your bookmarks by index
bdb -r 1
# List all bookmarks (including indices)
bdb -l
```

## Installation

To install bdb just execute following command:
```
bash <(curl -s https://github.com/bytebutcher/bdb/install)
```

Since ```bdb``` requires ```fzf``` to work properly you also need to execute the following commands: 
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
If you like to know more about ```fzf``` check out the [documentation of fzf](https://github.com/junegunn/fzf).
