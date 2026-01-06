FROM python:3.11-slim

WORKDIR /app

# --no-install-recommends for avoiding unnecessary recommended installations and rm -rf... for removing installation metadata
RUN apt-get update && apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*

# For better cache usage
COPY ./app/api/requirements.txt /app/api/requirements.txt 

# --no-cache-dir tells pip not to store downloaded packages in its cache
RUN pip install --no-cache-dir -r /app/api/requirements.txt

COPY ./app .

EXPOSE 8000

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]