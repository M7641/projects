FROM python:3.11-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
	    build-essential \
	    git \
	&& apt-get autoclean autoremove \
	&& rm -rf /var/lib/apt/lists/*

ARG GITHUB_TOKEN_GITHUB
ARG API_KEY_CUSTOM

ARG CONFIG_REPOSITORY
ARG CONFIG_FILE_NAME

ARG STAGE
ARG TENANT
ARG REDSHIFT_USERNAME
ARG REDSHIFT_PASSWORD
ARG REDSHIFT_HOST
ARG REDSHIFT_PORT
ARG REDSHIFT_IAM_ROLE
ARG DATA_LAKE
ARG DATA_LAKE_TYPE
ARG DATA_LAKE_ROOT_PATH
ARG DATA_WAREHOUSE_TYPE
ARG SNOWFLAKE_WAREHOUSE
ARG SNOWFLAKE_PORT
ARG SNOWFLAKE_PASSWORD
ARG SNOWFLAKE_ACCOUNT
ARG SNOWFLAKE_DATABASE
ARG SNOWFLAKE_USERNAME
ARG SNOWFLAKE_ROLE
ARG SNOWFLAKE_SCHEMA
ARG SNOWFLAKE_APPLICATION
ARG SNOWFLAKE_INTEGRATION
ARG GITHUB_TOKEN
ARG API_KEY
ENV STAGE=$STAGE \
    TENANT=$TENANT \
    REDSHIFT_USERNAME=$REDSHIFT_USERNAME \
    REDSHIFT_PASSWORD=$REDSHIFT_PASSWORD \
    REDSHIFT_HOST=$REDSHIFT_HOST \
    REDSHIFT_PORT=$REDSHIFT_PORT \
    REDSHIFT_IAM_ROLE=$REDSHIFT_IAM_ROLE \
    DATA_LAKE=$DATA_LAKE \
    DATA_LAKE_TYPE=$DATA_LAKE_TYPE \
    DATA_LAKE_ROOT_PATH=$DATA_LAKE_ROOT_PATH \
    SNOWFLAKE_WAREHOUSE=$SNOWFLAKE_WAREHOUSE \
    SNOWFLAKE_PORT=$SNOWFLAKE_PORT \
    SNOWFLAKE_PASSWORD=$SNOWFLAKE_PASSWORD \
    SNOWFLAKE_ACCOUNT=$SNOWFLAKE_ACCOUNT \
    SNOWFLAKE_DATABASE=$SNOWFLAKE_DATABASE \
    SNOWFLAKE_USERNAME=$SNOWFLAKE_USERNAME \
    SNOWFLAKE_ROLE=$SNOWFLAKE_ROLE \
    SNOWFLAKE_SCHEMA=$SNOWFLAKE_SCHEMA \
    SNOWFLAKE_APPLICATION=$SNOWFLAKE_APPLICATION \
    SNOWFLAKE_INTEGRATION=$SNOWFLAKE_INTEGRATION \
    DATA_WAREHOUSE_TYPE=$DATA_WAREHOUSE_TYPE \
    API_KEY=$API_KEY_CUSTOM \
    GITHUB_TOKEN=$GITHUB_TOKEN_GITHUB \
    CONFIG_REPOSITORY=$CONFIG_REPOSITORY \
    CONFIG_FILE_NAME=$CONFIG_FILE_NAME

# ----------------------------------------
# Non-Root User Creation!
# ----------------------------------------
ARG PEAK_USER_ID
ENV PEAK_USER_ID=$PEAK_USER_ID

RUN useradd -m -d /home/peak-user -u $PEAK_USER_ID peak-user
RUN chown -R peak-user:peak-user /home/peak-user
WORKDIR /home/peak-user
USER $PEAK_USER_ID

COPY --chown=peak-user . .

RUN git config --global url."https://${GITHUB_TOKEN_GITHUB}@github.com/".insteadOf "https://github.com/" \
    && python -m pip install --no-cache-dir --upgrade pip setuptools wheel \
    && python -m pip install --no-cache-dir metis@git+https://github.com/PeakBI/ds-Metis@main \
    && git config --global --unset url."https://${GITHUB_TOKEN_GITHUB}@github.com/".insteadOf


ENV PATH="${PATH}:/home/peak-user/.local/bin"
