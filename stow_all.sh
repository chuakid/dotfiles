#!/usr/bin/env bash
for folder in */;
do
    stow --dotfiles ${folder}
done

