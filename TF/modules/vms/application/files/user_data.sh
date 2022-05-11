#!/bin/bash
sudo yum install -y httpd.x86_64
sudo systemctl enable httpd
sudo systemctl start httpd

echo '<!DOCTYPE html><html><body><h1 id="DevTestSecOps">AWS EC2</h1><table border="1" style="border-collapse: collapse; width: 100%;"><tbody><tr>' >index.html

for var in AWS_Account_ID Date_creation Name OS_type Your_First_Name Your_Last_Name
do
    echo '<td style="width: 20%;">' $var '</td>' >>index.html
done

echo '</tr><tr>' >>index.html

for var in AWS_Account_ID Date_creation Name OS_type Your_First_Name Your_Last_Name
do
    magic=$(curl http://169.254.169.254/latest/meta-data/tags/instance/$var)
    echo '<td style="width: 20%;">' $magic '</td>' >>index.html
done

echo '</tr></tbody></table></body></html>' >>index.html

sudo cp index.html /var/www/html/