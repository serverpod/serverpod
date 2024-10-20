# Serverpod Deployment to a VPS using Docker

<!-- TODO(Paul): Re-do the intro and explanation, this setup is sufficient for any startup and small builds as it can scale vertically with the virtual instances until very big loads and could even be extended to scale horizontally using Hetzner's load balancers -->

This is a workflow to deploy your Serverpod to a single machine using
docker-compose. This is useful for testing and small deployments. For larger
deployments, you should use the deployment-aws.ml or deployment-gcp.yml
workflows. To reduce the workload on the machine we do not use redis in this
deployment. If you want to use redis, you need to add it to the docker-compose
file and the serverpod configuration. You need to setup the correct hostnames in
the docker-compose-production file AND the serverpod configuration file.

- [Preparing the server](#preparing-the-server)
  - [Registering at Hetzner Cloud](#registering-at-hetzner-cloud)
  - [Setting up an SSH key to connect to the server](#setting-up-an-ssh-key-to-connect-to-the-server)
  - [Creating a new server](#creating-a-new-server)
  - [Setting up the server](#setting-up-the-server)
    - [Step 1: Create the new user](#step-1-create-the-new-user)
    - [Step 2: Grant Docker permissions](#step-2-grant-docker-permissions)
    - [Step 3: Enable SSH access](#step-3-enable-ssh-access)
    - [Step 4: Set up SSH key-based authentication](#step-4-set-up-ssh-key-based-authentication)
  - [Firewall configuration](#firewall-configuration)
- [Preparing the domain](#preparing-the-domain)
- [Preparing the repository](#preparing-the-repository)
  - [Getting a GitHub Personal Access Token](#getting-a-github-personal-access-token)
  - [Adding the secrets to the repository](#adding-the-secrets-to-the-repository)
- [Configuring SSL-certificates](#configuring-ssl-certificates)
- [Configuring the action](#configuring-the-action)
- [Running the action](#running-the-action)
- [Using the Serverpod Insights app](#using-the-serverpod-insights-app)
- [Connecting your Flutter client](#connecting-your-flutter-client)
- [Connecting to the Database using DBeaver](#connecting-to-the-database-using-dbeaver)

## Preparing the server

This guide uses the "Hetzner" Cloud, you can use any server hoster, Hetzner is just a good and cheap option.
If you want to use another architecture or hoster, check the docker-compose file and the deployment script for any necessary changes. Currently, the deployment is meant to run on ARM machines.

### Registering at Hetzner Cloud

Register an account at Hetzner Cloud and create a new project.
Using this referral link you get 20€ for free: [Hetzner Cloud](https://hetzner.cloud/?ref=BFdFFipLgfDs)

Next, go to the ["Cloud Console"](https://console.hetzner.cloud/) and create a project.

### Setting up an SSH key to connect to the server

In order to configure your server, you need to access it through ssh.
Create a SSH keypair if you don't have one yet.
If you are not sure whether you already have one, you can check by running:

```bash
cat ~/.ssh/id_rsa.pub
```

To create a new keypair, run:

Leave any options at their default values by pressing enter.

```bash
ssh-keygen -t rsa -b 4096
```

When asked for a password, just press enter.
This will create a keypair in `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`.

Copy the public key to the clipboard:

```bash
cat ~/.ssh/id_rsa.pub
```

Select the output and copy it to the clipboard.

In your Hetzner project, follow these steps:

1. Left hand-side, click on "Security" -> "SSH keys" -> "Add SSH key"
2. Add the public key you generated earlier.

### Creating a new server

Continuing in your Hetzner project, create a new server:

1. Left hand-side, go to "Server" and click "Create server"
2. In the "Image" section, click on "Apps" and select "Docker CE"
3. **Type/Architecture: Select "vCPU" and "Arm64 (Ampere)"**, the smallest tier is sufficient for most projects. You can always upgrade the specs of your server.
4. Make sure to keep the public IPv4 address.
5. SSH-Keys section, make sure your SSH-key is selected.
6. Name your server and create it.

### Setting up the server

Once the server is created, you can connect to it using SSH. Find the server ip
in the Hetzner Cloud Console and connect to it using the following command:

```bash
ssh root@<your-server-ip>
```

When prompted "Are you sure you want to continue connecting? [...]", type "yes" and press enter.

> In case you are asked for a password, the SSH key was not added correctly. You should delete the row with the ip from known_hosts (`~/.ssh/known_hosts`) and delete the server. Then create a new server and make sure to add the SSH key correctly.

For security reasons, we will create a new user to manage the deployment. This
user will not have root privileges.

#### Step 1: Create the new user

```bash
sudo adduser github-actions
```

Replace `github-actions` with your desired username. This command will prompt
you to set a password and fill in user information.

#### Step 2: Grant Docker permissions

Add the user to the `docker` group, so they can run Docker commands:

```bash
sudo usermod -aG docker github-actions
```

#### Step 3: Enable SSH access

The SSH access should be available by default for any user on the server.
However, to ensure they can access it, check the `sshd_config` file:

```bash
sudo nano /etc/ssh/sshd_config
```

Find or add the AllowUsers directive in the file. This directive specifies which
users are allowed to SSH into the server. If it doesn't exist, add it at the end
of the file. If there are multiple users, separate them with spaces:

```text
AllowUsers root github-actions
```

To save and exit the file, press `Ctrl + X`, then `Y`, and finally `Enter`.
Save the file and restart the SSH service to apply changes:

```bash
sudo systemctl restart ssh
```

#### Step 4: Set up SSH key-based authentication

1. Log in as the new user:

   ```bash
   su - github-actions
   ```

2. Create a ssh keypair:

   ```bash
   ssh-keygen -t rsa -b 4096
   ```

   Leave any options at their default values by pressing enter.

3. Add your public SSH key to the `authorized_keys` file:

   ```bash
   cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
   ```

4. Restart the SSH service to apply changes:

   ```bash
   sudo systemctl restart ssh
   ```

Copy the private key to the clipboard, including the lines `-----BEGIN OPENSSH PRIVATE KEY-----` and ending with `-----END OPEN SSH PRIVATE KEY-----`. Save this key in a secure place, you will need it later.

```bash
cat ~/.ssh/id_rsa
```

### Firewall configuration

Enter your server configuration and click on "Firewalls", then click on "Create Firewall".

By default there will be two inbound rules, one for SSH (Which has Port 22) and one for ICMP (which has protocol set to ICMP).

We will add two more for HTTP and HTTPS.

1. Click on "Add Rule", name it HTTP and set the port to 80 and the protocol to TCP.
2. Click on "Add Rule", name it HTTPS and set the port to 443 and the protocol to TCP.
3. Make sure in "apply to" section your server is selected.
4. Click on "Create Firewall".

## Preparing the domain

In order to be able to access your server, you need to have a domain.
You can buy a domain from any domain provider, e.g., [Namecheap](https://www.namecheap.com/) or [GoDaddy](https://www.godaddy.com/).

Once you have a domain, you need to set up the DNS records to point to your server.

Create the following DNS records, replacing `Your server IP` with the IP address of your server.
The setup is configured to use a reverse proxy to route the traffic to the correct service.

| Type | Name     | Value          |
| ---- | -------- | -------------- |
| A    | api      | Your server IP |
| A    | web      | Your server IP |
| A    | insights | Your server IP |

The full domain will be `api.your-domain.com`, `web.your-domain.com`, and `insights.your-domain.com`.

## Preparing the repository

### Getting a GitHub Personal Access Token

Create a new Personal-Access-Token (PAT) on GitHub.
Click on your profile picture in the top right corner, go to settings, (very
bottom) developer settings, personal access tokens, Tokens (classic), and click
on "Generate new token".
In the "Note" field at the top, set a name for the token, e.g., "Serverpod Deployment".
Set the expiration time to "No expiration" and check these scopes:

- **repo** (required to read repositories, especially private ones, i.e. accessing
  packages in a different repository)
- **write:packages** (required to push docker images to the GitHub package registry)

At the bottom, click on "Generate token", copy the token and save it somewhere safe.

### Adding the secrets to the repository

Go to your serverpod project repository, "Settings" -> "Secrets and variables"
-> "Actions" and create the following secrets:

| Secret Name     | Value                                                               |
| --------------- | ------------------------------------------------------------------- |
| PAT_USER_GITHUB | Your GitHub username here                                           |
| PAT_GITHUB      | Your GitHub PAT token here                                          |
| SSH_HOST        | The IP address of your server here                                  |
| SSH_USER        | The username you created on the server here, e.g., "github-actions" |
| SSH_PRIVATE_KEY | The private key you generated on the server here                    |

The following will configure serverpod and the database:

| Secret Name                           | Value                                                                                                                                        |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| SERVERPOD_DATABASE_NAME               | The name of the database, e.g., "serverpod"                                                                                                  |
| SERVERPOD_DATABASE_USER               | The database user, e.g., "serverpod"                                                                                                         |
| SERVERPOD_DATABASE_PASSWORD           | The database password                                                                                                                        |
| SERVERPOD_API_SERVER_PUBLIC_HOST      | The domain for the API server as configured in the section, (i.e. api.my-domain.com) [Preparing the domain](#preparing-the-domain)           |
| SERVERPOD_WEB_SERVER_PUBLIC_HOST      | The domain for the Web server as configured in the section, (i.e. web.my-domain.com) [Preparing the domain](#preparing-the-domain)           |
| SERVERPOD_INSIGHTS_SERVER_PUBLIC_HOST | The domain for the Insights server as configured in the section, (i.e. insights.my-domain.com) [Preparing the domain](#preparing-the-domain) |
| SERVERPOD_SERVICE_SECRET              | The same value as in your local passwords.yaml file, required to connect using the Serverpod Insights app                                    |

## Configuring SSL-certificates

All outside connections are secured by Traefik through https. Traefik uses
[letsencrypt](https://letsencrypt.org/) to automatically generate
SSL-certificates for your domains. You need to configure the email address that
letsencrypt will use to send notifications about your certificates.

Open `docker-compose.production.yaml` and edit the email address in the
parameter holding `certificatesresolvers.myresolver.acme.email`. There is also a
`TODO` above this line for your convenience.

## Configuring the action

From the root of your repository, open the `.github/workflows/deployment-docker.yml` file and adjust the following settings:

- Adjust the `GHCR_ORG` variable and replace `<ORGANIZATION>` with your GitHub
  username, or the organization name if you got one.
- At the top, you can change the branches that automatically trigger the
  deployment. By default, it is set to `deployment-docker-production`. You can
  always trigger the action manually to run it on a different branch.

## Running the action

Push your changes to the repository.

To trigger the action, go to the "Actions" tab in your repository and click on
the "Deploy to Docker" workflow. Click on "Run workflow" and select the branch
you want to deploy.

## Using the Serverpod Insights app

To enable the [Serverpod Insights
app](https://docs.serverpod.dev/tools/insights), you need to adjust the insights
server host in production.yaml to the domain you set up in the DNS records. The
service secret you specify in the repository secrets must match the one you set
in the local passwords.yaml file for production.

## Connecting your Flutter client

To connect with your generated client, use the domain you set up in the DNS.
Make sure to use https without any ports, i.e. `https://api.my-domain.com`.

## Connecting to the Database using DBeaver

Setup connection via ssh then use postgres for host and password for password.

TODO TODO TODO
