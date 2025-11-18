#!/bin/bash
path="$1"
path="${path/#$HOME/~}"

IFS='/' read -ra parts <<< "$path"

filtered_parts=()
for part in "${parts[@]}"; do
    if [ -n "$part" ]; then
        filtered_parts+=("$part")
    fi
done

num_parts=${#filtered_parts[@]}

if [ $num_parts -gt 2 ]; then
    last_idx=$((num_parts - 1))
    second_last_idx=$((num_parts - 2))
    printf "…/%s/%s\n" "${filtered_parts[$second_last_idx]}" "${filtered_parts[$last_idx]}"
else
    echo "$path"
fi
