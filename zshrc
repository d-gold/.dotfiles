
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/dgold/.gvm/bin/gvm-init.sh" ]] && source "/home/dgold/.gvm/bin/gvm-init.sh"

# For historical purposes
HISTSIZE=10000
SAVEHIST=8500

source "$HOME/.antigen/antigen.zsh"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
    autojump
    cabal
    catimg
    colored-man
    command-not-found
    common-aliases
    debian
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
    zsh-users/zsh-history-substring-search
    unixorn/autoupdate-antigen.zshplugin
    unixorn/git-extra-commands
    voronkovich/gitignore.plugin.zsh
    ascii-soup/zsh-url-highlighter
    zsh-users/zsh-syntax-highlighting
EOBUNDLES

zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Load the theme.
antigen theme agnoster

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

source ~/.zsh_site
