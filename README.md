# Docker Setups for Raspberry Pi
Ultimate Directory of Raspberry Pi Docker templates. Ready-to-use Docker setups.

## Getting Started

1. **Initialize the Setup**
   Use the provided setup script to automatically configure the environment variables for your chosen setup. This will safely copy the `.env.example` file to `.env` and automatically generate secure, random keys where needed.

   **On Linux / macOS / Git Bash:**
   ```bash
   bash setup.sh <folder_name>
   ```

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

- **`mariadb`**
- **`mongodb`**
- **`postgres`**
- **`redis`**
