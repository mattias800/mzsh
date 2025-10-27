# Core environment configuration for mzsh
# Loaded early by ~/.mzsh/init.zsh (Tools section)

# Terminal type
export TERM="xterm-256color"

# Default editor
export EDITOR="idea"
# JetBrains Toolbox scripts (relocatable using $HOME)
case ":$PATH:" in
  *":$HOME/Library/Application Support/JetBrains/Toolbox/scripts:"*) ;;
  *) export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH" ;;
esac
