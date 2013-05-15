# Build AMI for S3 backed Atmos blob

- clone a Amazon public AMI. ` ami-vpc-nat-1.1.0-beta.x86-64-ebs (ami-f619c29f)` is used as of now.

- login as `ec2-user`

- Run

	yum update
	yum install nginx

- disable unused services

	chkconfig iptables off
	chkconfig ip6tables off
	chkconfig sendmail off

- edit `/etc/nginx/nginx.conf`, add the following line into the ` location / {}` section

	proxy_pass http://blob.cfblob.com

- Run

	mkdir -p /var/lib/cloud/data/scripts

- create a script file called nginx_conf, with the following content

	#\!/bin/bash
	url=\`curl -sL  http://169.254.169.254/latest/user-data | sed "s#http://##" | tr -d " " \`
	sed -i "s/blob.cfblob.com/$url/" /etc/nginx/nginx.conf
	/etc/init.d/nginx restart && chkconfig nginx on

    
- the latest ami as of now, is `ami-c983e0a0`, shared on AWS account `garyliu`.

