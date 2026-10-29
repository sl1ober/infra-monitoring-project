# Infra Monitoring Project
 
A DevOps project for API availability monitoring, log analysis, network traffic inspection, and containerized deployment.
 
## Project components
 
- `check_api.sh` — checks API availability and HTTP response codes.
- `analyze_logs.sh` — generates and analyzes an access log containing 300 requests.
- Wireshark — captures and analyzes HTTP traffic.
- Docker Compose — runs an API service and an Nginx reverse proxy.
- GitHub Actions — validates Bash scripts and tests API availability.
- SSH/SCP — provides examples of secure remote access and file transfer.
 
## Requirements
 
- Linux
- Git
- Docker Engine
- Docker Compose
- curl
- Wireshark (for traffic analysis)
 
## Running the project
 
Start the services:
 
```bash
docker compose up -d
```
 
Check the container status:
 
```bash
docker compose ps
```
 
Test the service through Nginx:
 
```bash
curl -i http://localhost:80
```
 
Expected response body:
 
```text
Monitoring Service Active
```
 
Stop the services:
 
```bash
docker compose down
```
 
## API availability check
 
Run the API check script with a URL:
 
```bash
bash check_api.sh https://httpbin.org/status/200
```
 
The script returns exit code `0` for HTTP 200 and a non-zero exit code for an unsuccessful request.
 
## Log analysis
 
Run the log analysis script:
 
```bash
bash analyze_logs.sh
```
 
The script generates `logs/access.log` with 300 test requests and reports the total number of requests, the top three IP addresses, and the counts of HTTP 4xx and 5xx responses.
 
The analysis uses `grep`, `awk`, `sort`, `uniq`, and regular expressions.
 
## Network traffic analysis
 
Capture HTTP traffic in Wireshark and apply the display filter:
 
```text
http
```
 
Save the capture as a `.pcapng` file. Inspect source and destination IP addresses, HTTP methods, and response status codes.
 
## Git development workflow
 
Development is performed in the `feature/monitoring` branch. Changes are proposed for integration into `main` through a Pull Request. GitHub Actions validates the Bash scripts and checks API availability.
 
## SSH and SCP deployment guide
 
The following commands are examples for a remote Linux server. Replace `user` and `SERVER_IP` with the actual remote username and server address.
 
### 1. Generate an SSH key pair
 
```bash
ssh-keygen -t ed25519 -C "infra-monitoring-project"
```
 
Follow the prompts to save the key pair. The private key must remain secret.
 
### 2. Install the public key on the server
 
```bash
ssh-copy-id user@SERVER_IP
```
 
This enables key-based SSH authentication, provided the server permits it and you have authorized access.
 
### 3. Create a project archive
 
Run this command from the project directory's parent:
 
```bash
tar --exclude='.git' --exclude='*.pcapng' \
    -czf infra-monitoring-project.tar.gz infra-monitoring-project
```
 
### 4. Transfer the archive using SCP
 
```bash
scp infra-monitoring-project.tar.gz user@SERVER_IP:~/
```
 
### 5. Connect to the remote server
 
```bash
ssh user@SERVER_IP
```
 
### 6. Extract and start the project
 
On the remote server, run:
 
```bash
mkdir -p ~/infra-monitoring-project
tar -xzf ~/infra-monitoring-project.tar.gz -C ~
cd ~/infra-monitoring-project
docker compose up -d
docker compose ps
```
 
The remote server must have Docker Engine and the Docker Compose plugin installed. Port 80 must also be available for the Nginx service.
 
## Security notes
 
- Never commit private SSH keys, passwords, or access tokens.
- Do not publish packet captures containing sensitive traffic.
- Use SSH only with servers you are authorized to access.

