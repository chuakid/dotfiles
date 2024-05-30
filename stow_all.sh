#!/usr/bin/env bash
for folder in */;
do
    echo "Install ${folder::-1}?" # remove / from folder name
    select choice in "Yes" "No"; do
        case $choice in
            Yes) stow --dotfiles "${folder}"; break;;
            No) break;;
        esac
    done
done

