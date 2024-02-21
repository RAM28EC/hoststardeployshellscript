#!/bin/bash
# Deploy a hoststar clone and handles errors

# Function to clone hostar app
hostar_clone_code() {
    echo "Cloning the app"
    if [ -d "Hotstar-Clone" ]; then
        echo "The code directory already exists, skipping cloning hostar app"
    else
        git clone https://github.com/RAM28EC/Hotstar-Clone.git || {
            echo "Failed to clone the app"
            return 1
        }
    fi
}

# Function to install required dependencies
install_requirements() {
    echo "Installing dependencies..."
    sudo apt-get update && sudo apt-get install -y docker.io || {
        echo "Failed to install dependencies"
        return 1
    }
}

# Function to perform required restarts
restarts_required() {
    echo "Performing required restarts..."
    sudo chown "$USER" /var/run/docker.sock || {
        echo "Failed to change ownership of docker.sock"
        return 1
    }
}

# Function to deploy the Hoststar app
deploy() {
    echo "Building and deploying Hotstar app.."
    cd Hotstar-Clone || {
        echo "Failed to change directory to Hotstar-Clone"
        return 1
    }

    docker build -t hotstartimage:latest . && docker run -d --name hotstar-container -p 3000:3000 hotstartimage:latest || {
        echo "Failed to build and deploy the app."
        return 1
    }
}

# Main deployment script
echo "********** DEPLOYMENT STARTED *********"

# Clone the code
if ! hostar_clone_code; then
    exit 1
fi

# Install dependencies
if ! install_requirements; then
    exit 1
fi

# Perform required restarts
if ! restarts_required; then
    exit 1
fi

# Deploy the app
if ! deploy; then
    echo "Deployment failed. Mailing the admin..."
    # Add your sendmail or notification logic here
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"
