FROM python:3.9.12-slim-bullseye

RUN apt-get update && apt-get install -y build-essential tar curl zip unzip git pkg-config

RUN git clone https://github.com/microsoft/vcpkg /tmp/vcpkg

RUN ./tmp/vcpkg/bootstrap-vcpkg.sh && \
    export CXXFLAGS="$CXXFLAGS -fPIC" && \
    ./tmp/vcpkg/vcpkg install seal[no-throw-tran] kuku log4cplus cppzmq flatbuffers jsoncpp apsi

ENV VCPKG_INSTALLED_DIR=/tmp/vcpkg/installed

RUN mkdir /tmp/pyapsi
COPY ./setup.py /tmp/pyapsi/setup.py
COPY ./pyproject.toml /tmp/pyapsi/pyproject.toml
COPY ./poetry.lock /tmp/pyapsi/poetry.lock
COPY ./src /tmp/pyapsi/src
COPY ./examples /tmp/pyapsi/examples

WORKDIR /tmp/pyapsi

RUN pip install poetry && \
    poetry install && \
    poetry run pip install --verbose .

#RUN poetry run python examples/advanced.py
CMD ["poetry", "run", "python", "examples/advanced.py"]