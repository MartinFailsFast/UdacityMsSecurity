#FROM python:3.10-slim
FROM python:3.9-slim

# Install system dependencies (netcat, wget, etc.)
RUN apt-get update && \
    apt-get install -y netcat-openbsd wget gcc python3-dev libffi-dev libpq-dev musl-dev && \
    apt-get clean && \
    echo "System dependencies installed."

# Install wait-for utility for healthchecks (if you need it)
RUN wget -O /usr/bin/wait-for https://raw.githubusercontent.com/eficode/wait-for/master/wait-for && \
    chmod +x /usr/bin/wait-for && \
    echo "Wait-for utility installed."

# Copy requirements file to temporary location
COPY requirements.txt /tmp

# Upgrade pip and install the requirements
RUN pip install --upgrade pip setuptools wheel && \
    echo "Pip upgraded." && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    echo "Python dependencies installed."

# Clean up requirements file
RUN rm -rf /tmp/requirements.txt && \
    echo "Requirements file cleaned up."

# Set the working directory and copy application files
WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config

# Set the entry point (if needed, e.g., to start a script)
CMD ["python", "run.py"]
