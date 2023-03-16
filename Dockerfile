FROM debian:11

ENV DEBIAN_FRONTEND=noninteractive

# Set the reports directory environment variable
ENV ROBOT_REPORTS_DIR /opt/robotframework/reports

# Set the tests directory environment variable
ENV ROBOT_TESTS_DIR /opt/robotframework/tests

# Set the working directory environment variable
ENV ROBOT_WORK_DIR /opt/robotframework/temp

# Dependency versions
ENV ROBOT_FRAMEWORK_VERSION 5.0

# Install system dependencies
RUN apt-get update && \
  apt-get -y install sudo \
  unzip \
  libxi6 \
  npm \
  nodejs \
  libgconf-2-4 \
  locales \
  libnss3 \
  libnspr4 \
  libasound2 \
  netcat \
  gnupg \
  python3-pip \
  python3-dev \
  python3-tk \
  libgtk-3-dev \
  tzdata \
  xvfb \
  scrot \
  locales locales-all \
  && apt-get clean all


# Set the locale to german
RUN sed -i 's/^# *\(de_DE.UTF-8\)/\1/' /etc/locale.gen
RUN locale-gen

ENV LC_ALL de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE.UTF-8
ENV TZ CET


# Set number of threads for parallel execution
# By default, no parallelisation
ENV ROBOT_THREADS 1

# Define the default user who'll run the tests
ENV ROBOT_UID 1000
ENV ROBOT_GID 1000

# Prepare binaries to be executed
COPY scripts/run-tests-in-virtual-screen.sh /opt/robotframework/bin/
COPY requirements.txt /opt/robotframework/requirements.txt

# Install Robot Framework and associated libraries
RUN pip3 install \
  --no-cache-dir \
  robotframework==$ROBOT_FRAMEWORK_VERSION \
  PyYAML

WORKDIR /opt/robotframework/
RUN pip3 install --no-cache-dir -r requirements.txt

RUN rfbrowser init

WORKDIR /

# Create the default report and work folders with the default user to avoid runtime issues
# These folders are writeable by anyone, to ensure the user can be changed on the command line.
RUN mkdir -p ${ROBOT_REPORTS_DIR} \
  && mkdir -p ${ROBOT_WORK_DIR} \
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_REPORTS_DIR} \
  && chown ${ROBOT_UID}:${ROBOT_GID} ${ROBOT_WORK_DIR} \
  && chmod ugo+w ${ROBOT_REPORTS_DIR} ${ROBOT_WORK_DIR}

# Set Locale Env
ENV LC_ALL de_DE.UTF-8
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE.UTF-8


# Allow any user to write logs
RUN chmod ugo+w /var/log \
  && chown ${ROBOT_UID}:${ROBOT_GID} /var/log

# Update system path
ENV PATH=/opt/robotframework/bin:/opt/robotframework/drivers:$PATH

# Set up a volume for the generated reports
VOLUME ${ROBOT_REPORTS_DIR}

USER ${ROBOT_UID}:${ROBOT_GID}

# A dedicated work folder to allow for the creation of temporary files
WORKDIR ${ROBOT_WORK_DIR}

# Execute all robot tests
CMD ["run-tests-in-virtual-screen.sh"]
