# Linux-Tools
A collection of scripts and notes I've written along the years

## Usage

### `create_desktop.sh`

This script simplifies the process of making a `.desktop` application

To use this, first create a folder to store all applications. I usually put mine in `/home/user/Documents/Applications`

Then place the script inside that folder.

From here, create a subfolder in `Applications` for every new app you want to make.

For instance,

```bash
$ cd ~/Documents/Applications
$ mkdir my_app && cd my_app
$ ../create_desktop.sh

# Follow the prompts on screen!
```