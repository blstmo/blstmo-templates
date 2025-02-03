# BLSTMO Docker Installer Script

This script automates the installation of Docker and Docker Compose on any Linux system.

## Installation

You can install the Docker installer script using one of the following methods:

### 1. Using `curl` (Recommended)

Run the following command to download and execute the script:

```bash
curl -fsSL https://raw.githubusercontent.com/blstmo/blstmo-templates/docker-installer/install.sh -o install.sh && sudo bash install.sh
```

### 2. Using `wget`

If you prefer `wget`, you can use the following command:

```bash
wget -qO- https://raw.githubusercontent.com/blstmo/blstmo-templates/docker-installer/install.sh | sudo bash
```

### 3. Manual Installation (Using Git)

If you want to clone the repository manually and run the script, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/blstmo/blstmo-templates.git
    ```

2. Navigate to the `docker-installer` directory:

    ```bash
    cd blstmo-templates/docker-installer
    ```

3. Make the script executable:

    ```bash
    chmod +x install.sh
    ```

4. Run the script:

    ```bash
    sudo ./install.sh
    ```

## Requirements

- `curl` or `wget` (for downloading the script)
- `jq` (automatically installed if missing)
- Root privileges (sudo access)

## Script Features

- Installs the latest version of Docker and Docker Compose.
- Works on any Linux distribution (Debian, Ubuntu, CentOS, Fedora, etc.).
- Automatically installs dependencies (`curl`, `jq`, etc.) if missing.

## Troubleshooting

If you encounter any issues, ensure your system is up to date and that you have `curl` or `wget` installed. If `jq` is missing, the script will install it automatically.

For further help, feel free to open an issue on the [GitHub repository](https://github.com/blstmo/blstmo-templates).

---

© BLSTMO 2025
