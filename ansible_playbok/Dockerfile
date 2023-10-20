# Use an official PHP image as the base image
FROM php:8.2-cli

# Set the working directory in the container
WORKDIR /app

# Copy the PHP files from your local directory to the container
COPY . /app

# Expose the port that the PHP development server will listen on
EXPOSE 8000

# Define the command to start the PHP development server
CMD ["php", "-S", "0.0.0.0:8080"]
