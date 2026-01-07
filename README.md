# MagicTAR: Archive and Restore Utility

MagicTAR is a simple bash script designed for the creation and restoration of uncompressed `.tar` archives while preserving critical system metadata, including ACLs and Extended Attributes.

Developed specifically for environments where data integrity and permission accuracy are paramount, such as Docker container volumes/ bind mounts and system configuration backups.

## Features

* **Data Integrity:** Uses raw `.tar` format to avoid the risk of data loss associated with compressed archive corruption.
* **Metadata Preservation:** Automatically handles `--acls`, `--xattrs`, and permissions—ideal for Docker container bind-mounts.
* **Boundary Safety:** Implements the `--one-file-system` flag to prevent accidental inclusion of external network mounts or virtual filesystems.
* **Unified Interface:** A single interactive script providing both backup and restoration workflows.

## Installation

### Local Installation

1. Clone the repository or download `magictar.sh`.
2. Move the script to a directory in your PATH and make it executable:
```bash
sudo mv magictar.sh /usr/local/bin/magictar
sudo chmod +x /usr/local/bin/magictar

```


3. You can now launch the utility by typing `magictar` in any terminal session.

### Remote Execution

To run the script directly from a local network server (e.g., Nginx) without permanent installation:

```bash
bash <(curl -fsSL http://<your-ip:port>/scripts/magictar.sh)

```

## Usage

### 1. Archiving

* Select option **1** from the main menu.
* **Source:** Provide the absolute path to the directory you wish to archive.
* **Destination:** Specify the directory where the `.tar` file should be stored. If the directory does not exist, the script will attempt to create it.
* **Output:** The archive is named using the format `Foldername_YYYY-MM-DD.tar`.

### 2. Restoring

* Select option **2** from the main menu.
* **Archive Path:** Enter the full path to the `.tar` file.
* **Target:** Enter the destination directory. The script will extract the contents while maintaining the original directory structure and permissions.

