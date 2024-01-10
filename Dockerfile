# Use a lightweight Python image for the builder stage
FROM python:3.9-slim-buster as builder

# Set the working directory in the builder stage
WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y build-essential

# Copy only the requirements file to leverage Docker cache
COPY requirements.txt /app/

# Create and activate a virtual environment
RUN python3 -m venv /venv && /venv/bin/pip install --upgrade pip

# Install Python dependencies
RUN /venv/bin/pip install --no-cache-dir -r requirements.txt

# Stage 2: Create the final lightweight image
FROM python:3.9-slim-buster

# Set the working directory
WORKDIR /app

# Copy the virtual environment from the builder stage
COPY --from=builder /venv /venv

# Copy the application code to the working directory
COPY . .

# Expose the port that Flask app runs on
EXPOSE 5000

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0


# Create and switch to a non-root user
RUN useradd --system --uid 1000 flaskuser && \
    chown -R flaskuser:flaskuser /app

USER flaskuser


# Default command to run the Flask application
CMD ["/venv/bin/python", "-m", "flask", "run"]
