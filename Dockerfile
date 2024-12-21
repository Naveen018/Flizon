FROM python:3.10.16-alpine

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1  # Prevent Python from writing .pyc files
ENV PYTHONUNBUFFERED 1        # Ensure Python output is displayed in real-time

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
