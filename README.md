# getKanban

Симулятор игры [getKanban](http://getkanban.com/)

# Цель
Выбор стратегии игры и ее проверка путем многократной симуляции и усреднения результатов


# Дополнения

Патч для vim-elm плагина:


.vimrc:

let g:elm_make_rootpath = ".."
let g:elm_make_filepath_prefix = "src/"

~/.vim/bundle/elm-vim/autoload/elm.vim

let currpwd = system('pwd')
exe 'cd' g:elm_make_rootpath
let cmd_ = "elm-make --report=json " . g:elm_make_filepath_prefix . filename . " --output=". g:elm_make_output_file
echo "cmd: " . cmd_
sleep 2000m
let reports = system(cmd_)
exe 'cd' currpwd

