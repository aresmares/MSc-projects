#!/bin/bash

let reps=10
if test $# -gt 1;
then
	rep=$2
fi

echo "Running $1 with $rep reps"

if test $1 == "medium";
then
	for (( c=1; c<=$rep; c++ ))
	do
		echo "Doing $c"
		python pacman.py -q -n 25 -p MDPAgent -l mediumClassic | grep "Win Rate" >> ../../mediumdata.txt
		echo "Done"
	done
elif test $1 == "small"; 
then
	for (( c=1; c<=$rep; c++ ))
	do
		echo "Doing $c"
		python pacman.py -q -n 25 -p MDPAgent -l smallGrid | grep "Win Rate" >> ../../smalldata.txt
		echo "Done"
	done
fi
