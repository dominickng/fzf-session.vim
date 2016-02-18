fzf-session.vim
=================

This plugin adds support for searching, saving, and deleting *Vim* sessions
with [fzf.vim](https://github.com/junegunn/fzf.vim). Heavily inspired by
[vim-ctrlp-session](https://github.com/okcompute/vim-ctrlp-session), which
adds session management to [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim).

Features
========

Fuzzy search *vim* sessions using fzf.vim, with a single configurable location
for storing all session files.

Requirements
============

- [fzf](https://github.com/junegunn/fzf)
- [fzf.vim](https://github.com/junegunn/fzf.vim)

Installation
=============

[NeoBundle](https://github.com/Shougo/neobundle.vim):

    NeoBundle 'dominickng/fzf-session'

[Vundle](https://github.com/gmarik/Vundle.vim):

    Plugin 'dominickng/fzf-session'

[vim-plug](https://github.com/junegunn/vim-plug):

    Plug 'dominickng/fzf-session'

Usage
=====

The commands are modelled on those of
[vim-ctrlp-session](https://github.com/okcompute/vim-ctrlp-session), as much
of the implementation is the same.

### `:Session {name}`

Create a session with name. Session will be automatically tracked.

### `:SLoad {name}`

Load session with {name}.

### `:SDelete {name}`

Delete sessio with {name}.

### `:SQuit`

Stop tracking current active session and close all buffers.

### `:SList`

List all available sessions.

### `:Sessions`

Launch fzf prompt for fuzzy searching available sessions.

Default actions in the prompt:

 - `<Ctrl-X>`: Delete session under the cursor
 - Any other key: Open session under the cursor

Credits
=======

This plugin is wholly based upon
[vim-ctrlp-session](https://github.com/okcompute/vim-ctrlp-session).

License
=======

Distributed under the same terms as Vim itself. See :help license.
