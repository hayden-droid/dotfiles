#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && source "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    declare -r VUNDLE_GIT_REPO_URL="https://github.com/gmarik/Vundle.vim.git"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `Git` is installed

    if ! cmd_exists "git"; then
        print_error "Git is required, please install it!\n"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install / Update vim plugins

    rm -rf ~/.vim/plugins/Vundle.vim &> /dev/null \
        && git clone "$VUNDLE_GIT_REPO_URL" ~/.vim/plugins/Vundle.vim &> /dev/null \
        && printf "\n" | vim +PluginInstall +qall 2> /dev/null
        #     └─ simulate the ENTER keypress for
        #        the case where there are warnings
    print_result $? "Install Vim plugins"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # In the case of fresh installs, in order for `npm` to be
    # available, the `~/bash.local` file needs to be sourced

    if ! cmd_exists "npm"; then
        source "$HOME/.bash.local"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Additional installs

    cd ~/.vim/plugins/tern_for_vim \
        && npm install &> /dev/null
    print_result $? "Install extra parts for \`tern_for_vim\`"

}

main