#!/usr/bin/env bash

# Colors
RED='\033[0;31m'
NC='\033[0m' # No Color
BLUE='\033[0;34m'

echo -e "${RED}all?${NC}"
select choice in "Yes" "No"; do
    case $choice in
    Yes)
        stow --dotfiles */
        exit
        ;;
    No) break ;;
    esac
done

echo

for folder in */; do
    echo -e "${BLUE}${folder::-1}?${NC}" # remove / from folder name
    select choice in "Yes" "No"; do
        case $choice in
        Yes)
            echo "Stowing ${folder}"
            stow --dotfiles "${folder}"
            break
            ;;
        No) break ;;
        esac
    done
    echo
done
