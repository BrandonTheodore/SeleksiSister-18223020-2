FROM python:3.11-slim

RUN apt-get update && \
    apt-get install -y gnucobol && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN pip install uvicorn fastapi

RUN cobc -x -o main main.cob

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]