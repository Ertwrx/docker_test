# Stage 1: Build Stage
FROM python:3.8-slim AS build

# Set the working directory to /app
WORKDIR /app

# Copy only the requirements file to the container
COPY requirements.txt .

# Install required packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Gunicorn configuration file
COPY gunicorn_config.py .

# Copy the rest of the application files
COPY . .

# Stage 2: Production Stage
FROM python:3.8-slim AS production

# Set the working directory to /app
WORKDIR /app

# Copy only necessary files from the build stage
COPY --from=build /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=build /usr/local/bin/gunicorn /usr/local/bin/gunicorn
COPY --from=build /app .

# Copy the Gunicorn configuration file
COPY --from=build /app/gunicorn_config.py .

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable
ENV NAME docker_test

# Run app.py using Gunicorn with the specified configuration
CMD ["gunicorn", "--config", "gunicorn_config.py", "app:app"]
