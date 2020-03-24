# brb
brb - be right bash - yet another bash directory bookmark script

## Usage

```
# Search and select bookmark (interactive fuzzy search)
brb
# Select bookmark by index
brb 1
# Add the current working directory as bookmark
brb -a
# Add the specified directory as bookmark
brb -a /some/path/
# Remove the current working directory from your bookmarks
brb -r
# Remove the directory from your bookmarks by index
brb -r 1
# List all bookmarks (including indices)
brb -l
```

## Installation

### fzf

```brb``` requires ```fzf``` to work properly. 
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
Check out the [documentation of fzf](https://github.com/junegunn/fzf) for more information.

### brb

```
bash <(curl -s https://github.com/bytebutcher/brb/install)
```
