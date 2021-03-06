# Build AMI for S3 backed Atmos blob

### Describtion

This AMI runs a nginx, proxies HTTP request to a static website enabled S3 bucket. The url of the S3 bucket is passed from User Data when instances are launched

### Steps for building the AMI

Launch a EC2 instance by cloning a Amazon public AMI. ` ami-vpc-nat-1.1.0-beta.x86-64-ebs (ami-f619c29f)` is used as of now.

Login as `ec2-user`

Run

	yum update
	yum install nginx

Disable unused services

	chkconfig iptables off
	chkconfig ip6tables off
	chkconfig sendmail off

Edit `/etc/nginx/nginx.conf`, add the following line into the ` location / {}` section

	proxy_pass http://blob.cfblob.com

Run

	mkdir -p /var/lib/cloud/data/scripts

Create a shell script `/var/lib/cloud/data/scripts/nginx_conf`, with the following content:

	#!/bin/bash
	url=`curl -sL  http://169.254.169.254/latest/user-data | sed "s#http://##" | tr -d " " `
	sed -i "s/blob.cfblob.com/$url/" /etc/nginx/nginx.conf
	/etc/init.d/nginx restart && chkconfig nginx on

Convert the instance to AMI.
    
The latest ami as of now, is `ami-c983e0a0`, shared on AWS account `garyliu`.

