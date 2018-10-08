bash -c zsh

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

exit
