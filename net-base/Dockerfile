# Basic Xinetd Docker Container

FROM debian
MAINTAINER ctf@unswsecurity.com
ENTRYPOINT ["xinetd", "-dontfork"]

# Apt-get update
RUN apt-get update

# Install xinetd
RUN apt-get install -y xinetd
RUN update-rc.d xinetd disable
ADD xinetd.conf /etc/xinetd.conf

# Add the ctf dir
RUN mkdir /home/ctf
RUN chmod 775 /home/ctf

# Add the ctf user
RUN useradd -M -U\
    -d /home/ctf \
    ctf

RUN chown ctf:ctf /home/ctf

# Add the dummy binary
ADD dummy /home/ctf/
RUN chmod 775 /home/ctf/dummy

# Link the to the service
ADD run-service /usr/local/bin/run-service
RUN chmod 775 /usr/local/bin/run-service
RUN ln -s /home/ctf/dummy /usr/local/bin/ctf-service
    
# Expose the service port
EXPOSE 9090
