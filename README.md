# Docker Setups
Ultimate Directory of Docker templates. Ready-to-use Docker setups.

## Getting Started

1. **Initialize the Setup**
   Use the provided setup script to automatically configure the environment variables for your chosen setup. This will safely copy the `.env.example` file to `.env` and automatically generate secure, random keys where needed.

   **On Linux / macOS / Git Bash:**
   ```bash
   bash setup.sh <folder_name>
   ```

   **On Windows (Command Prompt or PowerShell):**
   ```cmd
   setup.bat <folder_name>
   ```
   *Example:* `setup.bat n8n`

2. **Start the Containers**
   Navigate into the specific setup directory and start the services in detached mode using Docker Compose:
   ```bash
   cd <folder_name>
   docker compose up -d
   ```
   *Note: Older versions of Docker might require `docker-compose up -d` instead of `docker compose up -d`.*

3. **Stop the Containers**
   When you're done, you can stop the containers by running:
   ```bash
   docker compose down
   ```

## Available Setups

Here are the currently available ready-to-use Docker configurations:

- **`lightllm`**
- **`n8n`**
- **`redis`**
- **`stremio`**

## Installing Docker

If you do not have Docker installed, you will need it to run these setups.

### Windows
1. Download **Docker Desktop for Windows** from the [Docker website](https://docs.docker.com/desktop/install/windows-install/).
2. Run the installer and follow the instructions.
3. Ensure that WSL 2 (Windows Subsystem for Linux) backend is enabled for best performance.

### macOS
1. Download **Docker Desktop for Mac** from the [Docker website](https://docs.docker.com/desktop/install/mac-install/).
2. Open the downloaded `.dmg` file and drag the Docker icon to your Applications folder.
3. Launch Docker from your Applications.

### Linux (Ubuntu / Debian)
You can install Docker Engine and the Docker Compose plugin using the following commands:
```bash
# Update existing packages
sudo apt update

# Install prerequisites
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine and Compose Plugin
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# (Optional) Add your user to the docker group to run docker without sudo
sudo usermod -aG docker $USER
```
*(Remember to log out and log back in if you added your user to the `docker` group).*
