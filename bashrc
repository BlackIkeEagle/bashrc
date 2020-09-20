#######################################
# BlackEagle's .bashrc                #
#######################################

#=====================================#
# start tmux session when using ssh   #
#=====================================#

if which tmux > /dev/null 2>&1 \
    && [[ "$SSH_CLIENT" != "" ]] \
    && [[ -z ${TMUX} ]] \
    && [[ "$(id -u)" != "0" ]]
then
    if tmux has-session; then
        if tmux has-session -t default; then
            exec tmux a -t default
        else
            exec tmux a
        fi
    else
        exec tmux new -s default
    fi
fi

#=====================================#
# vte terminal detection              #
#=====================================#

if [[ "$TERM" == "xterm-termite" ]] || [[ ! -z $GNOME_TERMINAL_SCREEN ]]; then
    [[ -e /etc/profile.d/vte.sh ]] && source /etc/profile.d/vte.sh
fi

#=====================================#
# force TERM if truecolor             #
#=====================================#

if [[ ! -z $COLORTERM ]] && [[ "$COLORTERM" == "truecolor" ]]; then
    export TERM=xterm-256color
fi

#=====================================#
# Add .bin before int check           #
#=====================================#

if [[ -d $HOME/.bin && ":$PATH:" != *:"$HOME/.bin":* ]]; then
    PATH=$HOME/.bin:$PATH
fi

#=====================================#
# when not interactive stop           #
#=====================================#

[[ $- != *i* ]] && return

#=====================================#
# Text Styling :)                     #
#=====================================#

unset COLBLK COLRED COLGRN COLYLW
unset COLBLU COLPUR COLCYN COLWHT
unset REG BLD UND
unset BGBLK BGRED BGGRN BGYLW
unset BGBLU BGPUR BGCYN BGWHT
unset TXRES
if [[ -t 2 ]]; then
    # front colors
    COLBLK='30m'
    COLRED='31m'
    COLGRN='32m'
    COLYLW='33m'
    COLBLU='34m'
    COLPUR='35m'
    COLCYN='36m'
    COLWHT='37m'

    # text modes
    REG='\033[0;'
    BLD='\033[1;'
    UND='\033[4;'

    # background colors
    BGBLK='\033[40;30m'
    BGRED='\033[41;30m'
    BGGRN='\033[42;30m'
    BGYLW='\033[43;30m'
    BGBLU='\033[44;30m'
    BGPUR='\033[45;30m'
    BGCYN='\033[46;30m'
    BGWHT='\033[47;30m'

    # reset styling
    TXRES='\033[0;0m'
fi
readonly COLBLK COLRED COLGRN COLYLW
readonly COLBLU COLPUR COLCYN COLWHT
readonly REG BLD UND
readonly BGBLK BGRED BGGRN BGYLW
readonly BGBLU BGPUR BGCYN BGWHT
readonly TXRES

#=====================================#
# Keybindings                         #
#=====================================#

# context aware history search
bind '"\e[5~":history-search-backward'
bind '"\e[6~":history-search-forward'

#=====================================#
# History settings                    #
#=====================================#

export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd*";
export HISTSIZE=4096;
export HISTCONTROL="ignoreboth:erasedups"
shopt -s histreedit;

#=====================================#
# Load config                         #
#=====================================#

if [[ -e $HOME/.bashrc.config ]]; then
    source $HOME/.bashrc.config
elif [[ -e /etc/bashrc.config ]]; then
    source /etc/bashrc.config
fi

#=====================================#
# Default prompt colors               #
#=====================================#

# defaults
[[ -z $PSCOL ]] && PSCOL=${REG}${COLYLW}
[[ -z $USRCOL ]] && USRCOL=${BLD}${COLYLW}
[[ -z $HSTCOL ]] && HSTCOL=${BLD}${COLWHT}
# default flags
[[ -z $SCMENABLED ]] && SCMENABLED=1
[[ -z $SCMDIRTY ]] && SCMDIRTY=1

if [[ $(id -u) == "0" ]]; then
    PSCOL=${REG}${COLRED};
    USRCOL=${BLD}${COLRED};
fi

#=====================================#
# LS colors                           #
#=====================================#

export LS_COLORS='ex=00:su=00:sg=00:ca=00:no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.7z=01;31:*.xz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.flac=01;35:*.mp3=01;35:*.mpc=01;35:*.ogg=01;35:*.wav=01;35:';

#=====================================#
# EDITOR is vim ofcourse              #
#=====================================#

export EDITOR=vim;

#=====================================#
# ALIASES                             #
#=====================================#

if ls --version > /dev/null 2>&1; then
    alias ls='ls --color=auto'; #gnu
else
    alias ls='ls -G'; #osx
fi
alias grep='grep --color';
alias cd..='cd ..';

if [[ -f $HOME/.aliases ]]; then
    source $HOME/.aliases
fi

#=====================================#
# FUNCTIONS                           #
#=====================================#

function smiley {
    local res=$?
    if [[ "$res" == "0" ]]; then
        SMCOL=${BLD}${COLGRN}
        SMILE="●"
    else
        SMCOL=${BLD}${COLRED}
        SMILE="●"
    fi
    echo -ne ${SMCOL}${SMILE}
    return $res
}

function scmbranch {
    local res=$?
    if [[ $(id -u) != "0" ]] && [[ $SCMENABLED -eq 1 ]]; then
        GITENABLED=0
        HGENABLED=0
        SVNENABLED=0
        BZRENABLED=0
        if which git > /dev/null 2>&1; then
            GITENABLED=1
        fi
        if which hg > /dev/null 2>&1; then
            HGENABLED=1
        fi
        if which svn > /dev/null 2>&1; then
            SVNENABLED=1
        fi
        if which bzr > /dev/null 2>&1; then
            BZRENABLED=1
        fi

        if [[ $GITENABLED -eq 1 ]] && GITBRANCH=$(git rev-parse --abbrev-ref HEAD 2>&1); then
            GITDIRTY=''
            if [[ $SCMDIRTY -eq 1 ]]; then
                # if has unstaged changes
                git diff --no-ext-diff --quiet --exit-code || GITDIRTY=" *"
                # if only has staged changes
                if [[ "$GITDIRTY" = "" ]]; then
                    git diff --staged --no-ext-diff --quiet --exit-code || GITDIRTY=" +"
                fi
            fi
            if [[ "${GITBRANCH}" == "master" ]]; then
                GITBRANCH="${PSCOL}─(${TXRES}${BLD}${COLYLW}git${TXRES}${PSCOL})─(${TXRES}${REG}${COLGRN}${GITBRANCH}${GITDIRTY}${TXRES}${PSCOL})"
            elif [[ "${GITBRANCH}" == "" ]]; then
                GITBRANCH="${PSCOL}─(${TXRES}${BLD}${COLYLW}git${TXRES}${PSCOL})─(${TXRES}${REG}${COLRED}$(git rev-parse --short HEAD)...${GITDIRTY}${TXRES}${PSCOL})"
            else
                GITBRANCH="${PSCOL}─(${TXRES}${BLD}${COLYLW}git${TXRES}${PSCOL})─(${TXRES}${REG}${COLCYN}${GITBRANCH}${GITDIRTY}${TXRES}${PSCOL})"
            fi
            echo -ne ${GITBRANCH}
        elif [[ $HGENABLED -eq 1 ]] && HGBRANCH=$(hg branch 2>/dev/null); then
            HGDIRTY=
            if [[ $SCMDIRTY -eq 1 ]]; then
                [[ "$(hg status -n | wc -l)" == "0" ]] || HGDIRTY=" *"
            fi
            if [[ "${HGBRANCH}" == "default" ]]; then
                HGBRANCH="${PSCOL}─(${TXRES}${BLD}${COLYLW}hg${TXRES}${PSCOL})─(${TXRES}${REG}${COLGRN}${HGBRANCH}${HGDIRTY}${TXRES}${PSCOL})"
            else
                HGBRANCH="${PSCOL}─(${TXRES}${BLD}${COLYLW}hg${TXRES}${PSCOL})─(${TXRES}${REG}${COLRED}${HGBRANCH}${HGDIRTY}${TXRES}${PSCOL})"
            fi
            echo -ne ${HGBRANCH}
        elif [[ $SVNENABLED -eq 1 ]] && SVNINFO=$(svn info 2>&1); then
            SVNREVISION=$(echo "$SVNINFO" | sed -ne 's/^Revision: //p')
            if [[ $SCMDIRTY -eq 1 ]]; then
                [[ "$(svn status | wc -l)" == "0" ]] || SVNDIRTY=" *"
            fi
            SVNBRANCH="${PSCOL}─(${TXRES}${BLD}${COLYLW}svn${TXRES}${PSCOL})─(${TXRES}${REG}${COLGRN}${SVNREVISION}${SVNDIRTY}${TXRES}${PSCOL})"
            echo -ne ${SVNBRANCH}
        elif [[ $BZRENABLED -eq 1 ]] && bzr nick > /dev/null 2>&1; then
            BZRREVISION=$(bzr revno)
            if [[ $SCMDIRTY -eq 1 ]]; then
                [[ "$(bzr status | wc -l)" == "0" ]] || BZRDIRTY=" *"
            fi
            BZRBRANCH="${PSCOL}─(%{%F{yellow}%}%Bbzr%b${PSCOL})─(%{%F{green}%}${BZRREVISION}${BZRDIRTY}${PSCOL})"
            echo -ne ${BZRBRANCH}
        fi
    fi
    return $res
}

function fldcol {
    local res=$?
    if [[ $(id -u) != "0" ]]; then
        if [[ $PWD =~ \/herecura ]]; then
            FLDCOL=${BLD}${COLBLK}${UND}${COLYLW};
        elif [[ $PWD =~ \/scripts ]]; then
            FLDCOL=${BLD}${COLBLK}${UND}${COLBLU}
        elif [[ $PWD =~ \/vimfiles ]]; then
            FLDCOL=${BLD}${COLBLK}${UND}${COLPUR}
        elif [[ $PWD =~ \/devel ]]; then
            FLDCOL=${BLD}${COLBLK}${UND}${COLWHT}
        fi
    fi

    if [[ "${FLDCOL}" = "" ]]; then
        if [[ $PWD =~ ^\/etc ]]; then
            FLDCOL=${BLD}${COLBLK}${UND}${COLRED}
        elif [[ $PWD =~ ^\/var/log ]]; then
            FLDCOL=${BLD}${COLBLK}${UND}${COLRED}
        else
            FLDCOL=${BLD}${COLCYN};
        fi
    fi
    echo -ne ${FLDCOL}
    return $res
}

#=====================================#
# Session colors tty/ssh/screen       #
#=====================================#

if [[ "$SSH_CLIENT" != "" ]]; then
    # SSH
    SESSCOL=${BLD}${COLRED}
elif [[ "$STY" != "" ]]; then
    # screen
    SESSCOL=${BLD}${COLCYN}
elif [[ ! -z $TMUX ]]; then
    # tmux
    SESSCOL=${BLD}${COLCYN}
else
    SESSCOL=${PSCOL}
fi

#=====================================#
# Configure prompt                    #
#=====================================#

PS1="\[${PSCOL}\]┌─┤\[${TXRES}\]\$(smiley)\[${TXRES}\]\[${PSCOL}\]├─┤\[${TXRES}\]\[${SESSCOL}\]\t\[${TXRES}\]\[${PSCOL}\]├─┤\[${TXRES}\]\[${USRCOL}\]\u\[${TXRES}\]\[${PSCOL}\] @ \[${TXRES}\]\[${HSTCOL}\]\h\[${TXRES}\]\[${PSCOL}\]├─┤\[${TXRES}\]\$(fldcol)\w\[${TXRES}\]\[${PSCOL}\]├\[${TXRES}\]\$(scmbranch)\[${TXRES}\]\[${PSCOL}\]─╼\n└╼\[${TXRES}\] "
PS2="\[${PSCOL}\]╶╼\[${TXRES}\] "
PS3="\[${PSCOL}\]╶╼\[${TXRES}\] "
PS4="\[${PSCOL}\]╶╼\[${TXRES}\] "

export PS1 PS2 PS3 PS4
