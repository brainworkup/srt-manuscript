#!/bin/bash
# Script to download and install typstyle v0.13.2 from GitHub for macOS
# Created: $(date)

# Step 1: Check system architecture
echo "Checking system architecture..."
ARCH=$(uname -m)
echo "System architecture: $ARCH"

# Step 2: Download the appropriate binary based on architecture
echo "Downloading typstyle v0.13.2 for $ARCH..."
if [ "$ARCH" = "arm64" ]; then
    # For Apple Silicon (M1/M2/M3) Macs
    curl -L https://github.com/Enter-tainer/typstyle/releases/download/v0.13.2/typstyle-aarch64-apple-darwin -o typstyle
elif [ "$ARCH" = "x86_64" ]; then
    # For Intel Macs
    curl -L https://github.com/Enter-tainer/typstyle/releases/download/v0.13.2/typstyle-x86_64-apple-darwin -o typstyle
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Step 3: Make the binary executable
echo "Making binary executable..."
chmod +x typstyle

# Step 4: Check if ~/bin exists and create it if not
if [ ! -d "$HOME/bin" ]; then
    echo "Creating ~/bin directory..."
    mkdir -p "$HOME/bin"

    # Add to PATH if using bash/zsh (comment out if using fish shell)
    # echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
    # echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.zshrc"

    # For fish shell (uncomment if needed)
    # mkdir -p "$HOME/.config/fish"
    # echo 'set -x PATH $HOME/bin $PATH' >> "$HOME/.config/fish/config.fish"
fi

# Step 5: Move the binary to ~/bin
echo "Installing typstyle to ~/bin..."
mv typstyle "$HOME/bin/"

# Step 6: Verify installation
echo "Verifying installation..."
if [ -x "$HOME/bin/typstyle" ]; then
    echo "typstyle has been successfully installed to $HOME/bin/typstyle"
    echo "Version information:"
    "$HOME/bin/typstyle" --version
else
    echo "Installation failed. Please check the error messages."
fi

echo "Installation complete!"
