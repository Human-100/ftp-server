#!/bin/bash
# Replace ftpuser with your FTP username.
# Replace password with a your password.
FTP_USER="ftpuser"  
FTP_PASS="password" 
PASSIVE_MIN_PORT=10000
PASSIVE_MAX_PORT=10100
VSFTPD_CONF="/etc/vsftpd.conf"
USERLIST_FILE="/etc/vsftpd.userlist"


sudo apt update -y
sudo apt upgrade -y

sudo apt install vsftpd -y

echo "Creating FTP user..."
sudo adduser "$FTP_USER"
echo "$FTP_PASS" | sudo passwd --stdin "$FTP_USER"

sudo mkdir -p "/home/$FTP_USER/ftp"
sudo chown root:root "/home/$FTP_USER"
sudo chown "$FTP_USER":"$FTP_USER" "/home/$FTP_USER/ftp"
sudo chmod 755 "/home/$FTP_USER/ftp"

cat << EOF | sudo tee "$VSFTPD_CONF"
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=$PASSIVE_MIN_PORT
pasv_max_port=$PASSIVE_MAX_PORT
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO
userlist_enable=YES
userlist_file=$USERLIST_FILE
userlist_deny=NO
EOF

echo "$FTP_USER" | sudo tee -a "$USERLIST_FILE"

sudo ufw allow 21/tcp
sudo ufw allow "$PASSIVE_MIN_PORT":"$PASSIVE_MAX_PORT"/tcp
sudo ufw reload

if command -v getenforce &>/dev/null; then #Check if getenforce exists (SELinux)
    if getenforce | grep -q "Enforcing"; then
        echo "SELinux is enforcing. Configuring for FTP..."
        sudo setsebool -P allow_ftpd_full_access 1
    fi
fi

sudo systemctl restart vsftpd

echo "Checking vsftpd status..."
sudo systemctl status vsftpd

echo "FTP server setup complete!"
echo "Connect to your server using the username: $FTP_USER and the password you set."
echo "Remember to open port 21 and $PASSIVE_MIN_PORT-$PASSIVE_MAX_PORT on any external firewalls."