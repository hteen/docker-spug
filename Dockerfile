FROM docker

ENV SPUG_VERSION 2.3.12

RUN set -eux; \
    # 加速 github
    # wget -q -O - https://gitee.com/xueweihan/codes/6g793pm2k1hacwfbyesl464/raw?blob_name=GitHub520.yml | tee -a /etc/hosts; \
    # 阿里云源
    # echo -e 'https://mirrors.aliyun.com/alpine/v3.12/main/' > /etc/apk/repositories; \
    # echo -e 'https://mirrors.aliyun.com/alpine/v3.12/community/' >> /etc/apk/repositories; \
    # apk update; \
    # 安装必备组件
    apk add --no-cache nginx git openldap-dev supervisor redis bash; \
    # 安装编译组件
    apk add --no-cache --virtual .build-deps build-base openssl-dev gcc musl-dev python3-dev libffi-dev openssh-client make; \
    mkdir /spug; \
    mkdir /etc/supervisor.d/; \
    wget https://github.com/openspug/spug/archive/v${SPUG_VERSION}.tar.gz; \
    tar zxf v${SPUG_VERSION}.tar.gz -C /spug --strip-components 1; \
    rm -rf v${SPUG_VERSION}.tar.gz; \
    # 安装依赖
    cd /spug/spug_api; \
    python3 -m venv venv; \
    source venv/bin/activate; \
    # 安装python包
    pip install --no-cache-dir -r requirements.txt -i https://mirrors.aliyun.com/pypi/simple/; \
    pip install --no-cache-dir gunicorn -i https://mirrors.aliyun.com/pypi/simple/; \
    # 前端代码
    wget https://github.com/openspug/spug/releases/download/v${SPUG_VERSION}/spug_web_${SPUG_VERSION}.tar.gz; \
    tar zxf spug_web_${SPUG_VERSION}.tar.gz -C /spug/spug_web/; \
    rm -rf spug_web_${SPUG_VERSION}.tar.gz; \
    apk del .build-deps; \
    { \
        echo 'import os'; \
        echo 'BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))'; \
        echo 'DEBUG = False'; \
        echo "DATABASES = {"; \
        echo "    'default': {"; \
        echo "        'ATOMIC_REQUESTS': True,"; \
        echo "        'ENGINE': 'django.db.backends.sqlite3',"; \
        echo "        'NAME': os.path.join(BASE_DIR, 'db/db.sqlite3'),"; \
        echo "    }"; \
        echo "}"; \
    } | tee /spug/spug_api/spug/overrides.py;

ADD spug.ini /etc/supervisor.d/spug.ini
ADD default.conf /etc/nginx/conf.d/default.conf
ADD entrypoint.sh /entrypoint.sh

CMD ["sh", "/entrypoint.sh"]