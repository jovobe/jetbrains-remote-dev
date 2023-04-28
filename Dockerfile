FROM ubuntu:latest

LABEL maintainer="Johan M. von Behren <johan@vonbehren.eu>"
LABEL version="0.1.0"
LABEL description="Image to run Jetbrains IDEs backend in a container."

# Set the environment variables
ENV SSH_USERNAME=jetbrains
ENV SSH_PASSWORD=jetbrains

# Install dependencies
RUN apt update && apt upgrade -y && \
	apt install openssh-server git htop sudo -y && \
	systemctl enable ssh

# Create a new user with the specified username and group
RUN groupadd ${SSH_USERNAME} && \
    useradd -m -s /bin/bash -g ${SSH_USERNAME} ${SSH_USERNAME} && \
    echo "${SSH_USERNAME}:${SSH_PASSWORD}" | chpasswd && \
    adduser ${SSH_USERNAME} sudo

#RUN mkdir -p /home/${SSH_USERNAME}/.config/JetBrains && \
#    chown -R ${SSH_USERNAME}:${SSH_USERNAME} /home/${SSH_USERNAME}/.config/JetBrains

# Add the startup script
ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

# Create the project directory and set the owner to the new user
RUN mkdir -p /opt/project && \
    chown -R ${SSH_USERNAME}:${SSH_USERNAME} /opt/project

# Create the PhpStorm directory and set the owner to the new user
RUN mkdir -p /opt/PhpStorm && \
    chown -R ${SSH_USERNAME}:${SSH_USERNAME} /opt/PhpStorm

# Switch to the new user
USER ${SSH_USERNAME}

# Provide project and PhpStorm directory as volumes
VOLUME [ "/opt/project", "/opt/PhpStorm" ]

# Set the working directory
WORKDIR /opt/project

# Expose the SSH port
EXPOSE 22

# Start the startup script
CMD [ "/startup.sh" ]
