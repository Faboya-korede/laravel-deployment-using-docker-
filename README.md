# Laravel Setup Using Docker

## Prerequisites
### Before you start, you will need:

1.  A linux operating system download or you can use a cloud provider
2. Docker installed
3.docker-compose installed.

## Step 1 clone the laravel app repo and  install its Dependencies:
     git clone https://github.com/laravel/laravel.git laravel-app

After it is done cloning, move into your `laravel-app` directory and use Docker’s composer image to mount the directories that you will need for your Laravel project and avoid the overhead of installing Composer globally with the below command:

     docker run --rm -v $(pwd):/app composer install

The -v and -rm create an an ephemeral container that will be bind-mounted to your current directory before being removed. And copy the content of you laravel-app directory to the container and also make sure that the vendor folder Composer creates inside the container is copied to your current directory.

The next step is to set a permissions on the laravel-app project directory so that it is owned by your non-root user

    sudo chown -R $USER:$USER ~/laravel-app

## Step 2 Create a docker-compose file for Our Laravel-App Application
Docker Compose simplifies the process of building and deploying an application. Once you have defined the configurations and services, you can easily deploy your application in any host machine that has Docker and Docker Compose installed without worrying about the application dependencies.

## Step 3 create a Dockerfile
Dockerfile includes instructions that Docker can use to build custom Docker images. It can also install the software required and configure the necessary settings for your application.

## Step 4 Configure php
In this step, we will configure the php service to process incoming requests from Nginx. You will create a laravel.ini file inside the php directory. This file will hold the PHP configurations. This is the file you had bind-mounted to /usr/local/etc/php/conf.d/laravel.ini in the container . The configurations in this file override the default php.ini file usually read by PHP when it starts. Enter the following command to create the php directory:
          
          mkdir ~/laravel-web/php
             
          nano ~/laravel-web/php/laravel.ini

         upload_max_filesize=80M
         post_max_size=80M

## Step 5 Configure Nginx
In this step, we will configure Nginx to use the php service we defined earlier. It will use PHP-FPM as the FastCGI server to serve dynamic content. FastCGI server is a software that enables interactive programs to interface with a web server.
      
      mkdir -p ~/laravel-web/nginx/conf.d

       nano ~/laravel-web/nginx/conf.d/app.conf

### Add the following configurations:


  `server {
listen 80;
    index index.php index.html;
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root /var/www/public;
    location ~ \.php$ {
try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass app:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
location / {
try_files $uri $uri/ /index.php?$query_string;
        gzip_static on;
  }
}`

## Step 6 Configure MySQL
    mkdir ~/laravel-web/mysql
   
    nano ~/laravel-web/mysql/my.cnf
 	
     [mysqld]
     general_log = 1
     general_log_file = /var/lib/mysql/general.log`

## Step 7  Set Laravel Environment Variables

         cp .env.example .env

           nano .env

           DB_HOST= is the db database container.
           DB_DATABASE=is the laravel_web.
           DB_USERNAME =is the username for the database. Pick a name of your choice.
           DB_PASSWORD= yor password
           DB_CONNECTION=mysql

## Step 8
Run
     
     docker-compose build my app

## Step9
Run

        docker-compose up -d

## Step 10
Run

        docker-compose exec app composer install

## Step 11
Run

           docker-compose exec app php artisan key:generate

## Step 12
Run

           docker-compose exec app php artisan migrate 
