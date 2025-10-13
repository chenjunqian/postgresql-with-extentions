# Project Overview

This project provides a Dockerized PostgreSQL 17 environment with the `pgvector` and `pgroonga` extensions pre-installed. The primary purpose is to support a job matching application.

The `pgvector` extension is used for storing and querying vector embeddings, likely for semantic matching of job descriptions and user resumes. The `pgroonga` extension provides fast full-text search capabilities.

## Building and Running

## Building the Docker Image

To build the Docker image, run the following command:

```bash
./build.sh
```

This will build the image with the tag `pg17-with-extensions`.

## Running the Docker Container

To run the Docker container, use the following command:

```bash
./run.sh
```

This will start the container in detached mode and map port 5432 to the host. The following environment variables are set:

* `POSTGRES_USER`: `jdmatcher`
* `POSTGRES_PASSWORD`: `qazxsw`
* `POSTGRES_DB`: `jdmatcherdb`

The container will be named `postgres17-with-extensions`.

## Database Schema

The database is initialized with the following schema:

## Extensions

* `vector`: For storing and querying vector embeddings.
* `pgroonga`: For full-text search.

## Tables

* `job_detail`: Stores job postings.
  * `id`: Primary key.
  * `title`: Job title.
  * `job_desc`: Job description (indexed with pgroonga).
  * `job_tags`: Tags associated with the job.
  * `link`: Link to the job posting.
  * `source`: Source of the job posting.
  * `location`: Job location.
  * `salary`: Salary information.
  * `update_time`: Date of last update.
  * `job_desc_embedding`: Vector embedding of the job description.

* `user_info`: Stores user information.
  * `id`: Primary key.
  * `name`: User's name.
  * `email`: User's email.
  * `telegram_id`: User's Telegram ID.
  * `resume_embedding`: Vector embedding of the user's resume.
  * `resume`: Text of the user's resume.
  * `job_expectations`: User's job expectations.

* `user_matched_job`: Stores matches between users and jobs.
  * `user_id`: Foreign key to `user_info`.
  * `job_id`: Foreign key to `job_detail`.
  * `update_time`: Timestamp of the match.
  * `notification`: Whether a notification has been sent.
  * `match_score`: The score of the match.
  * `match_reason`: The reason for the match.
