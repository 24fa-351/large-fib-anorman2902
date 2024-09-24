#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>  // For INT_MAX, LONG_MAX, etc.
#include <inttypes.h> // For intmax_t

typedef intmax_t fib_type;

fib_type fibonacci_iterative(fib_type position) {
    if (position == 1) {
        return 0;
    }
    if (position == 2) {
        return 1;
    }

    fib_type previous_fib_number = 0;
    fib_type current_fib_number = 1;
    fib_type next_fib_number;

    int overflow_detected = 0; // Flag to check if overflow has occurred

    for (fib_type index = 3; index <= position; index++) {
        // Check for overflow
        if (current_fib_number > INTMAX_MAX - previous_fib_number) {
            if (!overflow_detected) { // Only print once
                printf("OVERFLOW\n");
                overflow_detected = 1; // Set the flag
            }
        }
        
        next_fib_number = previous_fib_number + current_fib_number;
        previous_fib_number = current_fib_number;
        current_fib_number = next_fib_number;
    }

    return current_fib_number;
}

fib_type fibonacci_recursive(fib_type position) {
    if (position == 1) {
        return 0;
    }
    if (position == 2) {
        return 1;
    }
    
    fib_type result = fibonacci_recursive(position - 1) + fibonacci_recursive(position - 2);
    
    // Check for overflow
    if (result < 0) { // If the result is negative, an overflow occurred
        static int overflow_detected = 0; // Static variable to persist across function calls
        if (!overflow_detected) { 
            printf("OVERFLOW\n");
            overflow_detected = 1; // Set the flag
        }
    }
    
    return result;
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <integer> <r|i>\n", argv[0]);
        return 1;
    }

    fib_type command_line_number;
    if (sscanf(argv[1], "%jd", &command_line_number) != 1) {
        fprintf(stderr, "Error: First argument must be an integer.\n");
        return 1;
    }

    char calculation_method = argv[2][0];
    
    fib_type fib_result;

    if (calculation_method == 'i') {
        fib_result = fibonacci_iterative(command_line_number);
    } else if (calculation_method == 'r') {
        fib_result = fibonacci_recursive(command_line_number);
    } else {
        fprintf(stderr, "Invalid method. Use 'r' for recursive or 'i' for iterative.\n");
        return 1;
    }

     printf("%jd\n\n", fib_result);
    return 0;
}
