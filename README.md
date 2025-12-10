![Screenshot](main.png)

**SecureUploads** is a lightweight Bash tool that deploys a temporary and isolated file-upload endpoint using **Nginx**.
It is designed for **pentesting**, **secure file transfer**, and controlled **data-exfiltration simulations**.

The script automatically sets up an HTTP/HTTPS server, optional authentication, upload limits, and real-time monitoring of incoming files.

---

# Installation



---

## Features

* One-command generation of a secure upload server
* Automatic HTTPS with self-signed certificates
* Optional custom certificates (useful to evade IDS detection)
* Basic Authentication support
* Token-based authentication
* Randomized upload directory
* Upload size limits
* Automatic Nginx configuration cleanup on exit
* Real-time file monitoring (inotifywait)

---

## How It Works

SecureUploads dynamically generates an Nginx configuration based on your parameters.
Once launched:

1. A random or custom upload directory is created inside `/var/www/uploads/`.
2. HTTPS is enabled unless `--no-sec` is used.
3. Authentication (token or basic) is enforced if enabled.
4. The upload folder is monitored in real time for incoming files.
5. Pressing **CTRL+C** stops the server and automatically:

   * Removes temporary Nginx configs
   * Moves received files to a local folder
   * Cleans all certificates and temporary paths

---

## Usage

```
sudo secureuploads [OPTIONS]
```

---

## Use Cases

* **Pentesting**: Quickly deploy a secure upload endpoint during engagements.
* **Exfiltration simulation**: Test how security controls react to HTTPS, random paths, tokens, or basic-auth uploads.
* **Secure file sharing**: Send files between machines inside a secure network.
* **Temporary dropzone**: A simple HTTPS PUT server without needing large frameworks.

---

## Parameters Overview

| Parameter                    | Description                                                                |
| ---------------------------- | -------------------------------------------------------------------------- |
| `-p, --port <number>`        | Sets the server port. Default: **443**                                     |
| `--no-sec`                   | Disables HTTPS and runs only HTTP                                          |
| `--basic-auth <user> <pass>` | Enables Basic Authentication                                               |
| `--token-auth`               | Enables token-based authentication. Requests must include `token: <value>` |
| `--random-dir`               | Creates a random upload directory (ex: `a91ce3cd2fbd`)                     |
| `--up-size <size>`           | Sets max upload size (`10M`, `500K`, `1G`, etc.)                           |
| `--custom-cert <cert> <key>` | Uses your certificates instead of auto-generated ones                      |
| `-h, --help`                 | Show help menu                                                             |

---

## Examples

### 1. Token Authentication + Random Directory

```
sudo secureuploads --token-auth --random-dir
```

### 2. Basic Auth + Custom Port

```
sudo secureuploads --basic-auth admin password123 -p 8443
```

### 3. HTTP Only (no HTTPS)

```
sudo secureuploads --no-sec --random-dir
```

### 4. Limit Upload Size to 50MB

```
sudo secureuploads --up-size 50M
```

### 5. Using Custom Certificates

```
sudo secureuploads --custom-cert mycert.pem mykey.key
```

---

## Uploading Files

Once the server is running, upload a file using:

### Using cURL:

```
curl -T <file> <server_url>/<upload_dir>
```

If token auth is enabled:

```
curl -T file.zip https://<server>/<dir> -H "token: <generated_token>"
```

If using basic auth:

```
curl -T file.txt https://<server>/<dir> -u user:pass
```
