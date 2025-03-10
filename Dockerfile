FROM python:3.10-slim

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=apns.settings

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
COPY requirements/base.txt base.txt
COPY requirements/prod.txt prod.txt
RUN pip install --no-cache-dir -r prod.txt

# 复制项目文件
COPY . .

# 收集静态文件
RUN mkdir -p /app/staticfiles
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

# 暴露端口
EXPOSE 8000

# 默认命令
CMD ["python", "manage.py", "runserver", "0.0.0.0:8003"]