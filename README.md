# dotfiles
Yep.

## Installation
Rather than having an installation script or Makefile, I've found that a really nice way to add dotfiles is to use an old but lesser-known tool called "`stow`". ([GNU Stow](https://www.gnu.org/software/stow) and [xstow](http://xstow.sourceforge.net/) are both good options, but their syntax differs slightly.)

For example, with GNU Stow:

```
$ git clone git://github.com/tcreech/dotfiles ~/.dotfiles
$ cd ~/.dotfiles
$ stow --ignore=README.md -nv .
$ stow --ignore=README.md -v .
```
Done! We now have symlinks to all our dotfiles and dot...directories set up in ~.

The first `stow` command won't do anything but print out what the second one would do. The second stow command will create symlinks from ~/.dotfiles out into ~, such as `~/.zshrc -> .dotfiles/.zshrc`. This way you are warned of any conflicts.

Note that sufficiently old xstow and GNU stow installations may not support "`--ignore`", while sufficiently new ones will by default ignore `README.*` files even without `--ignore...` specified.

The usual `stow` actions work as expected: to blow away the dotfiles, you can do `stow -D .`, and to link in new files you've added to ~/.dotfiles you can do `stow -R .`.
