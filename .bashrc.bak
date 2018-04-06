#===========================================
# * ~/.bashrc Personalizado para Ubuntu e derivados
#===========================================

#===========================================
# Se não estiver rodando interativamente, não fazer nada
#===========================================
[[ $- != *i* ]] && return
[ -z "$PS1" ] && return

#===========================================
# Para uso com tilix/terminix/vte
#===========================================
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    if [ -e "/etc/profile.d/vte.sh" ]; then    
        source /etc/profile.d/vte.sh
    fi
fi

#===========================================
# Se houver bash_completion em /etc
#===========================================
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

#===========================================
# Se houver bashrc.local
#===========================================
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

#===========================================
# Carrega source files dentro de ~/.bash
#===========================================
for file in ~/.bash/{config,paths,aliases,functions,completions,prompt}; do
    [ -r "$file" ] && source "$file"
done

unset file

#===========================================
# Cria ~/.bash/exports para realizar export das funcoes
#===========================================
exports_gen

#===========================================
# Se houver ~/.bash/exports
#===========================================
if [ -f ~/.bash/exports ]; then
    source ~/.bash/exports
fi

#=============================================
# Mostra frases no início da sessão
#=============================================
greetings
