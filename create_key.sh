ssh-keygen -t rsa -b 2048 -v -f jupyter -N ''
mv jupyter jupyter.pem
chmod 400 jupyter.pem
