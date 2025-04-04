# Neovim Command Search Tool (nsearch) README

## Overview

The `nsearch` tool is a simple command-line utility designed to search for Neovim commands and their descriptions. It reads from a predefined text file (`nsearch.txt`) and outputs search results in a neatly formatted manner.

## Installation
**`repgrep`**
- **MAC:** `brew install ripgrep`
- **Linux:** `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
  
To install `nsearch`, follow these steps:

**Create the `/home/bin` directory if it doesn't exist:**

`bash mkdir -p /home/bin`

**Copy the `nsearch.sh` script to `/home/bin`:**

`bash cp /path/to/nsearch.sh /home/bin/nsearch.sh`

**Copy the `nsearch.txt` data file to `/home/bin`:**

`bash cp /path/to/nsearch.txt /home/bin/nsearch.txt`

**Make the script executable:**

`bash chmod +x /home/bin/nsearch.sh`

**Add an alias to your `.bashrc` file:**

Open your `.bashrc` file with your preferred text editor:

`bash nano ~/.bashrc`

Add the following line at the end of the file:

`bash alias nsearch='/home/bin/nsearch.sh'`

Save and close the file, then reload the `.bashrc` file:

`bash source ~/.bashrc`
## Usage

To use `nsearch`, simply type the alias followed by your search term:

```bash
nsearch <search_term>
```

For example, to search for commands related to "navigation":

```bash
nsearch navigation
```

This will output a list of Neovim commands related to navigation, formatted in columns for easy reading.

### Example Output

When searching for "navigation", the output might look like this:

```
h  | Move left                           | Navigation
l  | Move right                          | Navigation
j  | Move down                           | Navigation
k  | Move up                             | Navigation
gg | Go to beginning of file             | Navigation
G  | Go to end of file                   | Navigation
0  | Move to beginning of line           | Navigation
^  | Move to first non-blank character   | Navigation
$  | Move to end of line                 | Navigation
w  | Move to beginning of next word      | Navigation
b  | Move to beginning of previous word  | Navigation
}  | Move to next paragraph              | Navigation
{  | Move to previous paragraph          | Navigation
%  | Jump between matching brackets      | Navigation
```

## Troubleshooting

- **If `nsearch` is not found:** Ensure that `/home/bin` is in your system's PATH or use the full path to the script: `/home/bin/nsearch.sh`.
- **If `nsearch.txt` is not found:** Verify that the file exists at `/home/bin/nsearch.txt` and has the correct permissions.

## Contributing

If you wish to contribute to the `nsearch` tool, you can:

- Add more Neovim commands to `nsearch.txt`.
- Improve the formatting or functionality of `nsearch.sh`.
- Submit pull requests or issues on the project's repository (if available).

## License

This project is open-source and available under the MIT License. See the `LICENSE` file for more details.

* * *

By following these instructions, you should be able to install and use the `nsearch` tool effectively. If you encounter any issues or have suggestions for improvement, please let us know.

as a markdown snipert

# Neovim Command Search Tool (nsearch)

## Installation

1.  **Create `/home/bin` directory:** `bash mkdir -p /home/bin`
    
2.  **Copy files:** `bash cp /path/to/nsearch.sh /home/bin/nsearch.sh cp /path/to/nsearch.txt /home/bin/nsearch.txt`
    
3.  **Make script executable:** `bash chmod +x /home/bin/nsearch.sh`
    
4.  **Add alias to `.bashrc`:** `bash echo "alias nsearch='/home/bin/nsearch.sh'" >> ~/.bashrc source ~/.bashrc`
    

## Usage

Search Neovim commands:

```bash
nsearch <search_term>
```

Example:

```bash
nsearch navigation
```

Output format:

```
h  | Move left                    | Navigation
l  | Move right                   | Navigation
j  | Move down                    | Navigation
k  | Move up                      | Navigation
...
```

## Troubleshooting

- **nsearch not found:** Ensure `/home/bin` is in PATH or use `/home/bin/nsearch.sh`.
- **nsearch.txt not found:** Check file existence and permissions at `/home/bin/nsearch.txt`.

## Contributing

- Add commands to `nsearch.txt`.
- Improve `nsearch.sh`.
- Submit PRs or issues.

## License

MIT License. See `LICENSE` file.
