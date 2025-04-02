#!/usr/bin/env fish
# Script to download and install typstyle v0.13.2 from GitHub for macOS (Fish Shell)
# Created: (date)

# Step 1: Check system architecture
echo "Checking system architecture..."
set ARCH (uname -m)
echo "System architecture: $ARCH"

# Step 2: Download the appropriate binary based on architecture
echo "Downloading typstyle v0.13.2 for $ARCH..."
if test "$ARCH" = "arm64"
    # For Apple Silicon (M1/M2/M3) Macs
    curl -L https://github.com/Enter-tainer/typstyle/releases/download/v0.13.2/typstyle-aarch64-apple-darwin -o typstyle
else if test "$ARCH" = "x86_64"
    # For Intel Macs
    curl -L https://github.com/Enter-tainer/typstyle/releases/download/v0.13.2/typstyle-x86_64-apple-darwin -o typstyle
else
    echo "Unsupported architecture: $ARCH"
    exit 1
end

# Step 3: Make the binary executable
echo "Making binary executable..."
chmod +x typstyle

# Step 4: Check if ~/bin exists and create it if not
if not test -d "$HOME/bin"
    echo "Creating ~/bin directory..."
    mkdir -p "$HOME/bin"

    # For fish shell, add to PATH if not already there
    if not contains "$HOME/bin" $PATH
        mkdir -p "$HOME/.config/fish"
        echo 'set -x PATH $HOME/bin $PATH' >> "$HOME/.config/fish/config.fish"
        echo "Added ~/bin to PATH in fish config"
    end
end

# Step 5: Move the binary to ~/bin
echo "Installing typstyle to ~/bin..."
mv typstyle "$HOME/bin/"

# Step 6: Verify installation
echo "Verifying installation..."
if test -x "$HOME/bin/typstyle"
    echo "typstyle has been successfully installed to $HOME/bin/typstyle"
    echo "Version information:"
    "$HOME/bin/typstyle" --version
else
    echo "Installation failed. Please check the error messages."
end

echo "Installation complete!"
