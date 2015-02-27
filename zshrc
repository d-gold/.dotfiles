command_exists () {
  type "$1" &> /dev/null;
}

is_linux () {
    [[ $('uname') == 'Linux' ]];
}

is_osx () {
    [[ $('uname') == 'Darwin' ]]
}

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -f ~/.dotfiles/zsh/zsh_pre ]] && . ~/.dotfiles/zsh/zsh_pre

source "$HOME/.antigen/antigen.zsh"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
    willghatch/zsh-hooks
    autojump
    cabal
    catimg
    colored-man
    command-not-found
    common-aliases
    dirhistory
    extract
    fasd
    gem
    git-extras
    git-flow
    bobthecow/git-flow-completion
    github
    heroku
    jira
    jsontools
    knife
    lein
    lol
    mercurial
    mvn
    nyan
    perl
    pep8
    pip
    pyenv
    python
    rand-quote
    ruby
    rvm
    scala
    sudo
    svn
    urltools
    vi-mode
    web-search
    zsh-users/zsh-completions
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-history-substring-search
    unixorn/autoupdate-antigen.zshplugin
    unixorn/git-extra-commands
    voronkovich/gitignore.plugin.zsh
    ascii-soup/zsh-url-highlighter
    Tarrasch/zsh-functional
    yerinle/zsh-gvm
    supercrabtree/k
    gerges/oh-my-zsh-jira-plus
    bric3/nice-exit-code
    willghatch/zsh-snippets
    zsh-users/zaw
    willghatch/zsh-zaw-extras
    chrissicool/zsh-256color
    Tarrasch/zsh-colors
    oknowton/zsh-dwim
    jocelynmallon/zshmarks
    berkshelf/berkshelf-zsh-plugin
    unixorn/rake-completion.zshplugin
    RobSis/zsh-completion-generator
EOBUNDLES

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Load the theme.
antigen bundle nojhan/liquidprompt

if is_osx; then
    antigen bundle osx
elif is_linux; then
    antigen bundle debian
    unalias ag
fi

[[ -f ~/.dotfiles/zsh/zsh_antigen ]] && . ~/.dotfiles/zsh/zsh_antigen

# Tell antigen that you're done.
antigen apply

export VISUAL=vim
export GREP_OPTIONS='--color=always'

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

autoload -U compinit



setopt incappendhistory
setopt sharehistory
setopt extendedhistory

# superglobs
setopt extendedglob
unsetopt caseglob
unsetopt nomatch 2>/dev/null

setopt interactivecomments # pound sign in interactive prompt
setopt auto_cd

# Vi mode
bindkey -v
bindkey '^R' history-incremental-pattern-search-backward

# Allow deleting backwards
# http://www.zsh.org/mla/workers/2008/msg01653.html
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# http://vim.wikia.com/wiki/256_colors_in_vim
if [ "$TERM" = "xterm" ] ; then
    if [ -z "$COLORTERM" ] ; then
        if [ -z "$XTERM_VERSION" ] ; then
            echo "Warning: Terminal wrongly calling itself 'xterm'."
        else
            case "$XTERM_VERSION" in
            "XTerm(256)") TERM="xterm-256color" ;;
            "XTerm(88)") TERM="xterm-88color" ;;
            "XTerm") ;;
            *)
                echo "Warning: Unrecognized XTERM_VERSION: $XTERM_VERSION"
                ;;
            esac
        fi
    else
        case "$COLORTERM" in
            gnome-terminal)
                # Those crafty Gnome folks require you to check COLORTERM,
                # but don't allow you to just *favor* the setting over TERM.
                # Instead you need to compare it and perform some guesses
                # based upon the value. This is, perhaps, too simplistic.
                TERM="gnome-256color"
                ;;
            *)
                echo "Warning: Unrecognized COLORTERM: $COLORTERM"
                ;;
        esac
    fi
fi

SCREEN_COLORS="`tput colors`"
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        screen-*color-bce)
            echo "Unknown terminal $TERM. Falling back to 'screen-bce'."
            export TERM=screen-bce
            ;;
        *-88color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-88color'."
            export TERM=xterm-88color
            ;;
        *-256color)
            echo "Unknown terminal $TERM. Falling back to 'xterm-256color'."
            export TERM=xterm-256color
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi
if [ -z "$SCREEN_COLORS" ] ; then
    case "$TERM" in
        gnome*|xterm*|konsole*|aterm|[Ee]term)
            echo "Unknown terminal $TERM. Falling back to 'xterm'."
            export TERM=xterm
            ;;
        rxvt*)
            echo "Unknown terminal $TERM. Falling back to 'rxvt'."
            export TERM=rxvt
            ;;
        screen*)
            echo "Unknown terminal $TERM. Falling back to 'screen'."
            export TERM=screen
            ;;
    esac
    SCREEN_COLORS=`tput colors`
fi

# Yes, really
export PATH=$PATH:~/bin
export PATH=$PATH:/sbin:/usr/sbin

# Constantly needing this
autoload -U zcalc
alias info='info --vi-keys'

mkcd() { mkdir -p $@; cd $_ }

export PATH="~/bin:/usr/local/bin:$PATH"
BASE="$HOME/.dotfiles/zsh"

CORE=(
    completions
    key_bindings
    navigation
    colors
    editor
    aliases
    functions
    exports
    path
    options
    prompt
    git
    haskell
    python
    go
)

for file in $CORE ; do
    [[ -f "$BASE/$file.zsh" ]] && . "$BASE/$file.zsh"
done

[[ -f ~/.dotfiles/zsh/zsh_completions ]] && . ~/.dotfiles/zsh/zsh_completions
[[ -f ~/.dotfiles/zsh/zsh_exports ]] && . ~/.dotfiles/zsh/zsh_exports
[[ -f ~/.dotfiles/zsh/zsh_functions ]] && . ~/.dotfiles/zsh/zsh_functions
[[ -f ~/.dotfiles/zsh/zsh_keys ]] && . ~/.dotfiles/zsh/zsh_keys
[[ -f ~/.dotfiles/zsh/zsh_options ]] && . ~/.dotfiles/zsh/zsh_options

[[ -f ~/.dotfiles/zsh/zsh_post ]] && . ~/.dotfiles/zsh/zsh_post

# Source user's zshrc
[[ -f ~/.zsh_local ]] && . ~/.zsh_local
[[ -f ~/.zsh_site ]] && . ~/.zsh_site



#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/dgold/.gvm/bin/gvm-init.sh" ]] && source "/home/dgold/.gvm/bin/gvm-init.sh"
