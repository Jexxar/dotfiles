# shellcheck shell=bash
#
# Loads the system's Bash completion modules.
# If Homebrew is installed (OS X), it's Bash completion modules are loaded.

# Load before other completions
# BASH_IT_LOAD_PRIORITY: 325

# Bash-completion is too large and complex to expect to handle unbound variables throughout the whole codebase.
if shopt -qo nounset; then
	__bash_it_restore_nounset=true
	shopt -uo nounset
else
	__bash_it_restore_nounset=false
fi

# shellcheck disable=SC1090 disable=SC1091
if [[ -r "${BASH_COMPLETION:-}" ]]; then
	source "${BASH_COMPLETION}"
elif [[ -r /etc/bash_completion ]]; then
	source /etc/bash_completion
# Some distribution makes use of a profile.d script to import completion.
elif [[ -r /etc/profile.d/bash_completion.sh ]]; then
	source /etc/profile.d/bash_completion.sh
fi

if [[ ${__bash_it_restore_nounset:-false} == "true" ]]; then
	shopt -so nounset
fi
unset __bash_it_restore_nounset
