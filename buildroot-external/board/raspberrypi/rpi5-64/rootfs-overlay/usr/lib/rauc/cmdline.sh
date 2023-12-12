# shellcheck shell=sh
# Shell script functions to manipulate kernel cmdline

# Function to get the value of a key from a command line string
get_value() {
    key="$1"
    cmdline_string="$2"

    # Split the command line string by whitespace and then by '=' using xargs
    echo "$cmdline_string" | xargs -n1 | grep "^$key=" | cut -d= -f2-
}

# Function to set or update the value of a key in a command line string
set_value() {
    key="$1"
    new_value="$2"
    cmdline_string="$3"

    # Use sed to replace the value of the key if it exists, or add a new key-value pair
    if echo "$cmdline_string" | grep -q "$key="; then
        echo "$cmdline_string" | sed "s/$key=[^ ]*/$key=$new_value/"
    else
        echo "$cmdline_string $key=$new_value"
    fi
}
