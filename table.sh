#!/bin/bash

# Output CSV header with capitalized and bold labels
echo "FIBONACCI INDEX,TYPE,WIDTH,RESULT,REAL TIME,USER TIME,SYS TIME,METHOD" > fib_results.csv

# Define n values for testing iterative (0 to 100) and recursive (0 to 40)
iterative_n_values=$(seq 10 10 100) # Generates 0, 10, 20, ..., 100
recursive_n_values=$(seq 10 10 40)  # Generates 0, 10, 20, 30, 40

# Loop over integer types, including the 'short' type
for type in "short" "int" "long" "long_long" "intmax_t"; do

    # Define the width of each type in bits
    case $type in
        short)
            width=16
            ;;
        int)
            width=32
            ;;
        long)
            width=64
            ;;
        long_long)
            width=64
            ;;
        intmax_t)
            width=64 # or more depending on platform
            ;;
    esac

    # Run the iterative method for n values 0 to 100
    for n in $iterative_n_values; do
        # Run iterative version and capture timing
        iterative_output=$( ( /usr/bin/time -p ./fib "$n" i ) 2>&1 )
        
        # Extract real, user, and system times
        real_time=$(echo "$iterative_output" | grep real | awk '{print $2}')
        user_time=$(echo "$iterative_output" | grep user | awk '{print $2}')
        sys_time=$(echo "$iterative_output" | grep sys | awk '{print $2}')
        
        # Get the fib result
        result=$(echo "$iterative_output" | grep -v "real" | grep -v "user" | grep -v "sys" | xargs)

        # Append results for iterative method to CSV
        echo "$n,$type,$width,$result,$real_time,$user_time,$sys_time,iterative" >> fib_results.csv
    done

    # Run the recursive method only for n values 0 to 40
    for n in $recursive_n_values; do
        # Run recursive version and capture timing
        recursive_output=$( ( /usr/bin/time -p ./fib "$n" r ) 2>&1 )
        
        # Extract real, user, and system times
        real_time=$(echo "$recursive_output" | grep real | awk '{print $2}')
        user_time=$(echo "$recursive_output" | grep user | awk '{print $2}')
        sys_time=$(echo "$recursive_output" | grep sys | awk '{print $2}')
        
        # Get the fib result
        result=$(echo "$recursive_output" | grep -v "real" | grep -v "user" | grep -v "sys" | xargs)

        # Append results for recursive method to CSV
        echo "$n,$type,$width,$result,$real_time,$user_time,$sys_time,recursive" >> fib_results.csv
    done

done
