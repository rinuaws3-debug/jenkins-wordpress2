FROM wordpress:php8.2-apache

# Copy your theme or plugins if you have them in repo
COPY ./wp-content /var/www/html/wp-content

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/wp-content

