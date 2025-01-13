# FTP Server
This Project is a Linux based FTP Server I created using `vsftpd` (Very Secure FTP Daemon).
This repo contains an automation script, that i have compiled for an easier installation. You can further customize the Server by through editing the vsftpd.conf cofig files. 

Now if you want to manually set everything up
Here is what I did.

1. Upgarde and Update your system
    ```bash
    sudo apt upgrade -y
    sudo apt update
    ```
3. Install ``` sudo apt install vsftpd -y```
#### Configure ```sudo nano /etc/vsftpd.conf```
3. Config details
	- `anonymous_enable=NO`: Disables anonymous logins (recommended for security).
	- `local_enable=YES`: Enables local user logins.
	- `write_enable=YES`: Allows users to upload files.
	- `chroot_local_user=YES`: Jails users to their home directories (highly recommended for security).
	- `allow_writeable_chroot=YES`: Needed if you want to allow users to write inside their home directory, this has security implications so consider carefully.
	- `pasv_enable=YES`: Enables passive mode (often needed for clients behind NAT or firewalls).
	- `pasv_min_port=1024`: Set the minimum port for passive connections.
	- `pasv_max_port=1048`: Set the maximum port for passive connections.
#### What I  enabled
	   local_enable=YES
	   write_enable=YES
	   chroot_local_user = yes
   Add these 2 lines at the bottom (will ensure correct routes for users)
		   1. user_sub_token=$USER
		   2. local_root=/home/$USER/ftp
	Also add these 2 ports for passive mode and will be used if there is any firewall issue and port 21 and 20 cant be accessed
		   1. pasv_min_port=10000
		   2. pasv_max_port=10100
			and saved then file
#### Configure firewalls and enable pasv ports
	- sudo ufw allow from any to any port 20,21,10000:10100 proto tcp
	
#### Now Create a User that will access a specific folder under their home directory use Sudo useradd abid

#### Create a ftp directory for the user
eg. sudo mkdir /home/abid/ftp
also configure ownership and permissions like
eg. 
sudo chown nobody:nogroup /home/abid/ftp
sudo chmod a-w /home/abid/ftp

#### Create upload directory for new user
sudo mkdir /home/abid/ftp/upload

#### Add user's ownership to that folder
sudo chown abid:abid /home/abid/ftp/upload

#### Now to Test 
1. Creating a demo file in that folder
		echo "My FTP Server" | sudo tee /home/abid/ftp/upload/demo.txt
2. use ls -l to check permissions also
#### Add user to ftp userlist file to login
echo "abid" | sudo tee -a /etc/vsftpd.userlist

#### Add this in the config so only users in list can access ftp server





#### My config file
```bash
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=10000
pasv_max_port=10100
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO

```

