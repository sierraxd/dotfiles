#!/bin/bash

date '+https://energy.volyn.ua/spozhyvacham/perervy-u-elektropostachanni/hrafik-vidkliuchen/!img/%d-%m-%y.jpg' \
	| xargs curl -sL \
	| swappy -f - \
	|| notify-send -i error 'Failed to get blackout schedule'
