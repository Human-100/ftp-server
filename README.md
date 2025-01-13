# FTP Server
This project is a Linux-based FTP server created using vsftpd (Very Secure FTP Daemon)
<br><br>
Included in this repository is an automation script I created for easy installation, with options for further customization by editing the vsftpd.conf configuration files.<br><br>
Now if you want to manually set everything up. 
Here is what I did.

1. Upgarde and Update your system

    ```bash
    sudo apt upgrade -y
    sudo apt update
    ```
2. Install vsftpd

   ```bash
 	sudo apt install vsftpd -y
3. Now configure the server using the text editor of your choice

   ```bash
	sudo nano /etc/vsftpd.conf
   ```
	Here is the all the config details
	- `anonymous_enable=NO`: Disables anonymous logins (recommended for security).
	- `local_enable=YES`: Enables local user logins.
	- `write_enable=YES`: Allows users to upload files.
	- `chroot_local_user=YES`: Jails users to their home directories (highly recommended for security).
	- `allow_writeable_chroot=YES`: Needed if you want to allow users to write inside their home directory, this has security implications so consider carefully.
	- `pasv_enable=YES`: Enables passive mode (often needed for clients behind NAT or firewalls).
	- `pasv_min_port=1024`: Set the minimum port for passive connections.
	- `pasv_max_port=1048`: Set the maximum port for passive connections.
	
	#### My Configuration (For Reference)
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

4. Configure firewalls and enable passive connection ports

	```bash
 	sudo ufw allow from any to any port 20,21,10000:10100 proto tcp
  	```
5. Now Create a User that will access a specific folder under their home directory

	```bash
 	sudo useradd <user_name>
 	```

6. Create a ftp directory for the user

	```bash
 	sudo mkdir /home/<user_name>/ftp
 	```
	Also configure ownership and permissions of the directory

	```bash
	sudo chown nobody:nogroup /home/abid/ftp
	sudo chmod a-w /home/abid/ftp
	```
7. Create an upload directory for the user

	```bash
	sudo mkdir /home/<user_name>/ftp/upload
	```
8.  Set the ownership to the user

	```bash
	sudo chown <user_name>:<user_name> /home/<user_name>/ftp/upload
	```
9. Now test your config 
	1. Creating a demo file in that folder

		```bash
  		echo "My FTP Server" | sudo tee /home/abid/ftp/upload/demo.txt
  		```
	2. Check its permissions

		```bash
  		cd /home/abid/ftp/upload
  		ls -l
  		```
10. Add user to ftp userlist which will enable the user to login

	```bash
 	echo "abid" | sudo tee -a /etc/vsftpd.userlist
	```
11. Update vsftpd.config so only approved users from the list can access the ftp server

	```bash
 	userlist_enable=YES
	userlist_file=/etc/vsftpd.userlist
	userlist_deny=NO
 	```
	As i have already shown in My Configuration.

12. Now use an FTP client with the server_ip, user_name and password you created and enjoy.

;)

