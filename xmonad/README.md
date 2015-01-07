# xmonad

xmonad-related software.

### Install all software:
Dependencies:
* xmonad
* xmobar
 * xfonts-terminus
* feh
* dmenu
* trayer

```bash
$ sudo apt-get install xmonad xmobar libghc-xmonad-contrib-dev feh dmenu trayer
```

### Setup xmonad start (`xms`)
```bash
$ mkdir -p ~/bin
$ cd ~/bin
$ ln -s ~/System/dotfiles/xmonad/xms
```
add the following line to `~/.bashrc`
```bash
export PATH=$PATH:"/home/ajc/bin"
```

####`xmonad` setup
```bash
$ mkdir ~/.xmonad
$ cd ~/.xmonad
$ ln -s ~/System/dotfiles2/xmonad/xmonad.hs
```

###`xmobar` setup
```bash
$ cd ~
$ ln -s ~/System/dotfiles2/xmonad/xmobarrc .xmobarrc
```

```bash
$ mkdir -p ~/bin
$ cd ~/bin
$ ln -s ~/System/dotfiles/xmonad/loadavg
```

