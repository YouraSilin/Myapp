# syntax=docker/dockerfile:1
FROM ruby:3.1.2
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
RUN gem install bootstrap -v 5.2.0


# libvips
RUN apt-get update && apt-get install -y \
	build-essential \
	unzip \
	wget \
	git \
	pkg-config 

# stuff we need to build our own libvips ... this is a pretty random selection
# of dependencies, you'll want to adjust these
RUN apt-get install -y \
	glib-2.0-dev \
	libexpat-dev \
	librsvg2-dev \
	libpng-dev \
	libgif-dev \
	libjpeg-dev \
	libexif-dev \
	liblcms2-dev \
	liborc-dev 

ARG VIPS_VERSION=8.12.2
ARG VIPS_URL=https://github.com/libvips/libvips/releases/download

RUN apt-get install -y \
	wget

RUN cd /usr/local/src \
	&& wget ${VIPS_URL}/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz \
	&& tar xzf vips-${VIPS_VERSION}.tar.gz \
	&& cd vips-${VIPS_VERSION} \
	&& ./configure \
	&& make V=0 \
	&& make install

RUN apt-get install -y \
        ruby-dev \
        libffi-dev

RUN gem install ruby-vips

RUN rails active_storage:install

RUN rails g devise:install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
