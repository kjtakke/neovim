# AI User Interface Documentation

## Overview

This document outlines the usage of the AI User Interface (AI UI) for interacting with an AI chat system within Neovim. The AI UI provides a simple and efficient way to ask questions and receive answers from an AI through a local API endpoint.

## Prerequisites

- Neovim installed with necessary plugins and configurations.
- A running local AI server accessible at the specified `API_ENDPOINT`.
- Basic familiarity with Neovim's command line and key mappings.

## Installation

To integrate the AI UI into your Neovim setup, add the following Lua code to your Neovim configuration file (usually `init.lua` or a sourced Lua file):

```lua
-- Ensure the AI UI module is loaded
local ai_ui = require('ai_ui')

-- Set up key mapping to open the AI UI
vim.api.nvim_set_keymap('n', '<leader>ai', "<cmd>lua require'ai_ui'.open_ui()<CR>", { noremap = true, silent = true })
```

## Usage

### Opening the AI UI

To open the AI UI, use the key mapping `<leader>ai` in normal mode. This will display two floating windows:

- **Question Box**: The top window where you can type your question.
- **Answer Box**: The bottom window where the AI's response will be displayed.

### Asking a Question

1.  **Type Your Question**: In the Question Box, enter your question. You can use Markdown formatting for better readability.
2.  **Submit the Question**: Press `<leader>s` to submit your question to the AI.

### Receiving an Answer

After submitting your question, the AI UI will send the question to the specified API endpoint and display the response in the Answer Box. The response is formatted in Markdown for enhanced readability.

### Closing the AI UI

To close the AI UI, simply close the floating windows by pressing `q` or using the standard Neovim window management commands.

## Configuration

### API Endpoint

The AI UI communicates with an AI server through an API endpoint. You can configure this endpoint in the Lua module:

```lua
local API_ENDPOINT = "http://localhost:8000/ask"
```

Make sure this endpoint matches the URL of your running AI server.

### Key Mappings

You can customise the key mappings to suit your preferences. The default mappings are:

- `<leader>ai` to open the AI UI.
- `<leader>s` to submit a question.

To change these, modify the `vim.api.nvim_set_keymap` calls in your configuration file.

## Troubleshooting

- **No Response from AI**: Ensure your AI server is running and accessible at the specified `API_ENDPOINT`.
- **Formatting Issues**: If the response is not formatted correctly, check that the AI server is returning Markdown formatted text.

## Example

Here's an example of how you might use the AI UI:

1.  Open Neovim and press `<leader>ai` to open the AI UI.
2.  In the Question Box, type:

`What are the key principles of software engineering?`

1.  Press `<leader>s` to submit the question.
2.  The Answer Box will display the AI's response, formatted in Markdown.
