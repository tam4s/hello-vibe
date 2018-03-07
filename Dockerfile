FROM ubuntu as builder

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install curl wget xz-utils gcc git libz-dev libevent-dev libssl-dev libcurl4-openssl-dev

WORKDIR /tmp/ldc

RUN if [ $(uname -m) = x86_64 ]; then \
		wget https://github.com/ldc-developers/ldc/releases/download/v1.8.0/ldc2-1.8.0-linux-x86_64.tar.xz && \
		tar xf ldc2-1.8.0-linux-x86_64.tar.xz && \
		mv ldc2-1.8.0-linux-x86_64 /opt/ldc2; \
	elif [ $(uname -m) = armv7l ]; then \
		wget https://github.com/ldc-developers/ldc/releases/download/v1.8.0/ldc2-1.8.0-linux-armhf.tar.xz && \
		tar xf ldc2-1.8.0-linux-armhf.tar.xz && \
		mv ldc2-1.8.0-linux-armhf /opt/ldc2; \
	else \
		echo Unknown architecture: $(uname -m) && \
		exit 1; \
	fi

RUN ln -sf /opt/ldc2/bin/dub /usr/bin/dub

WORKDIR /tmp/app

RUN for package_name in \
		vibe-d:0.8.2 \
		; do \
	package="$(echo $package_name | cut -d: -f1)"; \
	version="$(echo $package_name | grep : |cut -d: -f2)"; \
	version="${version:-*}"; \
		printf "/++dub.sdl: name\"foo\"\ndependency\"${package}\" version=\"${version}\"+/\n void main() {}" > foo.d; \
		dub fetch "${package}" --version="${version}"; \
		dub build -b release --single foo.d; \
		rm -f foo*; \
		rm -rf .dub/build; \
	done

ADD source ./source
ADD dub.json ./

RUN dub build -b release

FROM alpine
WORKDIR /opt/app
COPY --from=builder /tmp/app/hello-vibe /opt/app/
RUN adduser -D myuser
USER myuser
EXPOSE 8888
CMD /opt/app/hello-vibe
