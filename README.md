# githot

## SSH Container Passthrough

### SSHing Shim (with authorized_keys)

On the host create the git user which shares the same UID/ GID as the container values USER_UID/ USER_GID. 

```shell
# root 身份执行
groupadd -g 1000 git
useradd git -m -u 1000 -g git -s /bin/bash
passwd git
```

Now a SSH key pair needs to be created on the host.

```shell
sudo -u git ssh-keygen -t ed25519 -C "Githot Host Key"
```

/home/git/.ssh/authorized_keys on the host now needs to be modified.

```shell
sudo -u git cat /home/git/.ssh/id_ed25519.pub | sudo -u git tee -a /home/git/.ssh/authorized_keys
sudo -u git chmod 600 /home/git/.ssh/authorized_keys
```

Create the fake host gitea command that will forward commands from the host to the container. The name of this file depends on your version of Gitea:

```shell
cat <<"EOF" | sudo tee /usr/local/bin/gitea
#!/bin/sh
ssh -p 2222 -o StrictHostKeyChecking=no git@127.0.0.1 "SSH_ORIGINAL_COMMAND=\"$SSH_ORIGINAL_COMMAND\" $0 $@"
EOF
sudo chmod +x /usr/local/bin/gitea
```

