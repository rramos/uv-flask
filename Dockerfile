FROM python:3.12-slim-bookworm
COPY --from=ghcr.io/astral-sh/uv:0.7.13 /uv /uvx /bin/

EXPOSE 5000

# Copy the project into the image
ADD . /app

# Sync the project into a new environment, asserting the lockfile is up to date
WORKDIR /app

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev

# Place executables in the environment at the front of the path
ENV PATH="/app/.venv/bin:$PATH"

# Reset the entrypoint, don't invoke `uv`
ENTRYPOINT []

# Run the FastAPI application by default
# Uses `fastapi dev` to enable hot-reloading when the `watch` sync occurs
# Uses `--host 0.0.0.0` to allow access from outside the container
CMD ["flask", "run","--host=0.0.0.0"]